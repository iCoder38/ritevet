//
//  AddToCartTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class AddToCartTableCell: UITableViewCell {

    @IBOutlet weak var imgDogProduct:UIImageView!
    @IBOutlet weak var lblDetails:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    
    
    @IBOutlet weak var stepper:UIStepper!
    @IBOutlet weak var lblStepperText:UILabel!{
        didSet {
            lblStepperText.textColor = .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
