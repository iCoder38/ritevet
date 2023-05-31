//
//  MyPostDetailsTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 1/9/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class MyPostDetailsTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 4
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderColor = BUTTON_BACKGROUND_COLOR_BLUE.cgColor
            imgProfile.layer.borderWidth = 5.0
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
