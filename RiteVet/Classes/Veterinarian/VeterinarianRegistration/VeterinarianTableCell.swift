
//
//  VeterinarianTableCell.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class VeterinarianTableCell: UITableViewCell {

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
    @IBOutlet weak var txtOther:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtOther, placeHolder: "Explain about the other Animal", cornerRadius: 20, color: .white)
        }
    }
    
    // second cell
    @IBOutlet weak var btnGeneral:UIButton!
    @IBOutlet weak var btnWellness:UIButton!
    @IBOutlet weak var btnImaging:UIButton!
    @IBOutlet weak var btnDiagonsticLab:UIButton!
    @IBOutlet weak var btnDental:UIButton!
    @IBOutlet weak var btnBording:UIButton!
    @IBOutlet weak var btnOther2:UIButton!
    @IBOutlet weak var txtOther2:UITextField! {
        didSet {
            Utils.textFieldDR(text: txtOther2, placeHolder: "Explain About Other Service", cornerRadius: 20, color: .white)
        }
    }
    
    // third cell
    @IBOutlet weak var btnBehaviour:UIButton!
    @IBOutlet weak var btnNeurology:UIButton!
    @IBOutlet weak var btnOncology:UIButton!
    @IBOutlet weak var btnRadiology:UIButton!
    @IBOutlet weak var btnDermatology:UIButton!
    @IBOutlet weak var btnCardiology:UIButton!
    @IBOutlet weak var btnOphthalmology:UIButton!
    @IBOutlet weak var btnSurgery:UIButton!
    
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
