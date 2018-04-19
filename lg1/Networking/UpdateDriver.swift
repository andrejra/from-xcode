//
//  CreateDriver.swift
//  lg1
//
//  Created by Andrej on 4/17/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpdateDriver: BasePutRequest {
    
    private var firstName: String
    private var lastName: String
    private var phone: String
    private var driverID: String
    
    init(driverID: String, firstName: String, lastName: String, phone: String) {
        self.driverID = driverID
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
    
    override func path() -> String {
        return "/profiles/\(driverID)"
    }
    
    override func params() -> [String : Any]? {
        return [
            "first_name": firstName,
            "last_name": lastName,
            "cellphone": phone,
        ]
    }
    
    override func success(response: JSON) {
        
        Messages.updateDriverSuccess.fire(())
        
    }
    
    override func failure(code: Int, error: String, errors: Errors?) {
        Messages.updateDriverFailure.fire(error)
    }
    
}
