//
//  VROneTableCell.swift
//  RiteVet
//
//  Created by Apple on 09/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class VROneTableCell: UITableViewCell {

    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.layer.cornerRadius = 6
            viewBG.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnPlus:UIButton!
    @IBOutlet weak var btnMinus:UIButton!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtTitle:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtTitle, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    
    @IBOutlet weak var lblTitle2:UILabel!
    @IBOutlet weak var txtTitle2:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtTitle2, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    
    /*@IBOutlet weak var txtMiddleName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtVeterinaryLicenceNumber:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtBusinessName:UITextField!
    @IBOutlet weak var txtBusinessLicenceNumber:UITextField!
    @IBOutlet weak var txtIENTAXidNumber:UITextField!*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
