//
//  EditProfileTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 1/8/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class EditProfileTableCell: UITableViewCell {

    @IBOutlet weak var imgUploadPhoto:UIImageView!
    
    @IBOutlet weak var txtUsername:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPhone:UITextField!
    @IBOutlet weak var txtAddress:UITextField!
    @IBOutlet weak var txtCountry:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var txtZipcode:UITextField!
    
    @IBOutlet weak var btnCountry:UIButton!
    @IBOutlet weak var btnState:UIButton!
    
    @IBOutlet weak var btnChangePassword:UIButton! {
        didSet {
            btnChangePassword.setTitle("Change Password", for: .normal)
            btnChangePassword.setTitleColor(.white, for: .normal)
            btnChangePassword.layer.cornerRadius = 4
            btnChangePassword.clipsToBounds = true
            btnChangePassword.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            btnSubmit.setTitle("Update Profile", for: .normal)
            btnSubmit.setTitleColor(.white, for: .normal)
            btnSubmit.layer.cornerRadius = 4
            btnSubmit.clipsToBounds = true
            btnSubmit.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
