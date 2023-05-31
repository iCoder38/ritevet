//
//  VRTwoTableCell.swift
//  RiteVet
//
//  Created by Apple on 10/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class VRTwoTableCell: UITableViewCell {

    @IBOutlet weak var btnNext:UIButton! {
        didSet {
            Utils.buttonDR(button: btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        }
    }
    
    @IBOutlet weak var txtFirstName:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtFirstName, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    @IBOutlet weak var txtMiddleName:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtMiddleName, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    @IBOutlet weak var txtLastName:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtLastName, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    @IBOutlet weak var txtVeterinaryLicenceNumber:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtVeterinaryLicenceNumber, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    @IBOutlet weak var txtState:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtState, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    @IBOutlet weak var txtBusinessName:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtBusinessName, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    @IBOutlet weak var txtBusinessLicenceNumber:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtBusinessLicenceNumber, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    @IBOutlet weak var txtIENTAXidNumber:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtIENTAXidNumber, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    
    @IBOutlet weak var lblIndexCount:UILabel! {
        didSet {
            lblIndexCount.text = "1/1"
        }
    }
    
    @IBOutlet weak var clView:UICollectionView! {
        didSet {
            clView.layer.cornerRadius = 20
            clView.clipsToBounds = true
            clView.backgroundColor = .clear
            clView.isPagingEnabled = true
        }
    }
    
    
    @IBOutlet weak var btn_do_you_have_specialization:UIButton!
    @IBOutlet weak var btn_do_you_have_specialization_options:UIButton!
    
    
    @IBOutlet weak var txt_do_you_have:UITextField! {
        didSet {
            Utils.textFieldDR(text: txt_do_you_have, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    
    
    
    @IBOutlet weak var txt_specialization_options:UITextField! {
        didSet {
            Utils.textFieldDR(text: txt_specialization_options, placeHolder: "", cornerRadius: 20, color: .white)
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
