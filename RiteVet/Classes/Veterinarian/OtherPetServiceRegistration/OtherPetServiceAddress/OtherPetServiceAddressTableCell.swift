//
//  OtherPetServiceAddressTableCell.swift
//  RiteVet
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class OtherPetServiceAddressTableCell: UITableViewCell {
    
    @IBOutlet weak var lblOtherPets:UILabel!
    @IBOutlet weak var lblContact:UILabel!
    
    @IBOutlet weak var txtStreetAddress:UITextField!
    @IBOutlet weak var txtSuit:UITextField!
    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtZipcode:UITextField!
    @IBOutlet weak var txtPhone:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtTypeOfYourBusiness:UITextField!
    @IBOutlet weak var txtYearsInBusiness:UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
