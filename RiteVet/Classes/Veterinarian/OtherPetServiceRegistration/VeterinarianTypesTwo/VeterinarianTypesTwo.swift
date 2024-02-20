//
//  VeterinarianTypesTwo.swift
//  RiteVet
//
//  Created by Apple on 13/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView
import CRNotifications

class VeterinarianTypesTwo: UIViewController {
    
    let strDeSelectImage:String = "tickWhite"
    let strSelectImage:String = "tickGreen"
    
    let cellReuseIdentifier = "veterinarianTypesTableCell"
    
    var label1:UILabel!
    
    var strDog:String!
    
    var strCat:String!
    
    var strPoultry:String!
    
    var strReptiles:String!
    
    var strExcoticBirds:String!
    
    var strFoodAnimalDiary:String!
    
    var strEquine:String!
    
    var strOther:String!
    
    var txtPets:UITextField!
    var txtPets2:UITextField!
    
    
    var strGrooming:String!
    var strOtherService:String!
    var strPetHotel:String!
    var strPetSetting:String!
    var strPetTranning:String!
    var strPetWalking:String!
    
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
    
    @IBOutlet weak var btnNext:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // tbleView.delegate = self
            // tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.welcome3()
        
        /*
        if let dog = UserDefaults.standard.string(forKey: "VRdog")
         {
             if dog == "0"
             {
                print("dog 0")
                strDog = "0"
                 //btnDog.setImage(UIImage(named: "tickWhite"), for: .normal)
             }
             else if dog == "1"
             {
                print("dog 1")
                strDog = "1"
                 //btnDog.setImage(UIImage(named: "tickGreen"), for: .normal)
             }
         }
        else
        {
            strDog = "0"
        }
         
         // cat
         if let cat = UserDefaults.standard.string(forKey: "VRcat")
         {
             if cat == "0"
             {
                 strCat = "0"
             }
             else if cat == "2"
             {
                 strCat = "2"
             }
         }
        else
         {
            strCat = "0"
        }
         
         
         // poultry
         if let poultry = UserDefaults.standard.string(forKey: "VRpoultry")
         {
             if poultry == "0"
             {
                 strPoultry = "0"
             }
             else if poultry == "3"
             {
                 strPoultry = "3"
             }
         }
        else
         {
            strPoultry = "0"
        }
         
         // reptiles
         if let reptiles = UserDefaults.standard.string(forKey: "VRreptiles")
         {
             if reptiles == "0"
             {
                 print("reptiles 1")
                strReptiles = "0"
             }
             else if reptiles == "4"
             {
                 strReptiles = "4"
             }
         }
         else
          {
             strReptiles = "0"
         }
         
         
         // excotic birds
         if let excoticbirds = UserDefaults.standard.string(forKey: "VRexcoticbirds")
         {
             if excoticbirds == "0"
             {
                 strExcoticBirds = "0"
             }
             else if excoticbirds == "5"
             {
                 strExcoticBirds = "5"
             }
         }
         else
          {
             strExcoticBirds = "0"
         }
         
         // equine
        if let equine = UserDefaults.standard.string(forKey: "VRequine")
        {
            if equine == "0"
            {
                strEquine = "0"
            }
            else if equine == "6"
            {
                strEquine = "6"
            }
        }
         else
          {
             strEquine = "0"
         }
         
         // food animal and diary
         if let foodanimal = UserDefaults.standard.string(forKey: "VRfoodandanimaldiary")
         {
             if foodanimal == "0"
             {
                 strFoodAnimalDiary = "0"
             }
             else if foodanimal == "7"
             {
                 strFoodAnimalDiary = "7"
             }
         }
         else
          {
             strFoodAnimalDiary = "0"
         }
         
         // food animal and diary
         if let firstother = UserDefaults.standard.string(forKey: "VRother")
         {
             if firstother == "0"
             {
                 strOther = "0"
             }
             else if firstother == "8"
             {
                 strOther = "8"
             }
         }
        else
         {
            strOther = "0"
        }
        
        
        
        
        
        
        
        // ****
        if let general = UserDefaults.standard.string(forKey: "VRgeneral")
        {
            if general == "0"
            {
                strGeneral = "0"
            }
            else if general == "1"
            {
                strGeneral = "1"
            }
        }
        else
        {
            strGeneral = "0"
        }
        
         
        // 2
        // food animal and diary
        if let wellness = UserDefaults.standard.string(forKey: "VRwellness")
        {
            if wellness == "0"
            {
                strWelness = "0"
            }
            else if wellness == "2"
            {
                strWelness = "2"
            }
        }
        else
        {
            strWelness = "0"
        }
        
         
         
        // food animal and diary
        if let imaging = UserDefaults.standard.string(forKey: "VRimaging")
        {
            if imaging == "0"
            {
                strImaging = "0"
            }
            else if imaging == "3"
            {
                strImaging = "3"
            }
        }
        else
        {
            strImaging = "0"
        }
        
         
         
        // food animal and diary
        if let diagnostic = UserDefaults.standard.string(forKey: "VRdiagnostic")
        {
            if diagnostic == "0"
            {
                strDiagnosticLab = "0"
            }
            else if diagnostic == "4"
            {
                strDiagnosticLab = "4"
            }
        }
        else
        {
            strDiagnosticLab = "0"
        }
         
         
        // food animal and diary
        if let dental = UserDefaults.standard.string(forKey: "VRdental")
        {
            if dental == "0"
            {
                strDental = "0"
            }
            else if dental == "5"
            {
                strDental = "5"
            }
        }
        else
        {
            strDental = "0"
        }
         
         
        // food animal and diary
        if let bording = UserDefaults.standard.string(forKey: "VRboarding")
        {
            if bording == "0"
            {
                strBoarding = "0"
            }
            else if bording == "6"
            {
                strBoarding = "6"
            }
        }
        else
        {
            strBoarding = "0"
        }
        
         
        // food animal and diary
        if let secondOther = UserDefaults.standard.string(forKey: "VRother2")
        {
            if secondOther == "0"
            {
                strOther2 = "0"
            }
            else if secondOther == "7"
            {
                strOther2 = "7"
            }
        }
        else
        {
            strOther2 = "0"
        }
        
        
        
        
        
        
        // **************
        if let firstother = UserDefaults.standard.string(forKey: "VRbehaviour")
        {
            if firstother == "0"
            {
                strBehaviour = "0"
            }
            else if firstother == "1"
            {
                strBehaviour = "1"
            }
        }
        else
        {
            strBehaviour = "0"
        }
        
        
        
        
        if let firstother = UserDefaults.standard.string(forKey: "VRneurology")
        {
            if firstother == "0"
            {
             strNeurology = "0"
            }
            else if firstother == "2"
            {
                strNeurology = "2"
            }
        }
        else
        {
            strNeurology = "0"
        }
        
        
        if let firstother = UserDefaults.standard.string(forKey: "VRoncology")
        {
            if firstother == "0"
            {
                strOncology = "0"
            }
            else if firstother == "3"
            {
                strOncology = "3"
            }
        }
        else
        {
            strOncology = "0"
        }
        
        
        if let firstother = UserDefaults.standard.string(forKey: "VRradiology")
        {
            if firstother == "0"
            {
                strOncology = "0"
            }
            else if firstother == "4"
            {
                strOncology = "4"
            }
        }
        else
        {
            strRadiology = "0"
        }
        
        
        if let firstother = UserDefaults.standard.string(forKey: "VRdermatalogy")
        {
            if firstother == "0"
            {
                strDermatalogy = "0"
            }
            else if firstother == "5"
            {
                strDermatalogy = "5"
            }
        }
        else
        {
            strDermatalogy = "0"
        }
        
        
        if let firstother = UserDefaults.standard.string(forKey: "VRcardiology")
        {
            if firstother == "0"
            {
                strCardilogy = "0"
            }
            else if firstother == "6"
            {
                strCardilogy = "6"
            }
        }
        else
        {
            strCardilogy = "0"
        }
        
        
        if let firstother = UserDefaults.standard.string(forKey: "VRophthalmogy")
        {
            if firstother == "0"
            {
                strOphthalmology = "0"
            }
            else if firstother == "7"
            {
                strOphthalmology = "7"
            }
        }
        else
        {
            strOphthalmology = "0"
        }
        
        
        if let firstother = UserDefaults.standard.string(forKey: "VRsurgery")
        {
            if firstother == "0"
            {
             strSurgery = "0"
            }
            else if firstother == "8"
            {
                strSurgery = "8"
            }
        }
        else
        {
            strSurgery = "0"
        }
        */
        
        
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
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VeterinarianTypesId") as? VeterinarianTypes
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    
    
