//
//  Login.swift
//  lg1
//
//  Created by Andrej on 4/13/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

class Login: BasePostRequest {
    
    private var email: String
    private var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    override func path() -> String {
        return "/login"
    }
    
    override func params() -> [String : Any]? {
        return [
            "app": "mobile",
            "email": email,
            "password": password
        ]
    }
    
    override func success(response: JSON) {
        if let token = response["token"].string {
            print("AR: token - \(token)")
            SettingsManager.authToken = token
            Messages.loginSuccess.fire(nil)
        }
    }
    
    override func failure(code: Int, error: String, errors: Errors?) {
        Messages.loginFailure.fire(error)
    }
    
}
