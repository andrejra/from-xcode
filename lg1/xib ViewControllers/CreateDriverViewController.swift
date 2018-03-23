//
//  CreateDriverViewController.swift
//  lg1
//
//  Created by Andrej on 3/22/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit
import Alamofire_SwiftyJSON

class CreateDriverViewController: UIViewController {

    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var phoneBottomView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chkboxDriver: UIImageView!
    @IBOutlet weak var chkboxAdmin: UIImageView!
    @IBOutlet weak var chkboxAccountant: UIImageView!
    @IBOutlet weak var chkboxDispatcher: UIImageView!
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
    
    let fr8hubBlue = UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    let countries = ["USA", "MEX"]
    var selectedCountry: String?
    var driver: Vozac?
    
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
        
        createTxtFieldDelegate()
        setUpPickerView()
        formatButton()
        formatTxtPlaceholder()
        extendScrollViewObservers()
        setBarButtons()
        populateDriver()
        
        if (driver == nil) {
            self.title = "Create User"
        }
        else {
            self.title = "Edit User"
        }

    }

    
    func setUpPickerView(){
        self.countryPicker.dataSource = self
        self.countryPicker.delegate = self
    }
    
    func formatButton() {
        btnSave.backgroundColor = fr8hubBlue
        btnSave.layer.cornerRadius = 5
        btnSave.layer.borderWidth = 1
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
        txtConfirmPassword?.attributedPlaceholder = NSAttributedString(string: "userPlaceholder", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtFirstName?.attributedPlaceholder = NSAttributedString(string: "passPlaceholder", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtUsername?.attributedPlaceholder = NSAttributedString(string: "userPlaceholder", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtPassword?.attributedPlaceholder = NSAttributedString(string: "passPlaceholder", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtLastName?.attributedPlaceholder = NSAttributedString(string: "userPlaceholder", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtEmail?.attributedPlaceholder = NSAttributedString(string: "passPlaceholder", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
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
        contentInset.bottom = keyboardFrame.size.height
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
        
        if (driver != nil) {
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
    
    func populateDriver() {
        if let selectedDriver = driver {
            phoneTxt.text = selectedDriver.phone
            txtFirstName.text = selectedDriver.ime
            txtLastName.text = selectedDriver.prezime
            txtEmail.text = selectedDriver.email
        }
    }
    
}

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
    }
}

extension CreateDriverViewController: UITextFieldDelegate, UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let phone = phoneTxt, phone.isEditing {
            phoneBottomView?.backgroundColor = .blue
        }
    }
}
