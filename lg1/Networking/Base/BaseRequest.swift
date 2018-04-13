//
//  BaseRequest.swift
//  ios
//
//  Created by Sasa Slavnic on 6/14/16.
//  Copyright © 2016 freighthub. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseRequest {
    
    var dryRun = false
    
    func params() -> [String: Any]? {
        return nil
    }
    
    func path() -> String {
        assert(false, "path() of BaseRequest must be overridden by the sublcass.")
        return ""
    }
    
    func authHeaders() -> [String : String] {
        var headers = [String : String]()

        headers["Authorization"] = "Bearer \(SettingsManager.authToken)"
        headers["x-error-version"] = "2"
        headers["x-dry-run"] = dryRun ? "true" : "false"
        
        return headers
    }
    
    func makeUrl() -> String {
        return Config.kBaseApiUrl + path()
    }
    
    final func execute() {
        let url = makeUrl()
        
        let headers = authHeaders()
        
        doExecute(url: url, headers: headers)
    }
    
    func doExecute(url: String, headers: [String : String]?) {
        assert(false, "doExecute() of BaseRequest should never be called. Use BaseGetRequest or BasePostRequest as your base class.")
    }
    
    final func handleResponse(response: DataResponse<Any>) {
        if response.result.isFailure {
            if let resp = response.response {
                if resp.statusCode == 401 {
                    authFailure(error: NSLocalizedString("unauthorized", comment: "Server problem error text"))
                } else {
                    failure(code: resp.statusCode, error: NSLocalizedString("problem_reaching_servers", comment: "Server problem error text"), errors: nil)
                }
            } else {
                failure(code: -1, error: response.result.error?.localizedDescription ?? NSLocalizedString("unknown_error", comment: "Server problem error text"), errors: nil) //no response status code
            }
        } else {
            if let value = response.result.value {
                let json = JSON(value)
                
                if Config.debugRequests {
                    debugPrint(json)
                }
            
                if var error = json["error"].string {
                    if let resp = response.response {
                        if resp.statusCode == 401 {
                            authFailure(error: error)
                        } else if resp.statusCode == 422 {
                            let errors = Errors(errors: json["errors"].dictionary)
                            failure(code: resp.statusCode, error: error, errors: errors)
                        } else {
                            if let status = json["status"].string {
                                error = "\(error): \(status)"
                            }

//                            if let reason = json["reason"].string {
//                                error = TranslationUtils.buildErrorStringFrom(error: error, reason: reason)
//                            }

                            let errors = Errors(errors: json["errors"].dictionary)
                            failure(code: resp.statusCode, error: error, errors: errors)
                        }
                    }
                } else {
                    if let resp = response.response {
                        success(statusCode: resp.statusCode, response: json)
                    }
                }
            } else {
                if response.response?.statusCode == 401 {
                    authFailure(error: NSLocalizedString("unauthorized", comment: ""))
                } else {
                    failure(code: response.response?.statusCode ?? -1, error: NSLocalizedString("unknown_error", comment: "Server problem error text"), errors: nil)
                }
            }
        }
    }

    func success(statusCode: Int, response: JSON) {
        // Override in children if needed
        success(response: response)
    }

    func success(response: JSON) {
        // Override in children if needed
    }
    
    func failure(code: Int, error: String, errors: Errors?) {
        var errorMessage = error
        
        if let errors = errors {
            errorMessage += errors.asString()
        }
        
        Messages.apiFailure.fire(errorMessage)
    }
    
    func authFailure(error: String) {
        // Override in children if needed
        Messages.authFailure.fire(error)
    }
}

class BaseGetRequest: BaseRequest {
    
    override final func doExecute(url: String, headers: [String : String]?) {
        let request = Alamofire.request(url, parameters: params(), encoding: URLEncoding.default, headers: headers)

        if Config.debugRequests {
            debugPrint(request)
        }
        
        request.responseJSON(completionHandler: handleResponse)
    }
    
}

class BasePostRequest: BaseRequest {
    
    override final func doExecute(url: String, headers: [String : String]?) {
        let request = Alamofire.request(url, method: .post, parameters: params(), encoding: JSONEncoding.default, headers: headers)

        if Config.debugRequests {
            debugPrint(request)
        }

        request.responseJSON(completionHandler: handleResponse)
    }
    
}

class BasePutRequest: BaseRequest {
    
    override final func doExecute(url: String, headers: [String : String]?) {
        let request = Alamofire.request(url, method: .put, parameters: params(), encoding: JSONEncoding.default, headers: headers)
        
        if Config.debugRequests {
            debugPrint(request)
        }

        request.responseJSON(completionHandler: handleResponse)
    }
    
}

class BaseDeleteRequest: BaseRequest {
    
    override final func doExecute(url: String, headers: [String : String]?) {
        let request = Alamofire.request(url, method: .delete, parameters: params(), encoding: JSONEncoding.default, headers: headers)
        
        if Config.debugRequests {
            debugPrint(request)
        }
        
        request.responseJSON(completionHandler: handleResponse)
    }
    
}

class BaseUploadRequest: BaseRequest {
    
    var data: Data
    var name: String
    var mimeType: String
    
    init(data: Data, name: String, mimeType: String) {
        self.data = data
        self.name = name
        self.mimeType = mimeType
    }
    
    override func makeUrl() -> String {
        return path()
    }
    
    override final func doExecute(url: String, headers: [String : String]?) {
        var urlWithHost = url
        
        if !url.contains("https://") && !url.contains("http://") {
            urlWithHost = Config.kFileServerUrl + url
        }
        
        let finalUrl = try! URLRequest(url: URL(string: urlWithHost)!, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { data in
            data.append(self.data, withName: self.name, fileName: self.name, mimeType: self.mimeType)
        }, with: finalUrl, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.handleResponse(response: response)
                }
                
                break
            case .failure( _ ):
                break
            }
        })
    }
    
}
