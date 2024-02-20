//
//  CheckAvailibilityTableCell.swift
//  RiteVet
//
//  Created by Apple  on 28/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class CheckAvailibilityTableCell: UITableViewCell {

    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var btnCheck:UIButton!
    @IBOutlet weak var btnDone:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
