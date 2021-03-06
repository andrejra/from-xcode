//
//  xibDriverTableViewController.swift
//  lg1
//
//  Created by Andrej
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift

class DriverTableViewController: UITableViewController {
    
    var drivers = [Vozac]()
    let fr8hubBlue = UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registering XIB CELL
        tableView.register(UINib.init(nibName: "DrTableViewCell", bundle: nil), forCellReuseIdentifier: "DrTableViewCell")
        
        //Setting up Nav Bar & Bar Items
        self.title = "Users"
        setBarButtons()
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: fr8hubBlue, NSAttributedStringKey.font: UIFont(name:"Calibre-Bold", size: 19)!]
        navigationController?.navigationBar.tintColor = fr8hubBlue
        setNavBarShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setupNetworkListeners()
        //Load drivers to the table every time view is presented
//        getDrivers()
        GetDrivers().execute()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Messages.getDriversSuccess.cancelSubscription(for: self)
        Messages.getDriversFailure.cancelSubscription(for: self)
        Messages.logoutSuccess.cancelSubscription(for: self)
        Messages.loginFailure.cancelSubscription(for: self)
        Messages.deleteDriverSuccess.cancelSubscription(for: self)
        Messages.deleteDriverFailure.cancelSubscription(for: self)
    }
        //Set status bar back to dark
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrTableViewCell", for: indexPath) as? DriverTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of DriverTableViewCell")
        }
        let driver = drivers[indexPath.row]
        cell.setDriverCell(driver: driver)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    //Allow editing - remove cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let driverID = drivers[indexPath.row].driverID, let driverStatus = drivers[indexPath.row].driverStatus, let firstName = drivers[indexPath.row].ime, let lastName = drivers[indexPath.row].prezime {
                
                if driverStatus.rawValue == "on_shipment" {
                    
                    let message = "Driver \(firstName) \(lastName) is currently on shipment!"
                    let banner = NotificationBanner(title: "Couldn't delete driver", subtitle: message, style: .danger)
                    banner.show()
                    return
                }
                
                DeleteDriver(driverID: driverID).execute()
                //TODO
                drivers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    //Allow Editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    //Selected cell - > Next VC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let selectedDriver = drivers[row]
        pushEditDriveVC(driver: selectedDriver)
    }
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        setEditing(!isEditing, animated: true)
    }
    
    private func setupNetworkListeners() {
        Messages.getDriversSuccess.subscribe(with: self) { [unowned self] drivers in
            self.drivers = drivers
            self.tableView.reloadData()
            
        }
        
        Messages.getDriversFailure.subscribe(with: self) { [unowned self] error in
            let alert = UIAlertController(title: "Failed to Load Drivers", message: error, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        Messages.logoutSuccess.subscribe(with: self) { [unowned self] in
            self.popVC()
        }
        Messages.logoutFailure.subscribe(with: self) { [unowned self] error in
            let alert = UIAlertController(title: "Failed to Logout", message: error, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        Messages.deleteDriverSuccess.subscribe(with: self) { _ in
            print("AR - Driver Deleted")
            
            let banner = NotificationBanner(title: "Success", subtitle: "Driver successfully deleted", style: .success)
            banner.show()
        }
        
        Messages.deleteDriverFailure.subscribe(with: self) { error in
            let banner = NotificationBanner(title: "Driver was not deleted", subtitle: error, style: .danger)
            banner.show()
        }
    }
    
    @IBAction func btnLogOut(_ sender: UIBarButtonItem) {
        
        Logout().execute()
//        let url = URL(string: "https://api-fhdev.vibe.rs/logout")!
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(SettingsManager.authToken)",
//            "Content-Type": "application/json"
//        ]
//        Alamofire.request(url, method: .post, headers: headers).validate().responseJSON { response in
//            switch response.result {
//            case .success:
//                print("AR: Log Out ok")
//                self.popVC()
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    func getDrivers(){
        let url = URL(string: "https://api-fhdev.vibe.rs/drivers?page_size=100")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(SettingsManager.authToken)",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .get, headers: headers).validate().responseJSON { response in
            
            switch response.result{
                
            case .success(let value):
                let json = JSON(value)
                self.drivers = [Vozac]()
                if let jsonDrivers = json["entries"].array {
                    for jsonDriver in jsonDrivers{
                        let newDriver = Vozac(json: jsonDriver)
                        self.drivers.append(newDriver)
                        self.tableView.reloadData()
                    }
                }
                
                
            case .failure(let error):
             print(error.localizedDescription)
            }
        }
    }
    
    func setNavBarShadow() {
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 3.0
        navigationController?.navigationBar.layer.shadowOpacity = 1.0
        navigationController?.navigationBar.layer.masksToBounds = false
        
    }
    func setBarButtons() {
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.btnLogOut(_:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "remove-driver"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(self.editBtn(_:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "add-driver"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn3.addTarget(self, action: #selector(pushCreateDriverVC), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btn3)
        
        
        self.navigationItem.setRightBarButton(item3, animated: true)
        
        self.navigationItem.setLeftBarButtonItems([item1,item2], animated: true)
        
    }

    @objc
    func pushCreateDriverVC(){
        let vc = CreateDriverViewController(
            nibName: "CreateDriverViewController",
            bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushEditDriveVC(driver: Vozac) {
        let vc = CreateDriverViewController(
            nibName: "CreateDriverViewController",
            bundle: nil)
        vc.driver = driver
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
}
