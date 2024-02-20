//
//  MyOrdersTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class MyOrdersTableCell: UITableViewCell {

    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 4
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderColor = NAVIGATION_BACKGROUND_COLOR.cgColor
            imgProfile.layer.borderWidth = 3.0
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblQuantity:UILabel!
    @IBOutlet weak var lblPrice:UILabel! {
        didSet {
            lblPrice.textColor = .blue
        }
    }
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.isHidden = true
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
