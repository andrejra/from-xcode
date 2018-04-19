//
//  DeleteDriver.swift
//  lg1
//
//  Created by Andrej on 4/19/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeleteDriver: BaseDeleteRequest {
    
    private var driverID: String
    
    
    init(driverID: String) {
        self.driverID = driverID
    }
    
    override func path() -> String {
        return "/users/\(driverID)"
    }
    
    override func success(response: JSON) {
        print("AR: Driver Deleted")
        Messages.deleteDriverSuccess.fire(())
    }
    
    override func failure(code: Int, error: String, errors: Errors?) {
        Messages.deleteDriverFailure.fire(error)
    }
}
