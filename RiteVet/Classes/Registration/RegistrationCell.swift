//
//  RegistrationCell.swift
//  RiteVet
//
//  Created by evs_SSD on 3/3/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class RegistrationCell: UITableViewCell {

    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtPhone:UITextField!   {
        didSet {
            txtPhone.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtCountry:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var txtAddress:UITextField!
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            txtPassword.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var txtConfirmPassword:UITextField! {
        didSet {
            txtConfirmPassword.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var txtZipcode:UITextField!  {
        didSet {
            txtZipcode.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var btnSignUp:UIButton!
    @IBOutlet weak var btnFB:UIButton!
    @IBOutlet weak var btnGooglePlus:UIButton!
    
    @IBOutlet weak var btnCheckUncheck:UIButton!
    
    @IBOutlet weak var btnSignIn:UIButton!
    
    @IBOutlet weak var btnCountry:UIButton!
    @IBOutlet weak var btnState:UIButton!
    
    @IBOutlet weak var btnIagree:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
