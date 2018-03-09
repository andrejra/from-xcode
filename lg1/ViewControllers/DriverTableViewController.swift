//
//  DriverTableViewController.swift
//  lg1
//
//  Created by Andrej on 2/21/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit
import os.log
import Alamofire
import SwiftyJSON

class DriverTableViewController: UITableViewController {

    var token = ""
    var drivers = [Vozac]()
    let fr8hubBlue = UIColor(red: 15.0/255.0, green: 33.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DriverTableViewCell", for: indexPath) as? DriverTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of DriverTableViewCell")
        }
        let driver = drivers[indexPath.row]
        cell.setDriverCell(driver: driver)
        return cell
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
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedDriverViewController") as? SelectedDriverViewController {
            vc.driver = selectedDriver
            navigationController?.pushViewController(vc, animated: true)
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.destination is AddDriverViewController {
            return
        }
        
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
        //STARI NACIN PREKO URLREQ
//        var request = URLRequest(url: url)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "POST"
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                print("error=\(error!.localizedDescription)")
//                return
//            }
//
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 204 {
//                print("AR: Log Out ok")
//                self.popVC()
//            }
//        }
//        task.resume()
    }

    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        setEditing(!isEditing, animated: true)
        
        
//        if(isEditing == false){
//            setEditing(true, animated: true)
//        }
//        else {
//            setEditing(false, animated: true)
//        }
        
    }
    
    func popVC(){
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
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
                
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        let alert = UIAlertController(title: "Try Again", message: "Username or password is invalid", preferredStyle: UIAlertControllerStyle.alert)
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
//      STARI NAcin PREKO URLREQ
//        var request = URLRequest(url: url)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: request) { [unowned self] data, response, error in
//            guard let data = data, error == nil else {
//                // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//
//            if let httpStatus = response as? HTTPURLResponse, 201 ... 299 ~= httpStatus.statusCode  {
//                // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//                return
//            }
//
//            do {
//                //create json object from data
//                if let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                    self.drivers = [Vozac]()
//
//                    if let jsonDrivers = dict["entries"] as? [[String: Any]]{
//                        for jsonDriver in jsonDrivers{
//                            let newDriver = Vozac(jsonDriver: jsonDriver)
//                            self.drivers.append(newDriver)
//                        }
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//
//        }
//        task.resume()
    }
    
    func setNavBarShadow() {
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 3.0
        navigationController?.navigationBar.layer.shadowOpacity = 1.0
        navigationController?.navigationBar.layer.masksToBounds = false
        
    }
}
