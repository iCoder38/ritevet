//
//  BrowsePetStoreTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class BrowsePetStoreTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCount:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
