//
//  SettingsManager.swift
//  lg1
//
//  Created by Andrej
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
class SettingsManager {
    
    private static let userDefaults = UserDefaults.standard
    
    static var authToken: String {
        get {
            return userDefaults.object(forKey: "authToken") as? String ?? ""
        }
        
        set {
            userDefaults.set(newValue, forKey: "authToken")
        }
    }
}
