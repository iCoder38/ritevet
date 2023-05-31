//
//  RequestServiceHomeTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 1/6/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class RequestServiceHomeTableCell: UITableViewCell {

    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 50
            imgProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgStarOne:UIImageView!
    @IBOutlet weak var imgStarTwo:UIImageView!
    @IBOutlet weak var imgStarThree:UIImageView!
    @IBOutlet weak var imgStarFour:UIImageView!
    @IBOutlet weak var imgStarFive:UIImageView!
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    @IBOutlet weak var lblDoctorType:UILabel! {
        didSet {
            lblDoctorType.text = "Behavior"
            lblDoctorType.textColor = .blue
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
