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

    static let postRequestFailed = Signal<Int>()
    static let apiFailure = Signal<String>()
    static let authFailure = Signal<String>()
    
    static let loginSuccess = Signal<String?>()
    static let loginFailure = Signal<String>()
    
}
