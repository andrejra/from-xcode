//
//  CustomView.swift
//  lg1
//
//  Created by Andrej on 3/2/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit
@IBDesignable

class CustomView: UIView {


    @IBInspectable var borderWidth: CGFloat = 0.0{
        
        didSet{
            
            self.layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
    }
    
}
