//
//  SubmitPostTableCell.swift
//  RiteVet
//
//  Created by Apple  on 02/12/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class SubmitPostTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtPostTitle:UITextField!
    @IBOutlet weak var txtSelectCategory:UITextField!
    @IBOutlet weak var txtDescription:UITextField!
    @IBOutlet weak var txtUploadImage:UITextField!
    @IBOutlet weak var txtUploadVideo:UITextField!
    @IBOutlet weak var txtUploadVideoLink:UITextField!
    
    @IBOutlet weak var imgOne:UIImageView!
    @IBOutlet weak var imgTwo:UIImageView!
    @IBOutlet weak var imgThree:UIImageView!
    @IBOutlet weak var imgFour:UIImageView!
    @IBOutlet weak var imgFive:UIImageView!
    
    @IBOutlet weak var btnSubmit:UIButton!
    
    @IBOutlet weak var btnUploadNow:UIButton!
    @IBOutlet weak var btnCategory:UIButton!
    
    @IBOutlet weak var btnUploadVideo:UIButton!
    
    @IBOutlet weak var btnVideoPlay:UIButton! {
        didSet {
            btnVideoPlay.isHidden = true
            btnVideoPlay.layer.cornerRadius = 4
            btnVideoPlay.clipsToBounds = true
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
