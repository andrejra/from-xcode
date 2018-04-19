//
//  Vozac.swift
//  lg1
//
//  Created by Andrej on 2/21/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import SwiftyJSON

enum DriverStatus: String {
    case Changed = "changed"
    case Idle = "idle"
    case OnLane = "on_lane"
    case Incomplete = "incomplete"
    case Invited = "invited"
    case Disabled = "disabled"
    case Rejected = "rejected"
    case PendingVerification = "pending_verification"
    case OnShipment = "on_shipment"
}

class Vozac {
    
    var ime: String?
    var prezime: String?
    var username: String?
    var email: String?
    var phone: String?
    var roles: [String]?
    var driverStatus: DriverStatus?
    var driverID: String?
    
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
        if let jsonStatus = json["driver_status"].string {
            driverStatus = DriverStatus(rawValue: jsonStatus)
        }
        if let jsonDriverID = json["id"].string{
            driverID = jsonDriverID
        }
    }
    
}
