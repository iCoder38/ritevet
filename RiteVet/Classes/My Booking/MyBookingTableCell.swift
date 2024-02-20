//
//  MyBookingTableCell.swift
//  RiteVet
//
//  Created by Apple on 12/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class MyBookingTableCell: UITableViewCell {

    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 4
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderColor = NAVIGATION_BACKGROUND_COLOR.cgColor
            imgProfile.layer.borderWidth = 3.0
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDateAndTime:UILabel!
    @IBOutlet weak var lblPhoneNumber:UILabel!
    
    @IBOutlet weak var lblFunction:UILabel! {
        didSet {
            lblFunction.textColor = .black
        }
    }
    
    @IBOutlet weak var btnVideo:UIButton! {
        didSet {
            btnVideo.isUserInteractionEnabled = false
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
