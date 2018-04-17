//
//  Logout.swift
//  lg1
//
//  Created by Andrej on 4/17/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

class Logout: BasePostRequest {
    
    override func path() -> String {
        return "/logout"
    }
    
    override func success(response: JSON) {
        print("AR: Log Out ok")
        Messages.logoutSuccess.fire(())
    }
    
    override func failure(code: Int, error: String, errors: Errors?) {
        Messages.logoutFailure.fire(error)
    }
    
}
