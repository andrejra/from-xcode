//
//  AddDriverViewController.swift
//  lg1
//
//  Created by Andrej on 2/21/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit

class AddDriverViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var driver: Vozac?
    
    @IBOutlet weak var saveDriverBtn: UIBarButtonItem!
    @IBOutlet weak var txtIme: UITextField!
    @IBOutlet weak var txtPrezime: UITextField!
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveDriverBtn else {
            
            return
        }

        let ime = txtIme.text ?? ""
        let prezime = txtPrezime.text ?? ""
        let id = txtID.text ?? ""
        let email = txtEmail.text ?? ""
        let phone = txtPhone.text ?? ""
        let roles = ["asdf", "asdf"] //temp fix
        
        driver = Vozac(ime: ime, prezime: prezime, email: email, id: id, phone: phone, roles: roles)
        
    }
    
    
}