    @objc func welcome3() {
        // indicator.startAnimating()
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "returnprofile",
                "userId"    : String(myString),
                "UTYPE"     : "3"
            ]
        }
                
        print("parameters-------\(String(describing: parameters))")
                   
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON { [self]
            response in
               
            switch(response.result) {
            case .success(_):
                if let data = response.value {

                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                              
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        
                         var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        
                        
                        // typeOfBusiness = 2;
                        // tickWhite
                        // tickGreen
                        
                        // Specialization
                        /*
                         data =     (
                                     {
                                 id = 2;
                                 name = Cat;
                             },
                                     {
                                 id = 1;
                                 name = Dogs;
                             },
                                     {
                                 id = 7;
                                 name = "Exotic Animals";
                             },
                                     {
                                 id = 5;
                                 name = "Exotic Birds";
                             },
                                     {
                                 id = 6;
                                 name = "Food Animals & Dairy";
                             },
                                     {
                                 id = 8;
                                 name = "Lab. Animal";
                             },
                                     {
                                 id = 4;
                                 name = Others;
                             },
                                     {
                                 id = 3;
                                 name = Poultry;
                             }
                         );
                         status = success;
                         */
                        
                        /*
                         self.strDog = "0"
                         self.strCat = "0"
                         self.strPoultry = "0"
                         self.strReptiles = "0"
                         self.strExcoticBirds = "0"
                         self.strEquine = "0"
                         self.strFoodAnimalDiary = "0"
                         self.strOther = "0"
                         */
                        
                        /*
                         @IBOutlet weak var lblTypeOfSpecialization:UILabel!
                         @IBOutlet weak var btnDog:UIButton!
                         @IBOutlet weak var btnCat:UIButton!
                         @IBOutlet weak var btnPoultry:UIButton!
                         @IBOutlet weak var btnReptiles:UIButton!
                         @IBOutlet weak var btnExcoticBirds:UIButton!
                         @IBOutlet weak var btnFoodAnimalAndDiary:UIButton!
                         @IBOutlet weak var btnEquine:UIButton!
                         @IBOutlet weak var btnOther:UIButton!
                         */
                        
                        // one
                        self.strDog = "0"
                        self.strCat = "0"
                        self.strPoultry = "0"
                        self.strReptiles = "0" // excotic animals
                        self.strExcoticBirds = "0"
                        self.strEquine = "0" // lab animals
                        self.strFoodAnimalDiary = "0"
                        self.strOther = "0"
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        
                        let indexPath = IndexPath.init(row: 0, section: 0)
                        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
                        
                        cell.btnDog.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnCat.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnPoultry.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnExcoticBirds.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnFoodAnimalAndDiary.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnExcoticAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnOther.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnLabAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)
                        
                        cell.txtOther.text = (dict["otherService"] as! String)
                        
                        let array = (dict["typeOfPets"] as! String).components(separatedBy: ",")
                        print(array as Any)
                        
                        for index in 0..<array.count {
                            
                            let item = array[index]
                            print(item as Any)
                            
                            if item == "1" { // Dog
                                
                                self.strDog = "1"
                                cell.btnDog.tag = 1
                                cell.btnDog.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "2" { // Cat
                                
                                self.strCat = "2"
                                cell.btnCat.tag = 1
                                cell.btnCat.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "3" { // Poultry
                                
                                self.strPoultry = "3"
                                cell.btnPoultry.tag = 1
                                cell.btnPoultry.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "4" { // Others
                                
                                self.strOther = "4"
                                cell.btnOther.tag = 1
                                cell.btnOther.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "5" { // Exotic Birds
                                
                                self.strExcoticBirds = "5"
                                cell.btnExcoticBirds.tag = 1
                                cell.btnExcoticBirds.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "6" { // Food Animals & Dairy
                                
                                self.strFoodAnimalDiary = "6"
                                cell.btnFoodAnimalAndDiary.tag = 1
                                cell.btnFoodAnimalAndDiary.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "7" { // Exotic Animals
                                
                                self.strReptiles = "7"
                                cell.btnExcoticAnimals.tag = 1
                                cell.btnExcoticAnimals.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "8" { // Lab. Animal
                                
                                self.strEquine = "8"
                                cell.btnLabAnimals.tag = 1
                                cell.btnLabAnimals.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else {
                                cell.btnDog.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnCat.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnPoultry.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnExcoticBirds.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnFoodAnimalAndDiary.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnExcoticAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnOther.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnLabAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)

                            }
                            
                        }
                        
                        
                        
                        /*
                         var strGrooming:String!
                         var strOtherService:String!
                         var strPetHotel:String!
                         var strPetSetting:String!
                         var strPetTranning:String!
                         var strPetWalking:String!
                         */
                        
                        /*
                         @IBOutlet weak var btnGrooming:UIButton!
                         @IBOutlet weak var btnOtherServices:UIButton!
                         @IBOutlet weak var btnImaging:UIButton!
                         @IBOutlet weak var btnPetHotel:UIButton!
                         @IBOutlet weak var btnPetSettingAnd:UIButton!
                         @IBOutlet weak var btnPetTraining:UIButton!
                         @IBOutlet weak var btnPetWalking:UIButton!
                         */
                        
                        self.strGrooming = "0"
                        self.strOtherService = "0"
                        self.strPetHotel = "0"
                        self.strPetSetting = "0"
                        self.strPetTranning = "0"
                        self.strPetWalking = "0"
 
                        cell.btnGrooming.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnOtherServices.setImage(UIImage(named: "tickWhite"), for: .normal)
                        // cell.btnImaging.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnPetHotel.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnPetSettingAnd.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnPetTraining.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnPetWalking.setImage(UIImage(named: "tickWhite"), for: .normal)
                        
                        let array2 = (dict["TypeOfService"] as! String).components(separatedBy: ",")
                        print(array2 as Any)
                        
                        for index in 0..<array2.count {
                            
                            let item = array2[index]
                            print(item as Any)
                            
                            if item == "8" { // Dog
                                
                                self.strGrooming = "8"
                                cell.btnGrooming.tag = 1
                                cell.btnGrooming.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "13" { // Cat
                                
                                self.strOtherService = "13"
                                cell.btnOtherServices.tag = 1
                                cell.btnOtherServices.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "9" { // Poultry
                                
                                self.strPetHotel = "9"
                                cell.btnPetHotel.tag = 1
                                cell.btnPetHotel.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "11" { // Others
                                
                                self.strPetSetting = "11"
                                cell.btnPetSettingAnd.tag = 1
                                cell.btnPetSettingAnd.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "12" { // Exotic Birds
                                
                                self.strPetTranning = "12"
                                cell.btnPetTraining.tag = 1
                                cell.btnPetTraining.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "10" { // Food Animals & Dairy
                                
                                self.strPetWalking = "10"
                                cell.btnPetWalking.tag = 1
                                cell.btnPetWalking.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else {
                                cell.btnGrooming.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnOtherServices.setImage(UIImage(named: "tickWhite"), for: .normal)
                                // cell.btnImaging.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnPetHotel.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnPetSettingAnd.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnPetTraining.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnPetWalking.setImage(UIImage(named: "tickWhite"), for: .normal)
                            }
                            
                        }
                        
                        
                        
                        /*
                         @IBOutlet weak var btnGrooming:UIButton!
                         @IBOutlet weak var btnOtherServices:UIButton!
                         @IBOutlet weak var btnImaging:UIButton!
                         @IBOutlet weak var btnPetHotel:UIButton!
                         @IBOutlet weak var btnPetSettingAnd:UIButton!
                         @IBOutlet weak var btnPetTraining:UIButton!
                         @IBOutlet weak var btnPetWalking:UIButton!
                         */
                        
                        // first
                        cell.btnDog.addTarget(self, action: #selector(dogClick), for: .touchUpInside)
                        cell.btnCat.addTarget(self, action: #selector(catClick), for: .touchUpInside)
                        cell.btnPoultry.addTarget(self, action: #selector(poultryClick), for: .touchUpInside)
                        cell.btnLabAnimals.addTarget(self, action: #selector(ReptilesClick), for: .touchUpInside)
                        cell.btnExcoticBirds.addTarget(self, action: #selector(ExcoticBirdsClick), for: .touchUpInside)
                        cell.btnExcoticAnimals.addTarget(self, action: #selector(equineClick), for: .touchUpInside)
                        cell.btnFoodAnimalAndDiary.addTarget(self, action: #selector(FoodAnimalDiaryClick), for: .touchUpInside)
                        cell.btnOther.addTarget(self, action: #selector(OtherClick), for: .touchUpInside)
                        
                        
                        
                        
                        // second
                        cell.btnGrooming.addTarget(self, action: #selector(groomingClick), for: .touchUpInside)
                        cell.btnOtherServices.addTarget(self, action: #selector(otherServiceClick), for: .touchUpInside)
                        cell.btnPetHotel.addTarget(self, action: #selector(petHotelClick), for: .touchUpInside)
                        cell.btnPetSettingAnd.addTarget(self, action: #selector(petSettingAndClick), for: .touchUpInside)
                        cell.btnPetTraining.addTarget(self, action: #selector(petTrainingClick), for: .touchUpInside)
                        cell.btnPetWalking.addTarget(self, action: #selector(petWalkingClick), for: .touchUpInside)
                        
                        
                        
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
                        //  self.indicator.stopAnimating()
                        //  self.enableService()
                    }
                }

            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                Utils.RiteVetIndicatorHide()
                
//                               self.indicator.stopAnimating()
//                               self.enableService()
                let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
                               
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                               
                alertController.addAction(okAction)
                               
                self.present(alertController, animated: true, completion: nil)
                break
            }
        }
    }
    
    
    // MARK:- CLICKS -
    //MARK:- ALL BUTTON CLICK METHOD -
    @objc func dogClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnDog.tag == 0 {
            strDog = "1"
            cell.btnDog.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnDog.tag = 1
            
            UserDefaults.standard.set(strDog, forKey: "VRdog")
        }
        else if cell.btnDog.tag == 1 {
            strDog = "0"
            cell.btnDog.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnDog.tag = 0
            
            UserDefaults.standard.set(strDog, forKey: "VRdog")
        }
    }
    
    @objc func catClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnCat.tag == 0 {
            strCat = "2"
            cell.btnCat.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnCat.tag = 1
            UserDefaults.standard.set(strCat, forKey: "VRcat")
        }
        else if cell.btnCat.tag == 1 {
            strCat = "0"
            cell.btnCat.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnCat.tag = 0
            UserDefaults.standard.set(strCat, forKey: "VRcat")
        }
    }
    
    @objc func poultryClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnPoultry.tag == 0 {
            strPoultry = "3"
            cell.btnPoultry.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnPoultry.tag = 1
            UserDefaults.standard.set(strPoultry, forKey: "VRpoultry")
        }
        else if cell.btnPoultry.tag == 1 {
            strPoultry = "0"
            cell.btnPoultry.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnPoultry.tag = 0
            UserDefaults.standard.set(strPoultry, forKey: "VRpoultry")
        }
    }
    
    @objc func ReptilesClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnLabAnimals.tag == 0 {
            strReptiles = "4"
            cell.btnLabAnimals.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnLabAnimals.tag = 1
            UserDefaults.standard.set(strReptiles, forKey: "VRreptiles")
        }
        else if cell.btnLabAnimals.tag == 1 {
            strReptiles = "0"
            cell.btnLabAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnLabAnimals.tag = 0
            UserDefaults.standard.set(strReptiles, forKey: "VRreptiles")
        }
    }
    
    @objc func ExcoticBirdsClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnExcoticBirds.tag == 0 {
            strExcoticBirds = "5"
            cell.btnExcoticBirds.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnExcoticBirds.tag = 1
            UserDefaults.standard.set(strExcoticBirds, forKey: "VRexcoticbirds")
        }
        else if cell.btnExcoticBirds.tag == 1 {
            strExcoticBirds = "0"
            cell.btnExcoticBirds.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnExcoticBirds.tag = 0
            UserDefaults.standard.set(strExcoticBirds, forKey: "VRexcoticbirds")
        }
    }
    
    @objc func equineClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnExcoticAnimals.tag == 0 {
            strEquine = "6"
            cell.btnExcoticAnimals.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnExcoticAnimals.tag = 1
            UserDefaults.standard.set(strEquine, forKey: "VRequine")
        }
        else if cell.btnExcoticAnimals.tag == 1 {
            strEquine = "0"
            cell.btnExcoticAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnExcoticAnimals.tag = 0
            UserDefaults.standard.set(strEquine, forKey: "VRequine")
        }
    }
    
    @objc func FoodAnimalDiaryClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnFoodAnimalAndDiary.tag == 0 {
            strFoodAnimalDiary = "7"
            cell.btnFoodAnimalAndDiary.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnFoodAnimalAndDiary.tag = 1
            UserDefaults.standard.set(strFoodAnimalDiary, forKey: "VRfoodandanimaldiary")
        }
        else if cell.btnFoodAnimalAndDiary.tag == 1 {
            strFoodAnimalDiary = "0"
            cell.btnFoodAnimalAndDiary.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnFoodAnimalAndDiary.tag = 0
            UserDefaults.standard.set(strFoodAnimalDiary, forKey: "VRfoodandanimaldiary")
        }
    }
    
    @objc func OtherClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnOther.tag == 0 {
            strOther = "8"
            cell.btnOther.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnOther.tag = 1
            UserDefaults.standard.set(strOther, forKey: "VRother")
        }
        else if cell.btnOther.tag == 1 {
            strOther = "0"
            cell.btnOther.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnOther.tag = 0
            UserDefaults.standard.set(strOther, forKey: "VRother")
        }
    }
    
    /*
     self.strGrooming = "0"
     self.strOtherService = "0"
     self.strPetHotel = "0"
     self.strPetSetting = "0"
     self.strPetTranning = "0"
     self.strPetWalking = "0"
     */
    
    // second click
     @objc func groomingClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnGrooming.tag == 0 {
            strGrooming = "8"
            cell.btnGrooming.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnGrooming.tag = 1
            
        }
        else if cell.btnGrooming.tag == 1 {
            strGrooming = "0"
            cell.btnGrooming.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnGrooming.tag = 0
            
         }
    }
    
    @objc func otherServiceClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnOtherServices.tag == 0 {
            strOtherService = "13"
            cell.btnOtherServices.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnOtherServices.tag = 1
         }
        else if cell.btnCat.tag == 1 {
            strOtherService = "0"
            cell.btnOtherServices.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnOtherServices.tag = 0
         }
    }
    
    @objc func petHotelClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnPetHotel.tag == 0 {
            strPetHotel = "9"
            cell.btnPetHotel.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnPetHotel.tag = 1
         }
        else if cell.btnPetHotel.tag == 1 {
            strPetHotel = "0"
            cell.btnPetHotel.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnPetHotel.tag = 0
         }
    }
    
    @objc func petSettingAndClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnPetSettingAnd.tag == 0 {
            strPetSetting = "11"
            cell.btnPetSettingAnd.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnPetSettingAnd.tag = 1
         }
        else if cell.btnPetSettingAnd.tag == 1 {
            strPetSetting = "0"
            cell.btnPetSettingAnd.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnPetSettingAnd.tag = 0
         }
    }
    
    @objc func petTrainingClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnPetTraining.tag == 0 {
            strPetTranning = "12"
            cell.btnPetTraining.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnPetTraining.tag = 1
         }
        else if cell.btnPetTraining.tag == 1 {
            strPetTranning = "0"
            cell.btnPetTraining.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnPetTraining.tag = 0
         }
    }
    
    @objc func petWalkingClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        if cell.btnPetWalking.tag == 0 {
            strPetWalking = "10"
            cell.btnPetWalking.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnPetWalking.tag = 1
         }
        else if cell.btnPetWalking.tag == 1 {
            strPetWalking = "0"
            cell.btnPetWalking.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnPetWalking.tag = 0
         }
    }
    
    
}

extension VeterinarianTypesTwo: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VeterinarianTypesTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            as! VeterinarianTypesTableCell
        
        cell.backgroundColor = .clear
        
        cell.btnNext.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        
        return cell
    }

    @objc func nextClick() {
        /*print(strDog as Any)
        print(strCat as Any)
        print(strPoultry as Any)
        print(strReptiles as Any)
        print(strExcoticBirds as Any)
        print(strEquine as Any)
        print(strFoodAnimalDiary as Any)
        print(strOther as Any)*/
        
        
        let addOne = String(strDog)+","+String(strCat)+","+String(strPoultry)+","+String(strReptiles)
        let addTwo = String(strExcoticBirds)+","+String(strEquine)+","+String(strFoodAnimalDiary)+","+String(strOther)
        
        var addAllStrings = String(addOne)+","+String(addTwo)
        
        print(addAllStrings as Any)
        
        addAllStrings = addAllStrings.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        addAllStrings = addAllStrings.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        //print(addAllStrings as Any)
        
        // type of service
        
        /*var strGrooming:String!
        var strOtherService:String!
        var strPetHotel:String!
        var strPetSetting:String!
        var strPetTranning:String!
        var strPetWalking:String!*/
        
        let addThree = String(strGrooming)+","+String(strOtherService)+","+String(strPetHotel)
        let addFour = String(strPetSetting)+","+String(strPetTranning)+","+String(strPetWalking)
        
        var typeOfService = String(addThree)+","+String(addFour)
        
        typeOfService = typeOfService.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        typeOfService = typeOfService.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        
        print(addAllStrings)
        print(typeOfService)
        
        if addAllStrings == "0" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Please fill atleast one Type of Pet", dismissDelay: 1.5, completion:{})
        }
        else
        if typeOfService == "0" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Please fill atleast one Type of Services", dismissDelay: 1.5, completion:{})
        }
        else {
            self.veterianrianRegistrationThirdPage(strGetTypeOfPet: addAllStrings, strGetTypeOfService: typeOfService)
        }
        
        
        
    }
    
    @objc func veterianrianRegistrationThirdPage(strGetTypeOfPet:String,strGetTypeOfService:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTypesTableCell
        
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            //if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any] {
            parameters = [
                "action"            :   "petparentregistration",
                "userId"            :   String(myString),
                "UTYPE"             :   "3",
                "typeOfPets"        :   String(strGetTypeOfPet),
                "otherService"      :   String(cell.txtOther.text!),
                "TypeOfService"     :   String(strGetTypeOfService),
            ]
                
            //}
        }
                
        print("parameters-------\(String(describing: parameters))")
                   
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
               
            switch(response.result) {
            case .success(_):
                if let data = response.value {

                               
                    let JSON = data as! NSDictionary
                               //print(JSON)
                               
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                               
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SetYourAvailabilityTwoId")
                        self.navigationController?.pushViewController(push, animated: true)
                                
                    }
                    else {
                                   //self.indicator.stopAnimating()
                                   //self.enableService()
                        Utils.RiteVetIndicatorHide()
                    }
                               
                }

                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
                               //self.indicator.stopAnimating()
                               //self.enableService()
                    Utils.RiteVetIndicatorHide()
                               
                    let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
                               
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                               
                    alertController.addAction(okAction)
                               
                    self.present(alertController, animated: true, completion: nil)
                               
                    break
            }
        }
    
    }
    
    
    
    
    
    
    // second cell click
    
    
    
    // third
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*if indexPath.row == 0 {
            return 280
        }
        else
        if indexPath.row == 1 {
            return 280
        }
        else
        if indexPath.row == 2 {
            return 340
        }*/
        
        return 1000
        
    }
}

extension VeterinarianTypesTwo: UITableViewDelegate
{
    
}
