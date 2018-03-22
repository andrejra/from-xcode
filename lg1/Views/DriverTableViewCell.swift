//
//  DriverTableViewCell.swift
//  lg1
//
//  Created by Andrej on 2/23/18.
//  Copyright © 2018 Andrej. All rights reserved.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    @IBOutlet weak var labelIme: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var nameLetterLbl: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        arrowImg.tintColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDriverCell (driver: Vozac) {
        var ime = ""
        var prezime = ""
        
        if let firstName = driver.ime{
            
            if let lastName = driver.prezime {
                nameLetterLbl.text = String(firstName.prefix(1)) + String(lastName.prefix(1))
                prezime = lastName
                ime = firstName
            }
        }
        
        if let role = driver.roles {
            var roles = ""
            
            for r in role {
                roles = roles + r + ", "
                roles = roles.capitalized
                //let index = roles.index(roles.endIndex, offsetBy: -2)
                roleLbl.text = String(roles[..<roles.index(roles.endIndex, offsetBy: -2)])
            }
        }
        labelIme.text = ime + " " + prezime
    }

}
