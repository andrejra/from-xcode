//
//  xibDriverTableViewController.swift
//  lg1
//
//  Created by Andrej on 3/13/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverTableViewController: UITableViewController {
    
    var token = ""
    var drivers = [Vozac]()
    let fr8hubBlue = UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib.init(nibName: "DrTableViewCell", bundle: nil), forCellReuseIdentifier: "DrTableViewCell")
        
        self.title = "Users"
        setBarButtons()
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: fr8hubBlue, NSAttributedStringKey.font: UIFont(name:"Calibre-Bold", size: 20)!]
        navigationController?.navigationBar.tintColor = fr8hubBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDrivers()
        setNavBarShadow()
    }
    
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            drivers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let selectedDriver = drivers[row]
        
    }
    
    @IBAction func btnLogOut(_ sender: UIBarButtonItem) {
        
        let url = URL(string: "https://api-fhdev.vibe.rs/logout")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        Alamofire.request(url, method: .post, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("AR: Log Out ok")
                self.popVC()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        setEditing(!isEditing, animated: true)
    }
    
    func popVC(){
            self.navigationController?.popViewController(animated: true)
    }
    
    func getDrivers(){
        let url = URL(string: "https://api-fhdev.vibe.rs/drivers?page_size=100")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
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
        btn2.setImage(UIImage(named: "remove"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(self.editBtn(_:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "add-driver"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn3.addTarget(self, action: #selector(self.addDriverSegue(_:)), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btn3)
        
        
        self.navigationItem.setRightBarButton(item3, animated: true)
        
        self.navigationItem.setLeftBarButtonItems([item1,item2], animated: true)
        
    }
    @objc func addDriverSegue(_ sender: Any) {
        
    }
}
