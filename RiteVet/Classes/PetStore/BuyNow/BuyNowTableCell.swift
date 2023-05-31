//
//  BuyNowTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 2/27/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class BuyNowTableCell: UITableViewCell {

    @IBOutlet weak var imgDogProduct:UIImageView!
    @IBOutlet weak var lblDetails:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    
    
    @IBOutlet weak var stepper:UIStepper!
    @IBOutlet weak var lblStepperText:UILabel!{
        didSet {
            lblStepperText.textColor = .white
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
