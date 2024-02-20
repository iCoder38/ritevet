//
//  LogCell.swift
//  OpenVoiceCall
//
//  Created by GongYuhua on 16/9/7.
//  Copyright © 2016年 Agora. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.clipsToBounds = true
            viewBG.backgroundColor = .white
            viewBG.layer.shadowColor = UIColor.black.cgColor
            viewBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewBG.layer.shadowOpacity = 1.0
            viewBG.layer.shadowRadius = 2.0
            viewBG.layer.masksToBounds = false
            viewBG.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var logLabel: UILabel!
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 15
            imgProfile.clipsToBounds = true
        }
    }
    
    /*func set(log: String) {
        logLabel.text = log
    }*/
    
}
