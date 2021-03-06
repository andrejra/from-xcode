//
//  xibLoginViewController.swift
//  lg1
//
//  Created by Andrej 
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    let fr8hubOrange = UIColor(rgb: 0xBB5615)
    let fr8hubBlue = UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0)

    @IBOutlet weak var txtUser: UITextField?
    @IBOutlet weak var txtPass: UITextField?
    @IBOutlet weak var loginBtnLabel: UIButton!
    @IBOutlet weak var emailBottomView: UIView?
    @IBOutlet weak var passwordBottomView: UIView!
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var emailTopHiddenLbl: UILabel!
    @IBOutlet weak var passTopHiddenLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        txtUser?.delegate = self
        txtPass?.delegate = self
        
        
        //loginBtn Color + Roundness
        loginBtnLabel.backgroundColor = fr8hubBlue
        loginBtnLabel.layer.cornerRadius = 5
        loginBtnLabel.layer.borderWidth = 1
        
        //Text Fields -> Custom Placeholder
        txtUser?.attributedPlaceholder = NSAttributedString(string: "Username or Email", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtPass?.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        
        //Text View Edit -> SEE MARK:
        performLinkMaker()
        
        //MARK: Scroll View enable on Keyboard appear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNetworkListeners()
        
        //NavBar Title as a Custom Image
        let logo = UIImage(named: "fr8hubLogo.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        //NavBar custom Color
        navigationController?.navigationBar.barTintColor = fr8hubOrange
        //NavBar removeShadow
        removeNavBarShadow()
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    //NavBar status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Messages.loginSuccess.cancelSubscription(for: self)
        Messages.logoutFailure.cancelSubscription(for: self)
    }
    
    //MARK: Buttons

    @IBAction func loginBtn() {
        baseLogin()
//        alamoLogin()
    }
    // push next controller
    
    //MARK: Make Text View Atrributed. Hyperlinks, UIFont, UIColor, ...
    func turnTextToLink (inputSring: String) -> NSMutableAttributedString{
        
        let linkString = NSMutableAttributedString(string: inputSring, attributes: [
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.link: URL(string: "http://www.google.com")!, NSAttributedStringKey.foregroundColor: fr8hubBlue, NSAttributedStringKey.font: UIFont(name: "Calibre-Regular", size: 15)!])
        return linkString
    }
    
    func formatTextViewString (inputString: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let formatedString = NSMutableAttributedString(string: inputString, attributes: [
            NSAttributedStringKey.font: UIFont(name: "Calibre-Regular", size: 15)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
            ])
        return formatedString
    }
    
    func performLinkMaker () {
        let attArray = NSMutableAttributedString()
        let textString = self.termsTextView.text
        
        let t1 = textString?.range(of: "Terms")
        let t2 = textString?.range(of: "Use")
        let t3 = textString?.range(of: "Privacy")
        let t4 = textString?.range(of: "Policy")
        
        let termsString = textString![t1!.lowerBound..<t2!.upperBound]
        let privacyString = textString![t3!.lowerBound..<t4!.upperBound]
        
        let termsLink = turnTextToLink(inputSring: String(termsString))
        let privacyLink = turnTextToLink(inputSring: String(privacyString))
        
        let part1 = textString![textString!.startIndex..<t1!.lowerBound] //mora ! donji baca gresku
        
        let attPart1 = formatTextViewString(inputString: String(part1))
        attArray.append(attPart1)
        
        attArray.append(termsLink)
        
        let part2 = textString![t2!.upperBound..<t3!.lowerBound]
        let attPart2 = formatTextViewString(inputString: String(part2))
        attArray.append(attPart2)
        
        attArray.append(privacyLink)
        
        let part3 = textString![t4!.upperBound..<textString!.endIndex]
        let attPart3 = formatTextViewString(inputString: String(part3))
        attArray.append(attPart3)
        
        termsTextView.attributedText = attArray
        
        let linkAttributes: [String : Any] = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor(rgb: 0x072F6C),
            NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue]
        
        termsTextView.linkTextAttributes = linkAttributes
    }
    
    //MARK: UITextFieldDelegate
    // Hide the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // On Email input when Done is pressed - > Go to next txt field -> Login
        if textField == txtUser {
            textField.resignFirstResponder()
            txtPass?.becomeFirstResponder()
        } else if textField == txtPass {
            textField.resignFirstResponder()
            baseLogin()
//            alamoLogin()
        }
        return true
    }
    
    //MARK: Tap gesture
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        
        self.txtPass?.resignFirstResponder()
        self.txtUser?.resignFirstResponder()
    }
    //MARK: Signal
    private func setupSignalSubscription() {
        
    }
    //MARK: TextField Begin/End Editing funcs
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let user = txtUser, user.isEditing {
            emailBottomView?.backgroundColor = .blue
            emailTopHiddenLbl.isHidden = false
            txtUser?.placeholder = ""
        }
        if let pass = txtPass, pass.isEditing{
            passwordBottomView?.backgroundColor = .blue
            passTopHiddenLbl.isHidden = false
            txtPass?.placeholder = ""
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let user = txtUser, !user.isEditing {
            emailBottomView?.backgroundColor = .gray
            emailTopHiddenLbl.isHidden = true
            txtUser?.attributedPlaceholder = NSAttributedString(string: "Username or Email", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
            
        }
        if let pass = txtPass, !pass.isEditing {
            passwordBottomView?.backgroundColor = .gray
            passTopHiddenLbl.isHidden = true
            txtPass?.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        }
    }
    //Mark: TextView properties (for making HyperLink txtview)
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    // Interact w/ URL
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
    
    //Remove Navigation Bar Shadow for Login Scene
    func removeNavBarShadow() {
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 0.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
        
    }
    
    func baseLogin() {
        if let email = txtUser?.text, let pass = txtPass?.text {
            Login(email: email, password: pass).execute()
        }
    }
    
    private func setupNetworkListeners() {
        Messages.loginSuccess.subscribe(with: self) { [unowned self] _ in
            let vc = DriverTableViewController(
                nibName: "DriverTableViewController",
                bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        Messages.loginFailure.subscribe(with: self) { [unowned self] error in
            let alert = UIAlertController(title: "Try Again", message: error, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alamoLogin() {
        
        let url = URL(string: "https://api-fhdev.vibe.rs/login")!
        let parameters:Parameters = ["app":"mobile", "email":readCredentials()["user"]!, "password":readCredentials()["pass"]!]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { [unowned self] response in
            
            switch response.result{
                
            case .success(let value):
                let json = JSON(value)
                if let token = json["token"].string {
                    print("AR: token - \(token)")
                    SettingsManager.authToken = token
                    
                    let vc = DriverTableViewController(
                        nibName: "DriverTableViewController",
                        bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        let alert = UIAlertController(title: "Try Again", message: "Please enter login credentials", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    case 401:
                        let alert = UIAlertController(title: "Try Again", message: "Username or password is invalid", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    // read user input for login
    func readCredentials () -> [String: Any] {
        
        var credentials = [String: Any]()
        
        if let userTxtField = txtUser {
            credentials["user"] = userTxtField.text ?? ""
        } else {
            let alert = UIAlertController(title: "Try Again", message: "Please enter a valid username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if let passTextField = txtPass {
            
            credentials["pass"] = passTextField.text ?? ""
            
        } else {
            let alert = UIAlertController(title: "Try Again", message: "Please enter a valid password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return credentials
    }
    
    //---------------------------------
    // MARK: - Notification Center
    //---------------------------------
    
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
}

