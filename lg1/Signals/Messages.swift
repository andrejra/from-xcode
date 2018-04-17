//
//  Messages.swift
//  lg1
//
//  Created by Andrej on 
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import Signals

class Messages {
    
    static let apiFailure = Signal<String>()
    static let authFailure = Signal<String>()
    
    static let loginSuccess = Signal<String?>()
    static let loginFailure = Signal<String>()
    
    static let getDriversSuccess = Signal<[Vozac]>()
    static let getDriversFailure = Signal<String>()
    
    static let logoutSuccess = Signal<Void>()
    static let logoutFailure = Signal<String>()
    
    static let createDriverSuccess = Signal<Void>()
    static let createDriverFailure = Signal<String>()
    
    
}
