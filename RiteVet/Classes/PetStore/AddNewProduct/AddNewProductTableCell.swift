//
//  AddNewProductTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 12/26/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class AddNewProductTableCell: UITableViewCell {

    @IBOutlet weak var txtSelectCategory:UITextField!
    
    @IBOutlet weak var txt_seller_name:UITextField!
    @IBOutlet weak var txt_seller_last_name:UITextField!
    @IBOutlet weak var txt_Seller_phone:UITextField!
    @IBOutlet weak var txt_Seller_email:UITextField!
    @IBOutlet weak var txt_seller_company_name:UITextField!
    
    @IBOutlet weak var txtSelectSubCategory:UITextField!
    @IBOutlet weak var txtProductName:UITextField!
    @IBOutlet weak var txtSKU:UITextField!
    @IBOutlet weak var txtShippingFee:UITextField!
    @IBOutlet weak var txtProductDescription:UITextField!
    @IBOutlet weak var txtPrice:UITextField! {
        didSet {
            txtPrice.keyboardType = .decimalPad
        }
    }
    @IBOutlet weak var txtSpecialPrice:UITextField! {
        didSet {
            txtPrice.keyboardType = .decimalPad
        }
    }
    @IBOutlet weak var txtQuantity:UITextField!
    @IBOutlet weak var txtUploadImage:UITextField!
    
    @IBOutlet weak var btnUploadImageHiddenButton:UIButton!
    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            btnSubmit.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var btnCategory:UIButton!
    @IBOutlet weak var btnSubCategory:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
