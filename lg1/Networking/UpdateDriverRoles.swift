//
//  CreateDriver.swift
//  lg1
//
//  Created by Andrej on 4/17/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpdateDriverRoles: BasePutRequest {
    
    private var driverID: String
    private var updatedRoles: [String]
    
    
    init(driverID: String, updatedRoles: [String] ) {
        self.driverID = driverID
        self.updatedRoles = updatedRoles

    }
    
    override func path() -> String {
        return "/users/\(driverID)/roles"
    }
    
    override func params() -> [String : Any]? {
        return [
            "roles": updatedRoles
        ]
    }
    
    override func success(response: JSON) {
        
        Messages.updateDriverRolesSuccess.fire(())
        
    }
    
    override func failure(code: Int, error: String, errors: Errors?) {
        Messages.updateDriverRolesFailure.fire(error)
    }
    
}
