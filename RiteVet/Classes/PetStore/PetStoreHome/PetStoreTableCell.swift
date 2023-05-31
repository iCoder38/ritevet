//
//  PetStoreTableCell.swift
//  RiteVet
//
//  Created by Apple on 06/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class PetStoreTableCell: UITableViewCell {

    @IBOutlet weak var btnRequestService:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
