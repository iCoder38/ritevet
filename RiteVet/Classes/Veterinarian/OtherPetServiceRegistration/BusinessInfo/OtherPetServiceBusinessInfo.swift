//
//  OtherPetServiceBusinessInfo.swift
//  RiteVet
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class OtherPetServiceBusinessInfo: UIViewController {

    var getDictOtherPetServiceFirstPage:Dictionary<AnyHashable, Any>!
    
    @IBOutlet weak var viewNavigation:UIView! {
           didSet {
               viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
           }
       }
       @IBOutlet weak var btnBack:UIButton!
       @IBOutlet weak var lblNavigationTitle:UILabel! {
           didSet {
               lblNavigationTitle.text = "OTHER PET SERVICES"
               lblNavigationTitle.textColor = .white
           }
       }
    
    @IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtMiddleName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtVeterinaryLicenceNumber:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtBusinessName:UITextField!
    @IBOutlet weak var txtBusinessLicenceNumber:UITextField!
    @IBOutlet weak var txtIENTAXidNumber:UITextField!
    
    @IBOutlet weak var btnNext:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(nextClickMethod), for: .touchUpInside)
        
        //print(getDictOtherPetServiceFirstPage as Any)
        
        self.UIdesignOfVeterinaryRegistration()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextClickMethod() {
        let someDict:[String:String] = [
            "firstname":String(txtFirstName.text!),
            "lastname":String(txtLastName.text!),
            "licensenumber":String(txtVeterinaryLicenceNumber.text!),
            "state":String(txtState.text!),
            "businessname":String(txtBusinessName.text!),
            "businesslicensenumber":String(txtBusinessLicenceNumber.text!),
            "ientax":String(txtIENTAXidNumber.text!)
        ]
        
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OtherPetServiceAddressId") as? OtherPetServiceAddress
        push!.getDictOtherPetServiceSecondPage = someDict
        push!.getDictOtherPetServiceFromFirstPage = getDictOtherPetServiceFirstPage
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    //MARK:-
    @objc func UIdesignOfVeterinaryRegistration() {
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: txtFirstName, placeHolder: "First Name", cornerRadius: 20, color: .white)
        //Utils.textFieldDR(text: txtMiddleName, placeHolder: "Middle Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtLastName, placeHolder: "Last Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtVeterinaryLicenceNumber, placeHolder: "Veterinary license number", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtState, placeHolder: "State", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtBusinessName, placeHolder: "Business Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtBusinessLicenceNumber, placeHolder: "Business license number", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtIENTAXidNumber, placeHolder: "IEN / TAX ID Number", cornerRadius: 20, color: .white)
        
        /****** FINISH BUTTON *********/
        Utils.buttonDR(button: btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
    }
}
