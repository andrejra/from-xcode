//
//  Vozac.swift
//  lg1
//
//  Created by Andrej on 2/21/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

class Vozac {
    
    var ime: String?
    var prezime: String?
    var username: String?
    var email: String?
    var phone: String?
    var roles: [String]?
    
    init(ime: String, prezime: String, email: String, username: String, phone: String, roles: [String]) {
        self.ime = ime
        self.prezime = prezime
        self.username = username
        self.email = email
        self.phone = phone
        self.roles = roles
    }

    init(jsonDriver: [String : Any]) {
        if let firstName = jsonDriver["first_name"] as? String{
            ime = firstName
        }
        if let lastName = jsonDriver["last_name"] as? String{
            prezime = lastName
        }
        if let jsonUsername = jsonDriver["username"] as? String{
            username = jsonUsername
        }
        if let jsonEmail = jsonDriver["email"] as? String{
            email = jsonEmail
        }
        if let cellphone = jsonDriver["cellphone"] as? String{
            phone = cellphone
        }
        if let jsonRoles = jsonDriver["roles"] as? [String]{
            roles = jsonRoles
        }
    }
    
    init(json: JSON) {
        if let firstName = json["first_name"].string{
            ime = firstName
        }
        if let lastName = json["last_name"].string{
            prezime = lastName
        }
        if let jsonUsername = json["username"].string{
            username = jsonUsername
        }
        if let jsonEmail = json["email"].string{
            email = jsonEmail
        }
        if let cellphone = json["cellphone"].string{
            phone = cellphone
        }
        if let jsonRoles = json["roles"].arrayObject as? [String]{
            roles = jsonRoles
        }
        
    }
    
}
