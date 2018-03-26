//
//  Constants.swift
//  lg1
//
//  Created by Andrej on 3/26/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    static let fr8hubBlue = UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    static let fr8hubOrange = UIColor(rgb: 0xBB5615)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
