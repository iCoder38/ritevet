//
//  OtherPetServiceTypes.swift
//  RiteVet
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import CRNotifications

class OtherPetServiceTypes: UIViewController {
    
    let cellReuseIdentifier = "otherPetServicesTypesTableCell"
    
    var btnGroomingPetSaloon:UIButton!
    var strGroomingPetSaloon:String!
    
    var btnPetHotelBoarding:UIButton!
    var strPetHotelBoarding:String!
    
    var btnPetWalking:UIButton!
    var strPetWalking:String!
    
    var btnPetSettingAndCareInThePetOwner:UIButton!
    var strPetSettingAndCareInThePetOwner:String!
    
    var btnPetTraining:UIButton!
    var strPetTraining:String!
    
    var btnOther:UIButton!
    var strOther:String!
    
    var label1:UILabel!
    
    var btnDog:UIButton!
    var strDog:String!
    
    var btnCat:UIButton!
    var strCat:String!
    
    var btnPoultry:UIButton!
    var strPoultry:String!
    
    var btnReptiles:UIButton!
    var strReptiles:String!
    
    var btnExcoticBirds:UIButton!
    var strExcoticBirds:String!
    
    var btnFoodAnimalDiary:UIButton!
    var strFoodAnimalDiary:String!
    
    var btnEquine:UIButton!
    var strEquine:String!
    
    var btnOther2:UIButton!
    var strOther2:String!
    
    var txtPets:UITextField!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "OTHER PET SERVICE"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        //btnNext.addTarget(self, action: #selector(nextClickMethod), for: .touchUpInside)
        
        //self.UIdesignOfVeterinaryRegistration()
        
        strGroomingPetSaloon = "0"
        strPetHotelBoarding = "0"
        strPetWalking = "0"
        strPetSettingAndCareInThePetOwner = "0"
        strPetTraining = "0"
        
        strDog = "0"
        strCat = "0"
        strPoultry = "0"
        strReptiles = "0"
        strExcoticBirds = "0"
        strFoodAnimalDiary = "0"
        strEquine = "0"
        strOther2 = "0"
        
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

}

