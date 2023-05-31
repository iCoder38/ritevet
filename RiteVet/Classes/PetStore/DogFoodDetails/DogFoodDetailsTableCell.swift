//
//  DogFoodDetailsTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class DogFoodDetailsTableCell: UITableViewCell {

    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor.gray.cgColor
            view_bg.layer.shadowOpacity = 1
            view_bg.layer.shadowOffset = .zero
            view_bg.layer.shadowRadius = 4
            view_bg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_seller_name:UILabel!
    @IBOutlet weak var lbl_seller_phone:UILabel!
    @IBOutlet weak var lbl_seller_email:UILabel!
    @IBOutlet weak var lbl_seller_company_name:UILabel!
    
    @IBOutlet weak var imgDogProduct:UIImageView! {
        didSet {
            imgDogProduct.layer.cornerRadius = 110
            imgDogProduct.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblDetails:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblOldPrice:UILabel!
    
    @IBOutlet weak var stepper:UIStepper!
    @IBOutlet weak var lblStepperText:UILabel!{
        didSet {
            lblStepperText.textColor = .white
        }
    }
    
    @IBOutlet weak var btnStepperBG:UIButton! {
        didSet {
            btnStepperBG.layer.cornerRadius = 4
            btnStepperBG.clipsToBounds = true
            btnStepperBG.setTitleColor(.white, for: .normal)
            btnStepperBG.backgroundColor = UIColor.init(red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnBuyNow:UIButton! {
        didSet {
            btnBuyNow.layer.cornerRadius = 4
            btnBuyNow.clipsToBounds = true
            btnBuyNow.setTitleColor(.white, for: .normal)
            btnBuyNow.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
    }
    @IBOutlet weak var btnAddToCart:UIButton! {
        didSet {
            btnAddToCart.layer.cornerRadius = 4
            btnAddToCart.clipsToBounds = true
            btnAddToCart.setTitleColor(.white, for: .normal)
            btnAddToCart.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
    }
    
    @IBOutlet weak var lblSKU:UILabel! {
        didSet {
            lblSKU.textColor = BUTTON_BACKGROUND_COLOR_BLUE
        }
    }
    
    @IBOutlet weak var lblShipping:UILabel!
    @IBOutlet weak var lblCategory:UILabel!
    
    @IBOutlet weak var txtViewMessage:UITextView! {
        didSet {
            txtViewMessage.layer.cornerRadius = 4
            txtViewMessage.clipsToBounds = true
            txtViewMessage.layer.borderColor = UIColor.lightGray.cgColor
            txtViewMessage.layer.borderWidth = 0.8
            txtViewMessage.isEditable = true
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
