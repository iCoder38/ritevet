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
    @IBOutlet weak var txtLastUsername:UITextField!
    @IBOutlet weak var txtEmail:UITextField!  {
        didSet {
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtPhone:UITextField! {
        didSet {
            txtPhone.keyboardType = .numberPad
        }
    }
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
    
    @IBOutlet weak var btn_id_proof:UIButton! {
        didSet {
            btn_id_proof.setTitle("Update ID Proof", for: .normal)
            btn_id_proof.setTitleColor(.white, for: .normal)
            btn_id_proof.layer.cornerRadius = 4
            btn_id_proof.clipsToBounds = true
            btn_id_proof.backgroundColor = NAVIGATION_BACKGROUND_COLOR
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
    
    @IBOutlet weak var btn_vet_profile:UIButton! {
        didSet {
            btn_vet_profile.setTitle("Update veterinarian profile", for: .normal)
            btn_vet_profile.setTitleColor(.white, for: .normal)
            btn_vet_profile.layer.cornerRadius = 4
            btn_vet_profile.clipsToBounds = true
            btn_vet_profile.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btn_other_pet_Service_provider:UIButton! {
        didSet {
            btn_other_pet_Service_provider.setTitle("Update other pet service providers", for: .normal)
            btn_other_pet_Service_provider.setTitleColor(.white, for: .normal)
            btn_other_pet_Service_provider.layer.cornerRadius = 4
            btn_other_pet_Service_provider.clipsToBounds = true
            btn_other_pet_Service_provider.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btn_update_pet_parent:UIButton! {
        didSet {
            btn_update_pet_parent.setTitle("Update pet parent", for: .normal)
            btn_update_pet_parent.setTitleColor(.white, for: .normal)
            btn_update_pet_parent.layer.cornerRadius = 4
            btn_update_pet_parent.clipsToBounds = true
            btn_update_pet_parent.backgroundColor = NAVIGATION_BACKGROUND_COLOR
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
