//
//  CallLogsTableCell.swift
//  RiteVet
//
//  Created by apple on 14/01/22.
//  Copyright © 2022 Apple . All rights reserved.
//

import UIKit

class CallLogsTableCell: UITableViewCell {

    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_title:UIButton!
    @IBOutlet weak var btn_call_back:UIButton! {
        didSet {
            btn_call_back.layer.cornerRadius = 18
            btn_call_back.clipsToBounds = true
            
            btn_call_back.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_call_back.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_call_back.layer.shadowOpacity = 1.0
            btn_call_back.layer.shadowRadius = 15.0
            btn_call_back.layer.masksToBounds = false
            btn_call_back.layer.cornerRadius = 15
            btn_call_back.backgroundColor = .systemMint
            
        }
    }
    
    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    @IBOutlet weak var lbl_sub_title:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
