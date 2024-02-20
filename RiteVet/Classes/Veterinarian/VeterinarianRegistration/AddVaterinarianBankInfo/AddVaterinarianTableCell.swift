//
//  AddVaterinarianTableCell.swift
//  RiteVet
//
//  Created by Apple  on 28/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class AddVaterinarianTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    
    @IBOutlet weak var txtYourName:UITextField!
    @IBOutlet weak var txtSelectBank:UITextField!
    @IBOutlet weak var txtBankAccountNumber:UITextField!
    @IBOutlet weak var txtSwitchNumberForAccounts:UITextField!
    @IBOutlet weak var txtRoutingCode:UITextField!
    @IBOutlet weak var txtAccountType:UITextField!
    @IBOutlet weak var txtEmailAddress:UITextField!
    @IBOutlet weak var txtAccountNumber:UITextField!
    @IBOutlet weak var btnCheckUncheckCode:UIButton! {
        didSet {
            btnCheckUncheckCode.setImage(UIImage(named: "regUncheck"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnFinish:UIButton!
    @IBOutlet weak var btnSkip:UIButton! {
        didSet {
            Utils.buttonDR(button: btnSkip, text: "SKIP", backgroundColor: .systemGray, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
             btnSkip.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var btnCheckUncheck:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
