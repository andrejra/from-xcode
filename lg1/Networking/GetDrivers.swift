//
//  GetDrivers.swift
//  lg1
//
//  Created by Andrej on 4/13/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetDrivers: BaseGetRequest {
    
    override func path() -> String {
        return "/drivers?page_size=100"
    }
    
    override func success(response: JSON) {
        var drivers = [Vozac]()
        if let jsonDrivers = response["entries"].array {
            for jsonDriver in jsonDrivers{
                let newDriver = Vozac(json: jsonDriver)
                drivers.append(newDriver)
                Messages.getDriversSuccess.fire(drivers)
            }
        }
    }
    
    override func failure(code: Int, error: String, errors: Errors?) {
        Messages.getDriversFailure.fire(error)
    }
}
