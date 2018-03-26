//
//  CheckBoxButton.swift
//  lg1
//
//  Created by Andrej on 3/26/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit

class CheckBoxButton: UIButton {

    var isON = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
 
    func initButton() {
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: 25.0).isActive = true
//        widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        setImage(#imageLiteral(resourceName: "empty-checkbox"), for: .normal)
        addTarget(self, action: #selector(CheckBoxButton.buttonPressed), for: .touchUpInside)
        
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isON)
    }
    
    func activateButton(bool: Bool) {
        isON = bool
        print(isON)
        let image = bool ? #imageLiteral(resourceName: "checked-box"):#imageLiteral(resourceName: "empty-checkbox")
        setImage(image, for: .normal)
        let createDriverVC = CreateDriverViewController()  // PROVERITI !!!!
        createDriverVC.changeRoles(tag: tag, selected: isON)    // PROVERITI !!!!
//        CreateDriverViewController.changeRoles(tag) // PROVERITI !!!!
    }
    func didSelect() {
        
    }
}
