//
//  OtherPetServiceBankInfoTableCell.swift
//  RiteVet
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class OtherPetServiceBankInfoTableCell: UITableViewCell {

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
    
    @IBOutlet weak var btnFinish:UIButton!
    @IBOutlet weak var btnSkip:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
