//
//  AddVeterinarianBankInfoTwoTableCell.swift
//  RiteVet
//
//  Created by Apple on 13/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class AddVeterinarianBankInfoTwoTableCell: UITableViewCell {

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
