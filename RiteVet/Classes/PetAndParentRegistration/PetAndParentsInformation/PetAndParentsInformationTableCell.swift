//
//  PetAndParentsInformationTableCell.swift
//  RiteVet
//
//  Created by Apple on 04/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class PetAndParentsInformationTableCell: UITableViewCell {

    @IBOutlet weak var clView:UICollectionView! {
        didSet {
            clView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtExplainAboutTheOtherAnimal:UITextField!
    
    @IBOutlet weak var btnNext:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
