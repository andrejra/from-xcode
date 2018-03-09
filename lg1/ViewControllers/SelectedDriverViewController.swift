//
//  SelectedDriverViewController.swift
//  lg1
//
//  Created by Andrej on 2/21/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit

class SelectedDriverViewController: UIViewController {
    //TODO: add driver
    var driver: Vozac?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imeTxt.text = driver?.ime
        prezimeTxt.text = driver?.prezime
        IDtxt.text = driver?.id
        EmailTxt.text = driver?.email
        PhoneTxt.text = driver?.phone
        
        navigationItem.title =  imeTxt.text! + " " + prezimeTxt.text!
    }

    @IBOutlet weak var imeTxt: UITextField!
    @IBOutlet weak var prezimeTxt: UITextField!
    @IBOutlet weak var IDtxt: UITextField!
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PhoneTxt: UITextField!
}
