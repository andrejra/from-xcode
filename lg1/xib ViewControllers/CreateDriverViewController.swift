//
//  CreateDriverViewController.swift
//  lg1
//
//  Created by Andrej
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit
import Alamofire_SwiftyJSON
import Alamofire

class CreateDriverViewController: UIViewController {

    @IBOutlet weak var countryPrefixTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var phoneBottomView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var firstNameBottomView: UIView!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lastNameBottomView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var emailNameBottomView: UIView!
    @IBOutlet weak var loginDetailsView: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var usernameBottomView: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var passwordBottomView: UIView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var confirmPasswordBottomView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var chkboxDriver: CheckBoxButton!
    @IBOutlet weak var chkboxAdmin: CheckBoxButton!
    @IBOutlet weak var chkboxAccountant: CheckBoxButton!
    @IBOutlet weak var chkboxDispatcher: CheckBoxButton!
    
    let countries = ["USA", "MEX"]
    var selectedCountry: String?
    var countryCode: String?
    var driver: Vozac?
    var isUserEditing = false
    var roles: [String: Bool] = ["driver": false, "admin": false, "accountant": false, "dispatcher": false]
    
    
//    override func viewDidLayoutSubviews() {
//        //TODO: viewDidLayoutSubviews called multiple times
//        super.viewDidLayoutSubviews()
//        //TODO: when do constraints get initialized
//        let contentSize = scrollView.contentSize
//        self.scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + 600)
//
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (driver == nil) {
            self.title = "Create User"
        }
        else {
            isUserEditing = true
            self.title = "Edit User"
            txtEmail.isEnabled = false
            loginDetailsView.isHidden = true
        }
        
