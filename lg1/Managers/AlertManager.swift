//
//  AlertManager.swift
//  lg1
//
//  Created by Andrej on 4/17/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import Foundation

class AlertManager {
    
    static func alertWithTitle(title: String!, message: String, viewController: UIViewController, toFocus textField: UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: { _ in
            textField.becomeFirstResponder()
        });
        alert.addAction(action)
        viewController.present(alert, animated: true, completion:nil)
    }
    
}
