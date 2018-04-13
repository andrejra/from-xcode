//
//  Errors.swift
//  ios
//
//  Created by sasas on 4/7/17.
//  Copyright © 2017 freighthub. All rights reserved.
//

import Foundation
import SwiftyJSON

class Errors {
    
    private var errors = [String : [JSON]]()
    private var parentKeys = [String]()
    
    init(errors: Dictionary<String, JSON>?) {
        fillErrors(parentKey: "", errors: errors)
    }
    
    func get(key: String) -> String? {
        if let jsonArray = errors[key] {
            let firstItem = jsonArray[0].stringValue
            return firstItem
        }
        
        return nil
    }
    
    func getJSONObject(key: String) -> JSON? {
        if let jsonArray = errors[key] {
            let firstItem = jsonArray[0]
            return firstItem
        }
        
        return nil
    }
    
    func asString() -> String {
        var result = ""
        
        for key in errors.keys {
            if let jsonArray = errors[key] {
                for i in 0 ..< jsonArray.count {
                    let item = jsonArray[i]
                    let translatedString =  item
                    result += "\n \(key): \(translatedString)"
                }
            }
        }
        
        return result
    }
    
    func fillErrors(parentKey: String, errors: Dictionary<String, JSON>?) {
        if let errors = errors {
            for key in errors.keys {
                parentKeys.append(key)
                
                if let errorsDictionary = errors[key]?.dictionary {
                    fillErrors(parentKey: "\(parentKey)\(key).", errors: errorsDictionary)
                }
                
                if let errorsValues = errors[key]?.array {
                    self.errors[key] = errorsValues
                }
            }
        }
    }
    
    func hasParentKey(_ key: String) -> Bool {
        return parentKeys.contains(key)
    }
    
}
