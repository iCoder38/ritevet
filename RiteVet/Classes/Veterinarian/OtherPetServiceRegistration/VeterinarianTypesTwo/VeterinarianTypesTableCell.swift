//
//  VeterinarianTypesTableCell.swift
//  RiteVet
//
//  Created by Apple on 13/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class VeterinarianTypesTableCell: UITableViewCell {

    @IBOutlet weak var lblTypeOfPets:UILabel!
    @IBOutlet weak var lblTypeOfServices:UILabel!
    
    // first cell
    @IBOutlet weak var lblTypeOfSpecialization:UILabel!
    @IBOutlet weak var btnDog:UIButton!
    @IBOutlet weak var btnCat:UIButton!
    @IBOutlet weak var btnPoultry:UIButton!
    @IBOutlet weak var btnReptiles:UIButton!
    @IBOutlet weak var btnExcoticBirds:UIButton!
    @IBOutlet weak var btnFoodAnimalAndDiary:UIButton!
    @IBOutlet weak var btnEquine:UIButton!
    @IBOutlet weak var btnLabAnimals:UIButton!
    @IBOutlet weak var btnExcoticAnimals:UIButton!
    @IBOutlet weak var btnOther:UIButton!
    
    
    // second cell
    @IBOutlet weak var btnGrooming:UIButton!
    @IBOutlet weak var btnOtherServices:UIButton!
    @IBOutlet weak var btnPetHotel:UIButton!
    @IBOutlet weak var btnPetSettingAnd:UIButton!
    @IBOutlet weak var btnPetTraining:UIButton!
    @IBOutlet weak var btnPetWalking:UIButton!
    @IBOutlet weak var txtOther:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtOther, placeHolder: "Explain About Other Service", cornerRadius: 20, color: .white)
        }
    }
    
    @IBOutlet weak var btnNext:UIButton! {
        didSet {
            Utils.buttonDR(button: btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
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
