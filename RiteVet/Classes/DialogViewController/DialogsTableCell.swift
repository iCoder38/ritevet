//
//  DialogsTableCell.swift
//  RiteVet
//
//  Created by apple on 11/08/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class DialogsTableCell: UITableViewCell {

    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.layer.masksToBounds = false
            viewBG.layer.cornerRadius = 8
            viewBG.layer.backgroundColor = UIColor.white.cgColor
            viewBG.layer.borderColor = UIColor.clear.cgColor
            viewBG.layer.shadowColor = UIColor.systemTeal.cgColor
            viewBG.layer.shadowOffset = CGSize(width: 0, height: 0)
            viewBG.layer.shadowOpacity = 0.4
            viewBG.layer.shadowRadius = 4
            // viewBG.backgroundColor = NAVIGATION_BACKGROUND_COLOR_CHAT_CAP
        }
    }
    
    @IBOutlet weak var lblGroupName:UILabel!
    @IBOutlet weak var lblLastText:UILabel! {
        didSet {
            lblLastText.textColor = .black
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 25
            imgProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgLastMessage:UIImageView!
    
    @IBOutlet weak var lblNotificationCounter:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
