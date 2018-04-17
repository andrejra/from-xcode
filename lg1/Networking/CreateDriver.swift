//
//  CreateDriver.swift
//  lg1
//
//  Created by Andrej on 4/17/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreateDriver: BasePostRequest {
    
    private var email: String
    private var password: String
    private var firstName: String
    private var lastName: String
    private var phone: String
    private var confirmPassword: String
    private var updatedRoles: [String]
    
    init(email: String, password: String, firstName: String, lastName: String, phone: String, confirmPassword: String, updatedRoles: [String]) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.confirmPassword = confirmPassword
        self.updatedRoles = updatedRoles    }
    
    override func path() -> String {
        return "/users/new"
    }
    
    override func params() -> [String : Any]? {
        return [
            "first_name": firstName,
            "last_name": lastName,
            "cellphone": phone,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "roles": updatedRoles
        ]
    }
    
    override func success(response: JSON) {
      
        Messages.createDriverSuccess.fire(())
        
    }
    
    override func failure(code: Int, error: String, errors: Errors?) {
        Messages.createDriverFailure.fire(error)
    }
    
}