extension OtherPetServiceTypes: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OtherPetServicesTypesTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! OtherPetServicesTypesTableCell
        
        cell.backgroundColor = .clear
        
        if indexPath.row == 0  {
            let label = UILabel(frame: CGRect(x: 15, y: 11, width: 345, height: 22))
            label.textAlignment = .left
            label.text = "TYPE OF SERVICES"
            label.textColor = .black
            label.font = UIFont.init(name: "OpenSans-Bold", size: 20)
            cell.addSubview(label)
            
            let pluss = 40
            
            btnGroomingPetSaloon = UIButton(frame: CGRect(x: 15, y: 35, width: 34, height: 34))
            btnGroomingPetSaloon.tag = 0
            btnGroomingPetSaloon.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnGroomingPetSaloon.addTarget(self, action: #selector(generalClick), for: .touchUpInside)
            cell.addSubview(btnGroomingPetSaloon)
           
            let lblGroomingPetSaloon = UILabel(frame: CGRect(x: 57, y: 35, width: 250, height: 34))
            lblGroomingPetSaloon.text = "Grooming / Pet Saloon"
            lblGroomingPetSaloon.font = UIFont.init(name: "OpenSans-Light", size: 18)
            cell.addSubview(lblGroomingPetSaloon)
            
            
            
            // pet hotel
            btnPetHotelBoarding = UIButton(frame: CGRect(x: 15, y: 35+pluss, width: 34, height: 34))
             btnPetHotelBoarding.tag = 0
             btnPetHotelBoarding.setImage(UIImage(named: "tickWhite"), for: .normal)
             btnPetHotelBoarding.addTarget(self, action: #selector(PetHotelBoardingClick), for: .touchUpInside)
             cell.addSubview(btnPetHotelBoarding)
            
             let lblPetHotelBoarding = UILabel(frame: CGRect(x: 57, y: 35+pluss, width: 250, height: 34))
             lblPetHotelBoarding.text = "Pet Hotel / Boarding"
             lblPetHotelBoarding.font = UIFont.init(name: "OpenSans-Light", size: 18)
             cell.addSubview(lblPetHotelBoarding)
            
            
            // pet walking
            btnPetWalking = UIButton(frame: CGRect(x: 15, y: 35+pluss+pluss, width: 34, height: 34))
             btnPetWalking.tag = 0
             btnPetWalking.setImage(UIImage(named: "tickWhite"), for: .normal)
             btnPetWalking.addTarget(self, action: #selector(PetWalkingClick), for: .touchUpInside)
             cell.addSubview(btnPetWalking)
            
             let lblPetWalking = UILabel(frame: CGRect(x: 57, y: 35+pluss+pluss, width: 250, height: 34))
             lblPetWalking.text = "Pet Walking / Setting"
             lblPetWalking.font = UIFont.init(name: "OpenSans-Light", size: 18)
             cell.addSubview(lblPetWalking)
            
            
            // pet Pet Setting & Care in the pet owner / parent.
            btnPetSettingAndCareInThePetOwner = UIButton(frame: CGRect(x: 15, y: 35+pluss+pluss+pluss, width: 34, height: 34))
             btnPetSettingAndCareInThePetOwner.tag = 0
             btnPetSettingAndCareInThePetOwner.setImage(UIImage(named: "tickWhite"), for: .normal)
             btnPetSettingAndCareInThePetOwner.addTarget(self, action: #selector(PetSettingAndCareInThePetOwnerClick), for: .touchUpInside)
             cell.addSubview(btnPetSettingAndCareInThePetOwner)
            
            let lblPetSettingAndCareInThePetOwner = UILabel(frame: CGRect(x: 57, y: 35+pluss+pluss+pluss, width: 320, height: 34))
             lblPetSettingAndCareInThePetOwner.text = "Pet Sitting & Care in the pet owner / parent."
             lblPetSettingAndCareInThePetOwner.font = UIFont.init(name: "OpenSans-Light", size: 18)
             cell.addSubview(lblPetSettingAndCareInThePetOwner)
            
            
            // pet training.
            btnPetTraining = UIButton(frame: CGRect(x: 15, y: 35+pluss+pluss+pluss+pluss, width: 34, height: 34))
             btnPetTraining.tag = 0
             btnPetTraining.setImage(UIImage(named: "tickWhite"), for: .normal)
             btnPetTraining.addTarget(self, action: #selector(PetTrainingClick), for: .touchUpInside)
             cell.addSubview(btnPetTraining)
            
             let lblPetTraining = UILabel(frame: CGRect(x: 57, y: 35+pluss+pluss+pluss+pluss, width: 250, height: 34))
             lblPetTraining.text = "Pet Training."
             lblPetTraining.font = UIFont.init(name: "OpenSans-Light", size: 18)
             cell.addSubview(lblPetTraining)
            
            
            // other.
            btnOther = UIButton(frame: CGRect(x: 15, y: 35+pluss+pluss+pluss+pluss+pluss, width: 34, height: 34))
             btnOther.tag = 0
             btnOther.setImage(UIImage(named: "tickWhite"), for: .normal)
             btnOther.addTarget(self, action: #selector(OtherClick), for: .touchUpInside)
             cell.addSubview(btnOther)
            
             let lblOther = UILabel(frame: CGRect(x: 57, y: 35+pluss+pluss+pluss+pluss+pluss, width: 250, height: 34))
             lblOther.text = "Other Services."
             lblOther.font = UIFont.init(name: "OpenSans-Light", size: 18)
             cell.addSubview(lblOther)
            
            
            // text field
            txtPets = UITextField(frame: CGRect(x: 15, y: 35+pluss+pluss+pluss+pluss+pluss+pluss, width: 345, height: 50))
            Utils.textFieldDR(text: txtPets, placeHolder: "Explain About Other Service", cornerRadius: 20, color: .white)
            cell.addSubview(txtPets)
        }
        else
        if indexPath.row == 1 {
                label1 = UILabel(frame: CGRect(x: 15, y: 11, width: 345, height: 22))
                label1.textAlignment = .left
                label1.text = "TYPE OF PETS"
                label1.textColor = .black
                label1.font = UIFont.init(name: "OpenSans-Bold", size: 20)
                cell.addSubview(label1)
                
                // dog
                btnDog = UIButton(frame: CGRect(x: 15, y: 35, width: 34, height: 34))
                btnDog.tag = 0
                btnDog.setImage(UIImage(named: "tickWhite"), for: .normal)
                btnDog.addTarget(self, action: #selector(dogClick), for: .touchUpInside)
                cell.addSubview(btnDog)
                
                let lblDog = UILabel(frame: CGRect(x: 57, y: 35, width: 43, height: 34))
                lblDog.text = "Dog"
                lblDog.font = UIFont.init(name: "OpenSans-Light", size: 18)
                cell.addSubview(lblDog)
                
                
                
                
                // cat
                btnCat = UIButton(frame: CGRect(x: 108, y: 35, width: 34, height: 34))
                btnCat.tag = 0
                btnCat.setImage(UIImage(named: "tickWhite"), for: .normal)
                btnCat.addTarget(self, action: #selector(catClick), for: .touchUpInside)
                cell.addSubview(btnCat)
                
                let lblCat = UILabel(frame: CGRect(x: 150, y: 35, width: 43, height: 34))
                lblCat.text = "Cat"
                lblCat.font = UIFont.init(name: "OpenSans-Light", size: 18)
                cell.addSubview(lblCat)
                
                // poultry
                btnPoultry = UIButton(frame: CGRect(x: 201, y: 35, width: 34, height: 34))
                btnPoultry.tag = 0
                btnPoultry.setImage(UIImage(named: "tickWhite"), for: .normal)
                btnPoultry.addTarget(self, action: #selector(poultryClick), for: .touchUpInside)
                cell.addSubview(btnPoultry)
                
                let lblPoultry = UILabel(frame: CGRect(x: 243, y: 35, width: 70, height: 34))
                lblPoultry.text = "Poultry"
                lblPoultry.font = UIFont.init(name: "OpenSans-Light", size: 18)
                cell.addSubview(lblPoultry)
                
                
                // reptiles
                btnReptiles = UIButton(frame: CGRect(x: 15, y: 80, width: 34, height: 34))
                btnReptiles.tag = 0
                btnReptiles.setImage(UIImage(named: "tickWhite"), for: .normal)
                btnReptiles.addTarget(self, action: #selector(ReptilesClick), for: .touchUpInside)
                cell.addSubview(btnReptiles)
                
                let lblReptiles = UILabel(frame: CGRect(x: 60, y: 80, width: 70, height: 34))
                lblReptiles.text = "Reptiles"
                lblReptiles.font = UIFont.init(name: "OpenSans-Light", size: 18)
                cell.addSubview(lblReptiles)
                
                
                // excotic birds
                btnExcoticBirds = UIButton(frame: CGRect(x: 155, y: 80, width: 34, height: 34))
                btnExcoticBirds.tag = 0
                btnExcoticBirds.setImage(UIImage(named: "tickWhite"), for: .normal)
                btnExcoticBirds.addTarget(self, action: #selector(ExcoticBirdsClick), for: .touchUpInside)
                cell.addSubview(btnExcoticBirds)
                
                let lblExcoticBirds = UILabel(frame: CGRect(x: 197, y: 80, width: 160, height: 34))
                lblExcoticBirds.text = "Excotic Birds"
                lblExcoticBirds.font = UIFont.init(name: "OpenSans-Light", size: 18)
                cell.addSubview(lblExcoticBirds)
                
                // food animals diary
                btnFoodAnimalDiary = UIButton(frame: CGRect(x: 15, y: 125, width: 34, height: 34))
                btnFoodAnimalDiary.tag = 0
                btnFoodAnimalDiary.setImage(UIImage(named: "tickWhite"), for: .normal)
                btnFoodAnimalDiary.addTarget(self, action: #selector(FoodAnimalDiaryClick), for: .touchUpInside)
                cell.addSubview(btnFoodAnimalDiary)
                
                let lblFoodAnimalDiary = UILabel(frame: CGRect(x: 60, y: 125, width: 154, height: 34))
                lblFoodAnimalDiary.text = "Food Animal Diary"
                lblFoodAnimalDiary.font = UIFont.init(name: "OpenSans-Light", size: 18)
                cell.addSubview(lblFoodAnimalDiary)
                
                
                // equine
                btnEquine = UIButton(frame: CGRect(x: 222, y: 125, width: 34, height: 34))
                btnEquine.tag = 0
                btnEquine.setImage(UIImage(named: "tickWhite"), for: .normal)
                btnEquine.addTarget(self, action: #selector(equineClick), for: .touchUpInside)
                cell.addSubview(btnEquine)
                
                let lblEquine = UILabel(frame: CGRect(x: 267, y: 125, width: 154, height: 34))
                lblEquine.text = "Equine"
                lblEquine.font = UIFont.init(name: "OpenSans-Light", size: 18)
                cell.addSubview(lblEquine)
                
                // others
                btnOther2 = UIButton(frame: CGRect(x: 15, y: 170, width: 34, height: 34))
                btnOther2.tag = 0
                btnOther2.setImage(UIImage(named: "tickWhite"), for: .normal)
                btnOther2.addTarget(self, action: #selector(Other2Click), for: .touchUpInside)
                cell.addSubview(btnOther2)
                
                let lblOther2 = UILabel(frame: CGRect(x: 60, y: 170, width: 154, height: 34))
                lblOther2.text = "Other"
                lblOther2.font = UIFont.init(name: "OpenSans-Light", size: 18)
                cell.addSubview(lblOther2)
            
            // others
            let btnNext = UIButton(frame: CGRect(x: 15, y: 230, width: self.view.frame.size.width-45, height: 50))
            btnNext.tag = 0
            Utils.buttonDR(button: btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
            //btnNext.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnNext.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
            cell.addSubview(btnNext)
        }
        
        
        
        return cell
    }
    
    @objc func nextClick() {
        
        // MARK:- FIRST CELL STR -
        var addAllStrings1 = String(strGroomingPetSaloon)+","+String(strPetHotelBoarding)+","+String(strPetWalking)+","+String(strPetSettingAndCareInThePetOwner)+","+String(strPetTraining)
        
        addAllStrings1 = addAllStrings1.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        addAllStrings1 = addAllStrings1.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        
        // MARK:- SECOND CELL STR -
        
        let addOne = String(strDog)+","+String(strCat)+","+String(strPoultry)+","+String(strReptiles)
        let addTwo = String(strExcoticBirds)+","+String(strEquine)+","+String(strFoodAnimalDiary)+","+String(strOther2)
        
        var addAllStrings = String(addOne)+","+String(addTwo)
            
            // String(strDog)+","+String(strCat)+","+String(strPoultry)+","+String(strReptiles)+","+String(strExcoticBirds)+","+String(strEquine)+","+String(strFoodAnimalDiary)+","+String(strOther2)
        
        addAllStrings = addAllStrings.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        addAllStrings = addAllStrings.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        
        if addAllStrings1 == "0" {
           CRNotifications.showNotification(type: CRNotifications.error, title: "Hurray!", message:"Please select atleast one Type of Service", dismissDelay: 1.5, completion:{})
        }
        else if addAllStrings == "0" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Hurray!", message:"Please select atleast one Type of Pets", dismissDelay: 1.5, completion:{})
        }
        else
        {
        
        //let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! OtherPetServicesTypesTableCell
        
        
        //print(addAllStrings1 as Any)
        //print(addAllStrings as Any)
        
        let someDict:[String:String] = [
                        "typeofservice":String(addAllStrings1),
                        "typeofServiceComment":String(txtPets.text!),
                        "typeofpet":String(addAllStrings),
        ]
        
       let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OtherPetServiceBusinessInfoId") as? OtherPetServiceBusinessInfo
        push!.getDictOtherPetServiceFirstPage = someDict
       self.navigationController?.pushViewController(push!, animated: true)
    }
       }
    
    //MARK:- ALL BUTTON CLICK METHOD -
    @objc func dogClick() {
        if btnDog.tag == 0 {
            strDog = "1"
                 btnDog.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnDog.tag = 1
             }
             else if btnDog.tag == 1 {
            strDog = "0"
                 btnDog.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnDog.tag = 0
             }
    }
    
    @objc func catClick() {
        if btnCat.tag == 0 {
            strCat = "2"
                 btnCat.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnCat.tag = 1
             }
             else if btnDog.tag == 1 {
            strCat = "0"
                 btnCat.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnCat.tag = 0
             }
    }
    
    @objc func poultryClick() {
        if btnPoultry.tag == 0 {
            strPoultry = "3"
                 btnPoultry.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnPoultry.tag = 1
             }
             else if btnPoultry.tag == 1 {
            strPoultry = "0"
                 btnPoultry.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnPoultry.tag = 0
             }
    }
    @objc func ReptilesClick() {
        if btnReptiles.tag == 0 {
            strReptiles = "4"
                 btnReptiles.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnReptiles.tag = 1
             }
             else if btnReptiles.tag == 1 {
            strReptiles = "0"
                 btnReptiles.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnReptiles.tag = 0
             }
    }
    @objc func ExcoticBirdsClick() {
        if btnExcoticBirds.tag == 0 {
            strExcoticBirds = "5"
                 btnExcoticBirds.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnExcoticBirds.tag = 1
             }
             else if btnExcoticBirds.tag == 1 {
            strExcoticBirds = "0"
                 btnExcoticBirds.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnExcoticBirds.tag = 0
             }
    }
    
    @objc func equineClick() {
        if btnEquine.tag == 0 {
            strEquine = "6"
                 btnEquine.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnEquine.tag = 1
             }
             else if btnEquine.tag == 1 {
            strEquine = "0"
                 btnEquine.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnEquine.tag = 0
             }
    }
    
    @objc func FoodAnimalDiaryClick() {
        if btnFoodAnimalDiary.tag == 0 {
            strFoodAnimalDiary = "7"
                 btnFoodAnimalDiary.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnFoodAnimalDiary.tag = 1
             }
             else if btnFoodAnimalDiary.tag == 1 {
            strFoodAnimalDiary = "0"
                 btnFoodAnimalDiary.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnFoodAnimalDiary.tag = 0
             }
    }
    @objc func Other2Click() {
        if btnOther2.tag == 0 {
            strOther2 = "8"
                 btnOther2.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnOther2.tag = 1
             }
             else if btnOther2.tag == 1 {
            strOther2 = "0"
                 btnOther2.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnOther2.tag = 0
             }
    }
    
    // MARK:- FIRST BLOCK
    // first
    @objc func generalClick() {
        if btnGroomingPetSaloon.tag == 0 {
            strGroomingPetSaloon = "1"
                 btnGroomingPetSaloon.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnGroomingPetSaloon.tag = 1
             }
             else if btnGroomingPetSaloon.tag == 1 {
            strGroomingPetSaloon = "0"
                 btnGroomingPetSaloon.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnGroomingPetSaloon.tag = 0
             }
    }
    
    //MARK:- PET HOTEL BOARDING
    @objc func PetHotelBoardingClick() {
        if btnPetHotelBoarding.tag == 0 {
            strPetHotelBoarding = "2"
                 btnPetHotelBoarding.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnPetHotelBoarding.tag = 1
             }
             else if btnPetHotelBoarding.tag == 1 {
            strPetHotelBoarding = "0"
                 btnPetHotelBoarding.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnPetHotelBoarding.tag = 0
             }
    }
    
    // MARK:- PET WALKING
    @objc func PetWalkingClick() {
        if btnPetWalking.tag == 0 {
            strPetWalking = "3"
                 btnPetWalking.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnPetWalking.tag = 1
             }
             else if btnPetWalking.tag == 1 {
            strPetWalking = "0"
                 btnPetWalking.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnPetWalking.tag = 0
             }
    }
    
    // MARK:- PET SETTING AND CARE
    @objc func PetSettingAndCareInThePetOwnerClick() {
        if btnPetSettingAndCareInThePetOwner.tag == 0 {
            strPetSettingAndCareInThePetOwner = "4"
                 btnPetSettingAndCareInThePetOwner.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnPetSettingAndCareInThePetOwner.tag = 1
             }
             else if btnPetSettingAndCareInThePetOwner.tag == 1 {
            strPetSettingAndCareInThePetOwner = "0"
                 btnPetSettingAndCareInThePetOwner.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnPetSettingAndCareInThePetOwner.tag = 0
             }
    }
    
    // MARK:- PET TRAINING
    @objc func PetTrainingClick() {
        if btnPetTraining.tag == 0 {
            strPetTraining = "5"
                 btnPetTraining.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnPetTraining.tag = 1
             }
             else if btnPetTraining.tag == 1 {
            strPetSettingAndCareInThePetOwner = "0"
                 btnPetTraining.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnPetTraining.tag = 0
             }
    }
    
    
    // MARK:- OTHER
    @objc func OtherClick() {
        if btnOther.tag == 0 {
            strOther = "6"
                 btnOther.setImage(UIImage(named: "tickGreen"), for: .normal)
                 btnOther.tag = 1
             }
             else if btnOther.tag == 1 {
            strOther = "0"
                 btnOther.setImage(UIImage(named: "tickWhite"), for: .normal)
                 btnOther.tag = 0
             }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

extension OtherPetServiceTypes: UITableViewDelegate
{
    
}
