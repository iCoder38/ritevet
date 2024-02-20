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
            imgProfile.layer.cornerRadius = 40
            imgProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgStarOne:UIImageView! {
        didSet {
            imgStarOne.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var imgStarTwo:UIImageView! {
        didSet {
            imgStarTwo.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var imgStarThree:UIImageView! {
        didSet {
            imgStarThree.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var imgStarFour:UIImageView! {
        didSet {
            imgStarFour.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var imgStarFive:UIImageView! {
        didSet {
            imgStarFive.tintColor = .systemOrange
        }
    }
    
    @IBOutlet weak var lbl_rating_count:UILabel!
    
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
