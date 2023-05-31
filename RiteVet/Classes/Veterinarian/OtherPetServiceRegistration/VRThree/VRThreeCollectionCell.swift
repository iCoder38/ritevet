//
//  VRThreeCollectionCell.swift
//  RiteVet
//
//  Created by Apple on 12/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class VRThreeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var txtLicenceNumber:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtLicenceNumber, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    
    @IBOutlet weak var txtStateName:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtStateName, placeHolder: "", cornerRadius: 20, color: .white)
        }
    }
    
    @IBOutlet weak var btnStateName:UIButton!
    @IBOutlet weak var btnDelete:UIButton!
    
}
