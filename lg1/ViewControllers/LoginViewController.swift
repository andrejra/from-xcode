//
//  ViewController.swift
//  lg1
//
//  Created by Andrej on 2/19/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var token = ""
    var logged = false
    let userPlaceholder = "Username or Email"
    let passPlaceholder = "Password"
    let fr8hubBlue = UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    let fr8hubOrange = UIColor(red: 188.0/255.0, green: 111.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    @IBOutlet weak var txtUser: UITextField?
    @IBOutlet weak var txtPass: UITextField?
    @IBOutlet weak var extLabel: CustomView!
    @IBOutlet weak var loginBtnLabel: UIButton!
    @IBOutlet weak var emailBottomView: UIView?
    @IBOutlet weak var passwordBottomView: UIView!
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var emailTopHiddenLbl: UILabel!
    @IBOutlet weak var passTopHiddenLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var urlSessionTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Handle the text field’s user input through delegate callbacks.
        txtUser?.delegate = self
        txtPass?.delegate = self
        

        
        loginBtnLabel.backgroundColor = fr8hubBlue
        loginBtnLabel.layer.cornerRadius = 5
        loginBtnLabel.layer.borderWidth = 1

        txtUser?.attributedPlaceholder = NSAttributedString(string: userPlaceholder, attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        txtPass?.attributedPlaceholder = NSAttributedString(string: passPlaceholder, attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        
        performLinkMaker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+200)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSignalSubscription()
        
        let logo = UIImage(named: "fr8hubLogo.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        navigationController?.navigationBar.barTintColor = fr8hubOrange
        removeNavBarShadow()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Messages.postRequestFailed.cancelSubscription(for: self)
    }
    
    @IBAction func forgotPassBtn() {
        
        deprecatedLogin()
        
    }
    @IBAction func loginBtn() {
        alamoLogin()
    }
    
    func openNextController(){
        DispatchQueue.main.async {
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "DriverTableViewController") as! DriverTableViewController
            myVC.token = self.token
            self.navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        loginBtn()
        return true
    }

    //MARK: Tap gesture
    @IBAction func tap(_ sender: UITapGestureRecognizer) {

        self.txtPass?.resignFirstResponder()
        self.txtUser?.resignFirstResponder()
    }
    
    private func setupSignalSubscription() {
        Messages.postRequestFailed.subscribe(with: self) { [weak self] statusCode in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Try Again", message: "Username or password is invalid", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
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
            txtUser?.attributedPlaceholder = NSAttributedString(string: userPlaceholder, attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
            
        }
        if let pass = txtPass, !pass.isEditing {
            passwordBottomView?.backgroundColor = .gray
            passTopHiddenLbl.isHidden = true
            txtPass?.attributedPlaceholder = NSAttributedString(string: passPlaceholder, attributes: [NSAttributedStringKey.font:UIFont(name: "Calibre", size: 20.0)!])
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
    
    func removeNavBarShadow() {
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 0.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
        
    }
    
    func alamoLogin() {
        
        let url = URL(string: "https://api-fhdev.vibe.rs/login")!
        let parameters = ["app":"mobile", "email":readCredentials()["user"], "password":readCredentials()["pass"]]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { [unowned self] response in
            
            switch response.result{
                
            case .success(let value):
                let json = JSON(value)
                if let token = json["token"].string {
                    print("AR: token - \(token)")
                    self.token = token
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "DriverTableViewController") as! DriverTableViewController
                    myVC.token = self.token
                    self.navigationController?.pushViewController(myVC, animated: true)
                }
//                self.openNextController()
                

                
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
    
    func deprecatedLogin() {
        
        var user = ""
        var pass = ""
        
        if let userTxtField = txtUser {
            user = userTxtField.text ?? ""
            
        } else {
            let alert = UIAlertController(title: "Try Again", message: "Please enter a valid username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if let passTextField = txtPass {
            pass = passTextField.text ?? ""
            
        } else {
            let alert = UIAlertController(title: "Try Again", message: "Please enter a valid password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        let url = URL(string: "https://api-fhdev.vibe.rs/login")!
        let parameters = ["app":"mobile", "email":user, "password":pass]
        
        
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {
                Messages.postRequestFailed.fire(httpStatus.statusCode)
            }
            
            if let httpStatus = response as? HTTPURLResponse, 201 ... 299 ~= httpStatus.statusCode  {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                return
            }
            
            do {
                //create json object from data
                if let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    //                    print(dict)
                    if let token = dict["token"] as? String {
                        print("AR: token - \(token)")
                        self.token = token
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                self.openNextController()
            }
        }
        task.resume()
        
    }
    
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