        createTxtFieldDelegate()
        populateDriver()
        setUpPickerView()
        createToolbar()
        formatButton()
        formatTxtPlaceholder()
        extendScrollViewObservers()
        setBarButtons()
        
    }
    

    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        countryPrefixTxt.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func formatButton() {
        btnSave.backgroundColor = Colors.fr8hubBlue
        btnSave.layer.cornerRadius = 5
        btnSave.layer.borderWidth = 1
        if isUserEditing {
            btnSave.setTitle("Update", for: .normal)
        }
    }
    
    func createTxtFieldDelegate() {
        txtEmail?.delegate = self
        txtLastName?.delegate = self
        txtPassword?.delegate = self
        txtUsername?.delegate = self
        txtFirstName?.delegate = self
        txtConfirmPassword?.delegate = self
    }
    
    func formatTxtPlaceholder()  {
        txtConfirmPassword?.attributedPlaceholder = NSAttributedString(string: "Confirm Password*", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtFirstName?.attributedPlaceholder = NSAttributedString(string: "First Name*", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtUsername?.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtPassword?.attributedPlaceholder = NSAttributedString(string: "Password*", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtLastName?.attributedPlaceholder = NSAttributedString(string: "Last Name*", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtEmail?.attributedPlaceholder = NSAttributedString(string: "Email*", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
    }

    func extendScrollViewObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //Scroll View - on Keyboard appear
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 25 // + 25 zbog keyboard dictionary
        self.scrollView.contentInset = contentInset
    }
    // Scroll View disappear w/ Keyboard
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    func setBarButtons() {
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButton(item1, animated: true)
        
        if (isUserEditing) {
            let btn2 = UIButton(type: .custom)
            btn2.setImage(UIImage(named: "remove-driver"), for: .normal)
            btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn2.addTarget(self, action: #selector(deleteDriver), for: .touchUpInside)
            let item2 = UIBarButtonItem(customView: btn2)
            self.navigationItem.setRightBarButton(item2, animated: true)
        }
    }
    
    @objc func deleteDriver() {
        
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func customPopulateDriver() {
        if let selectedDriver = driver {
            phoneTxt.text = selectedDriver.phone
            countryCode = String((selectedDriver.phone?.prefix(2))!)
            txtFirstName.text = selectedDriver.ime
            txtLastName.text = selectedDriver.prezime
            txtEmail.text = selectedDriver.email
            txtUsername.text = selectedDriver.username
            for r in selectedDriver.roles! {
                switch r {
                case "driver":
                    changeRoles(tag: 1, selected: true)
                    chkboxDriver.setImage(#imageLiteral(resourceName: "checked-box"), for: .normal)
                    chkboxDriver.isON = true
                case "accountant":
                    changeRoles(tag: 3, selected: true)
                    chkboxAccountant.setImage(#imageLiteral(resourceName: "checked-box"), for: .normal)
                    chkboxAccountant.isON = true
                case "dispatcher":
                    changeRoles(tag: 4, selected: true)
                    chkboxDispatcher.setImage(#imageLiteral(resourceName: "checked-box"), for: .normal)
                    chkboxDispatcher.isON = true
                case "admin":
                    changeRoles(tag: 2, selected: true)
                    chkboxAdmin.setImage(#imageLiteral(resourceName: "checked-box"), for: .normal)
                    chkboxAdmin.isON = true
                default:
                    break
                }
            }
        }
    }
    
    func populateDriver() {
        if let selectedDriver = driver {
            phoneTxt.text = selectedDriver.phone
            countryCode = String((selectedDriver.phone?.prefix(2))!)
            txtFirstName.text = selectedDriver.ime
            txtLastName.text = selectedDriver.prezime
            txtEmail.text = selectedDriver.email
            txtUsername.text = selectedDriver.username
            for r in selectedDriver.roles! {
                switch r {
                case "driver":
                    chkboxDriver.isSelected = true
                case "accountant":
                    chkboxAccountant.isSelected = true
                case "dispatcher":
                    chkboxDispatcher.isSelected = true
                case "admin":
                    chkboxAdmin.isSelected = true
                default:
                    break
                }
            }
        }
    }
    
    func changeRoles(tag: Int, selected: Bool) {
        
        switch tag {
        case 1: roles["driver"] = selected
        case 2: roles["admin"] = selected
        case 3: roles["accountant"] = selected
        case 4: roles["dispatcher"] = selected
        default: print("error selecting")
        }
    }
    
    func setUpPickerView(){
        let countryPick = UIPickerView()
        countryPick.delegate = self
        countryPick.backgroundColor = .white
        countryPrefixTxt.inputView = countryPick
        switch countryCode {
        case "+1":
            countryPrefixTxt.text = countries[0]
        case "+5":
            countryPrefixTxt.text = countries[1]
        default:
            countryPrefixTxt.text = countries[0]
        }
    }
    
    // save Driver
    @IBAction func saveDriver(_ sender: Any) {
        if(!isUserEditing) {
            var updatedRoles: [String] = []
            let thereWereErrors = checkForErrors()
            if !thereWereErrors
            {
                if chkboxAdmin.isSelected {
                    updatedRoles.append("admin")
                }
                if chkboxDispatcher.isSelected {
                    updatedRoles.append("dispatcher")
                }
                if chkboxAccountant.isSelected {
                    updatedRoles.append("accountant")
                }
                if chkboxDriver.isSelected {
                    updatedRoles.append("driver")
                }
                
                let url = URL(string: "https://api-fhdev.vibe.rs/users/new")!
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(SettingsManager.authToken)",
                    "Content-Type": "application/json"
                ]
                let parameters: Parameters = [
                    "first_name": txtFirstName.text!,
                    "last_name": txtLastName.text!,
                    "cellphone": phoneTxt.text!,
                    "email": txtEmail.text!,
                    "password": txtPassword.text!,
                    "password_confirmation": txtConfirmPassword.text!,
                    "roles": updatedRoles
                ]
                
                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {
                    
                    response in
                    switch response.result {
                    case .success:
                        print("Validation Successful")
                        print("AR - Driver Saved")
                        self.popVC()
                        
                    case .failure:
                        if let httpStatusCode = response.response?.statusCode {
                            print(httpStatusCode)
                        }
                    }
                }
            }
        }
            
        else {
            
            // update btn..
            
        }
    }
    
    //validacija
    func checkForErrors() -> Bool
    {
        var errors = false
        let title = "Error"
        var message = ""
        if (txtFirstName.text?.isEmpty)! {
            errors = true
            message += "First name is empty"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtFirstName)
            
        }
        else if (txtLastName.text?.isEmpty)!
        {
            errors = true
            message += "Last Name is empty"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtLastName)

        }
        else if (txtEmail.text?.isEmpty)!
        {
            errors = true
            message += "Email is empty"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtEmail)
            
        }
        else if !((txtEmail.text?.contains("@"))!)
        {
            errors = true
            message += "Invalid Email Address"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtEmail)
            
        }
        else if (txtPassword.text?.isEmpty)!
        {
            errors = true
            message += "Password is empty"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:txtPassword)
        }
        else if (txtPassword.text?.count)!<6
        {

            errors = true
            message += "Password must be at least 6 characters"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtPassword)
        }
        else if !(txtPassword.text == txtConfirmPassword.text) {
            
            errors = true
            message += "Password don't match"
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtConfirmPassword)
        }
        
        return errors
    }
    
    // Validacija Custom Alert
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
    
}
    // Picker extension
extension CreateDriverViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[row]
        countryPrefixTxt.text = selectedCountry
    }
}
    // Text delegate extension
extension CreateDriverViewController: UITextFieldDelegate, UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let phone = phoneTxt, phone.isEditing {
            phoneBottomView?.backgroundColor = .blue
        }
    }
}
