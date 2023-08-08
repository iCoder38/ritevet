//
//  VeterinarianTypes.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView
import CRNotifications



class VeterinarianTypes: UIViewController {

    let strDeSelectImage:String = "tickWhite"
    let strSelectImage:String = "tickGreen"
    
    let cellReuseIdentifier = "veterinarianTableCell"
    
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
    
    var btnOther:UIButton!
    var strOther:String!
    
    var txtPets:UITextField!
    var txtPets2:UITextField!
    
    /* SECOND */
    var btnGeneral:UIButton!
    var strGeneral:String!
    
    var btnWelness:UIButton!
    var strWelness:String!
    
    var btnImaging:UIButton!
    var strImaging:String!
    
    var btnDiagnosticLab:UIButton!
    var strDiagnosticLab:String!
    
    var btnDental:UIButton!
    var strDental:String!
    
    var btnBoarding:UIButton!
    var strBoarding:String!
    
    var btnOther2:UIButton!
    var strOther2:String!
    
    /* THIRD */
    var btnBehaviour:UIButton!
    var strBehaviour:String!
    
    var btnNeurology:UIButton!
    var strNeurology:String!
    
    var btnOncology:UIButton!
    var strOncology:String!
    
    var btnRadiology:UIButton!
    var strRadiology:String!
    
    var btnDermatalogy:UIButton!
    var strDermatalogy:String!
    
    var btnCardilogy:UIButton!
    var strCardilogy:String!
    
    var btnOphthalmology:UIButton!
    var strOphthalmology:String!
    
    var btnSurgery:UIButton!
    var strSurgery:String!
    
    // set str for all three cells
    
    
    
    
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "VETERINARIAN SERVICES"
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
         { njmn
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
                "UTYPE"     : "2"
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
                        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
                        
                        cell.btnDog.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnCat.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnPoultry.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnExcoticBirds.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnFoodAnimalAndDiary.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnExcoticAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnOther.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnLabAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)
                        
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
                                
                            } else { // Lab. Animal
                                
                                self.strEquine = "8"
                                cell.btnLabAnimals.tag = 1
                                cell.btnLabAnimals.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            }
                            
                        }
                        
                        
                        
                        /*
                         @IBOutlet weak var btnGeneral:UIButton!
                         @IBOutlet weak var btnWellness:UIButton!
                         @IBOutlet weak var btnImaging:UIButton!
                         @IBOutlet weak var btnDiagonsticLab:UIButton!
                         @IBOutlet weak var btnDental:UIButton!
                         @IBOutlet weak var btnBording:UIButton!
                         @IBOutlet weak var btnOther2:UIButton!
                         */
                        
                        /*
                         // second
                         self.strGeneral = "0"
                         self.strWelness = "0"
                         self.strImaging = "0"
                         self.strDiagnosticLab = "0"
                         self.strDental = "0"
                         self.strBoarding = "0"
                         self.strOther2 = "0"
                         */
                        
                        self.strGeneral = "0"
                        self.strWelness = "0"
                        self.strDental = "0"
                        self.strImaging = "0"
                        self.strBoarding = "0"
                        self.strDiagnosticLab = "0"
                        self.strOther2 = "0"
 
                        cell.btnGeneral.setImage(UIImage(named: strDeSelectImage), for: .normal) // 1
                        cell.btnWellness.setImage(UIImage(named: strDeSelectImage), for: .normal) // 2
                        cell.btnImaging.setImage(UIImage(named: strDeSelectImage), for: .normal) // 4
                        cell.btnDiagonsticLab.setImage(UIImage(named: strDeSelectImage), for: .normal) // 6
                        cell.btnDental.setImage(UIImage(named: strDeSelectImage), for: .normal) // 3
                        cell.btnBording.setImage(UIImage(named: strDeSelectImage), for: .normal) // 5
                        cell.btnOther2.setImage(UIImage(named: strDeSelectImage), for: .normal) // 7
                        
                        let array2 = (dict["TypeOfService"] as! String).components(separatedBy: ",")
                        print(array2 as Any)
                        
                        for index in 0..<array2.count {
                            
                            let item = array2[index]
                            print(item as Any)
                            
                            if item == "1" {
                                
                                self.strGeneral = "1"
                                cell.btnGeneral.tag = 1
                                cell.btnGeneral.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "2" {
                                
                                self.strWelness = "2"
                                cell.btnWellness.tag = 1
                                cell.btnWellness.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "3" {
                                
                                self.strDental = "3"
                                cell.btnDental.tag = 1
                                cell.btnDental.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "4" {
                                
                                self.strImaging = "4"
                                cell.btnImaging.tag = 1
                                cell.btnImaging.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "5" {
                                
                                self.strBoarding = "5"
                                cell.btnBording.tag = 1
                                cell.btnBording.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "6" {
                                
                                self.strDiagnosticLab = "6"
                                cell.btnDiagonsticLab.tag = 1
                                cell.btnDiagonsticLab.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else {
                                
                                self.strOther2 = "7"
                                cell.btnOther2.tag = 1
                                cell.btnOther2.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            }
                            
                        }
                        
                        
                        // third
                        /*
                         @IBOutlet weak var btnBehaviour:UIButton!
                         @IBOutlet weak var btnNeurology:UIButton!
                         @IBOutlet weak var btnOncology:UIButton!
                         @IBOutlet weak var btnRadiology:UIButton!
                         @IBOutlet weak var btnDermatology:UIButton!
                         @IBOutlet weak var btnCardiology:UIButton!
                         @IBOutlet weak var btnOphthalmology:UIButton!
                         @IBOutlet weak var btnSurgery:UIButton!
                         */
                        
                        /*
                         var strBehaviour:String!
                         var strNeurology:String!
                         var strOncology:String!
                         var strRadiology:String!
                         var strDermatalogy:String!
                         var strCardilogy:String!
                         var strOphthalmology:String!
                         var strSurgery:String!
                         */
                        
                        self.strBehaviour = "0"
                        self.strNeurology = "0"
                        self.strOncology = "0"
                        self.strRadiology = "0"
                        self.strDermatalogy = "0"
                        self.strCardilogy = "0"
                        self.strOphthalmology = "0"
                        self.strSurgery = "0"
                        
                        cell.btnBehaviour.setImage(UIImage(named: strDeSelectImage), for: .normal) // 1
                        cell.btnNeurology.setImage(UIImage(named: strDeSelectImage), for: .normal) // 2
                        cell.btnRadiology.setImage(UIImage(named: strDeSelectImage), for: .normal) // 4
                        cell.btnCardiology.setImage(UIImage(named: strDeSelectImage), for: .normal) // 6
                        cell.btnOncology.setImage(UIImage(named: strDeSelectImage), for: .normal) // 3
                        cell.btnDermatology.setImage(UIImage(named: strDeSelectImage), for: .normal) // 5
                        cell.btnOphthalmology.setImage(UIImage(named: strDeSelectImage), for: .normal) // 7
                        cell.btnSurgery.setImage(UIImage(named: strDeSelectImage), for: .normal) // 8
                        
                        let array3 = (dict["Specialization"] as! String).components(separatedBy: ",")
                        print(array3 as Any)
                        
                        for index in 0..<array3.count {
                            
                            let item = array3[index]
                            print(item as Any)
                            
                            if item == "1" {
                                
                                self.strBehaviour = "1"
                                cell.btnBehaviour.tag = 1
                                cell.btnBehaviour.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "2" {
                                
                                self.strNeurology = "2"
                                cell.btnNeurology.tag = 1
                                cell.btnNeurology.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "3" {
                                
                                self.strOncology = "3"
                                cell.btnOncology.tag = 1
                                cell.btnOncology.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "4" {
                                
                                self.strRadiology = "4"
                                cell.btnRadiology.tag = 1
                                cell.btnRadiology.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "5" {
                                
                                self.strDermatalogy = "5"
                                cell.btnDermatology.tag = 1
                                cell.btnDermatology.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "6" {
                                
                                self.strCardilogy = "6"
                                cell.btnCardiology.tag = 1
                                cell.btnCardiology.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else if item == "7" {
                                
                                self.strOphthalmology = "7"
                                cell.btnOphthalmology.tag = 1
                                cell.btnOphthalmology.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            } else {
                                
                                self.strSurgery = "8"
                                cell.btnSurgery.tag = 1
                                cell.btnSurgery.setImage(UIImage(named: strSelectImage), for: .normal)
                                
                            }
                            
                        }
                        
                        
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
                        cell.btnGeneral.addTarget(self, action: #selector(generalClick), for: .touchUpInside)
                        cell.btnWellness.addTarget(self, action: #selector(wellNessClick), for: .touchUpInside)
                        cell.btnImaging.addTarget(self, action: #selector(btnImagingClick), for: .touchUpInside)
                        cell.btnDiagonsticLab.addTarget(self, action: #selector(btnDiagnosticLabClick), for: .touchUpInside)
                        cell.btnDental.addTarget(self, action: #selector(DentalClick), for: .touchUpInside)
                        cell.btnBording.addTarget(self, action: #selector(bordingClick), for: .touchUpInside)
                        cell.btnOther2.addTarget(self, action: #selector(btnOther2Click), for: .touchUpInside)
                        
                        
                        
                        // third
                        cell.btnBehaviour.addTarget(self, action: #selector(BehaviourClick), for: .touchUpInside)
                        cell.btnNeurology.addTarget(self, action: #selector(NeurologyClick), for: .touchUpInside)
                        cell.btnOncology.addTarget(self, action: #selector(OncologyClick), for: .touchUpInside)
                        cell.btnRadiology.addTarget(self, action: #selector(RadiologyClick), for: .touchUpInside)
                        cell.btnDermatology.addTarget(self, action: #selector(DermatalogyClick), for: .touchUpInside)
                        cell.btnCardiology.addTarget(self, action: #selector(CardilogyClick), for: .touchUpInside)
                        cell.btnOphthalmology.addTarget(self, action: #selector(OphthalmologyClick), for: .touchUpInside)
                        cell.btnSurgery.addTarget(self, action: #selector(SurgeryClick), for: .touchUpInside)
                        
                        
                        
                        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
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
    
    
    
    
    // second
    @objc func generalClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnGeneral.tag == 0 {
            strGeneral = "1"
            cell.btnGeneral.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnGeneral.tag = 1
            UserDefaults.standard.set(strGeneral, forKey: "VRgeneral")
        }
        else if cell.btnGeneral.tag == 1 {
            strGeneral = "0"
            cell.btnGeneral.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnGeneral.tag = 0
            UserDefaults.standard.set(strGeneral, forKey: "VRgeneral")
        }
        
    }
    
    @objc func wellNessClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnWellness.tag == 0 {
            strWelness = "2"
            cell.btnWellness.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnWellness.tag = 1
            
            UserDefaults.standard.set(strWelness, forKey: "VRwellness")
        }
        else if cell.btnWellness.tag == 1 {
            strWelness = "0"
            cell.btnWellness.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnWellness.tag = 0
            
            UserDefaults.standard.set(strWelness, forKey: "VRwellness")
        }
    }
    
    @objc func btnImagingClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnImaging.tag == 0 {
            strImaging = "4"
            cell.btnImaging.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnImaging.tag = 1
            
            UserDefaults.standard.set(strImaging, forKey: "VRimaging")
        }
        else if cell.btnImaging.tag == 1 {
            strImaging = "0"
            cell.btnImaging.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnImaging.tag = 0
            
            UserDefaults.standard.set(strImaging, forKey: "VRimaging")
        }
    }
    
    @objc func btnDiagnosticLabClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnDiagonsticLab.tag == 0 {
            strDiagnosticLab = "6"
            cell.btnDiagonsticLab.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnDiagonsticLab.tag = 1
            
            UserDefaults.standard.set(strDiagnosticLab, forKey: "VRdiagnostic")
        }
        else if cell.btnDiagonsticLab.tag == 1 {
            strDiagnosticLab = "0"
            cell.btnDiagonsticLab.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnDiagonsticLab.tag = 0
            
            UserDefaults.standard.set(strDiagnosticLab, forKey: "VRdiagnostic")
        }
    }
    
    @objc func DentalClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnDental.tag == 0 {
            strDental = "3"
            cell.btnDental.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnDental.tag = 1
            
            UserDefaults.standard.set(strDental, forKey: "VRdental")
        }
        else if cell.btnDental.tag == 1 {
            strDental = "0"
            cell.btnDental.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnDental.tag = 0
            
            UserDefaults.standard.set(strDental, forKey: "VRdental")
        }
    }
    
    @objc func bordingClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnBording.tag == 0 {
            strBoarding = "5"
            cell.btnBording.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnBording.tag = 1
            
            UserDefaults.standard.set(strBoarding, forKey: "VRboarding")
        }
        else if cell.btnBording.tag == 1 {
            strBoarding = "0"
            cell.btnBording.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnBording.tag = 0
            
            UserDefaults.standard.set(strBoarding, forKey: "VRboarding")
        }
    }
    
    @objc func btnOther2Click() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnOther2.tag == 0 {
            strOther2 = "7"
            cell.btnOther2.setImage(UIImage(named: strSelectImage), for: .normal)
            cell.btnOther2.tag = 1
            
            UserDefaults.standard.set(strOther2, forKey: "VRother2")
        }
        else if cell.btnOther2.tag == 1 {
            strOther2 = "0"
            cell.btnOther2.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnOther2.tag = 0
            
            UserDefaults.standard.set(strOther2, forKey: "VRother2")
        }
    }
    
    
    
    // third
    @objc func BehaviourClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnBehaviour.tag == 0 {
            strBehaviour = "1"
            cell.btnBehaviour.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnBehaviour.tag = 1
            
            UserDefaults.standard.set(strBehaviour, forKey: "VRbehaviour")
        }
        else if btnBehaviour.tag == 1 {
            strBehaviour = "0"
            cell.btnBehaviour.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnBehaviour.tag = 0
            
            UserDefaults.standard.set(strBehaviour, forKey: "VRbehaviour")
        }
    }
    
    @objc func NeurologyClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnNeurology.tag == 0 {
            strNeurology = "2"
            cell.btnNeurology.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnNeurology.tag = 1
            
            UserDefaults.standard.set(strNeurology, forKey: "VRneurology")
        }
        else if cell.btnNeurology.tag == 1 {
            strNeurology = "0"
            cell.btnNeurology.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnNeurology.tag = 0
            
            UserDefaults.standard.set(strNeurology, forKey: "VRneurology")
        }
    }
    
    @objc func OncologyClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnOncology.tag == 0 {
            strOncology = "3"
            cell.btnOncology.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnOncology.tag = 1
            
            UserDefaults.standard.set(strOncology, forKey: "VRoncology")
        }
        else if cell.btnOncology.tag == 1 {
            strOncology = "0"
            cell.btnOncology.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnOncology.tag = 0
            
            UserDefaults.standard.set(strOncology, forKey: "VRoncology")
        }
    }
    
    
    @objc func RadiologyClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnRadiology.tag == 0 {
            strRadiology = "4"
            cell.btnRadiology.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnRadiology.tag = 1
            
            UserDefaults.standard.set(strRadiology, forKey: "VRradiology")
        }
        else if cell.btnRadiology.tag == 1 {
            strRadiology = "0"
            cell.btnRadiology.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnRadiology.tag = 0
            
            UserDefaults.standard.set(strRadiology, forKey: "VRradiology")
        }
    }
    
    @objc func DermatalogyClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnDermatology.tag == 0 {
            strDermatalogy = "5"
            cell.btnDermatology.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnDermatology.tag = 1
            
            UserDefaults.standard.set(strDermatalogy, forKey: "VRdermatalogy")
        }
        else if cell.btnDermatology.tag == 1 {
            strDermatalogy = "0"
            cell.btnDermatology.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnDermatology.tag = 0
            
            UserDefaults.standard.set(strDermatalogy, forKey: "VRdermatalogy")
        }
    }
    
    @objc func CardilogyClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnCardiology.tag == 0 {
            strCardilogy = "6"
            cell.btnCardiology.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnCardiology.tag = 1
            
            UserDefaults.standard.set(strCardilogy, forKey: "VRcardiology")
        }
        else if cell.btnCardiology.tag == 1 {
            strCardilogy = "0"
            cell.btnCardiology.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnCardiology.tag = 0
            
            UserDefaults.standard.set(strCardilogy, forKey: "VRcardiology")
        }
    }
    
    @objc func OphthalmologyClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnOphthalmology.tag == 0 {
            strOphthalmology = "7"
            cell.btnOphthalmology.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnOphthalmology.tag = 1
            
            UserDefaults.standard.set(strOphthalmology, forKey: "VRophthalmogy")
        }
        else if cell.btnOphthalmology.tag == 1 {
            strOphthalmology = "0"
            cell.btnOphthalmology.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnOphthalmology.tag = 0
            
            UserDefaults.standard.set(strOphthalmology, forKey: "VRophthalmogy")
        }
    }
    
    @objc func SurgeryClick() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        if cell.btnSurgery.tag == 0 {
            strSurgery = "8"
            cell.btnSurgery.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnSurgery.tag = 1
            
            UserDefaults.standard.set(strSurgery, forKey: "VRsurgery")
        }
        else if cell.btnSurgery.tag == 1 {
            strSurgery = "0"
            cell.btnSurgery.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnSurgery.tag = 0
            
            UserDefaults.standard.set(strSurgery, forKey: "VRsurgery")
        }
    }
    
}

extension VeterinarianTypes: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VeterinarianTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            as! VeterinarianTableCell
        
        cell.backgroundColor = .clear
        
        cell.btnNext.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        
        return cell
    }

    @objc func nextClick() {
        print(strDog as Any)
        print(strCat as Any)
        print(strPoultry as Any)
        print(strReptiles as Any)
        print(strExcoticBirds as Any)
        print(strEquine as Any)
        print(strFoodAnimalDiary as Any)
        print(strOther as Any)
        
        
        let addOne = String(strDog)+","+String(strCat)+","+String(strPoultry)+","+String(strReptiles)
        let addTwo = String(strExcoticBirds)+","+String(strEquine)+","+String(strFoodAnimalDiary)+","+String(strOther)
        
        var addAllStrings = String(addOne)+","+String(addTwo)
        
        //print(addAllStrings as Any)
        
        addAllStrings = addAllStrings.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        addAllStrings = addAllStrings.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        //print(addAllStrings as Any)
        
        // type of service
        
        print(strGeneral as Any)
        print(strWelness as Any)
        print(strImaging as Any)
        print(strDiagnosticLab as Any)
        print()
        let addThree = String(strGeneral)+","+String(strWelness)+","+String(strImaging)+","+String(strDiagnosticLab)
        let addFour = String(strDental)+","+String(strBoarding)+","+String(strOther2)
        
        var typeOfService = String(addThree)+","+String(addFour)
        
        typeOfService = typeOfService.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        typeOfService = typeOfService.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        
        
        let addFive = String(strBehaviour)+","+String(strNeurology)+","+String(strOncology)+","+String(strRadiology)
        let addSix = String(strDermatalogy)+","+String(strCardilogy)+","+String(strOphthalmology)+","+String(strSurgery)
        
        var specialization = String(addFive)+","+String(addSix)
        
        specialization = specialization.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        specialization = specialization.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        
        print(addAllStrings)
        print(typeOfService)
        print(specialization)
        
        if addAllStrings == "0" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Please fill atleast one Type of Pet", dismissDelay: 1.5, completion:{})
        }
        else
        if typeOfService == "0" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Please fill atleast one Type of Services", dismissDelay: 1.5, completion:{})
        }
        else
        if specialization == "0" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Please fill atleast one Specialization", dismissDelay: 1.5, completion:{})
        }
        else {
            self.veterianrianRegistrationThirdPage(strGetTypeOfPet: addAllStrings, strGetTypeOfService: typeOfService, strSpecialization: specialization)
        }
        
        
        
    }
    
    @objc func veterianrianRegistrationThirdPage(strGetTypeOfPet:String,strGetTypeOfService:String,strSpecialization:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VeterinarianTableCell
        
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            //if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any] {
            parameters = [
                "action"          :   "petparentregistration",
                "userId"          :   String(myString),
                "UTYPE"           :   "2",
                "typeOfPets"       :  String(strGetTypeOfPet),
                "otherPet"         :  String(cell.txtOther.text!),
                "TypeOfService"     : String(strGetTypeOfService),
                "otherService"      : String(cell.txtOther2.text!),
                "Specialization"     : String(strSpecialization)
                       
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
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VeterinarianBiographyId") as? VeterinarianBiography
                        self.navigationController?.pushViewController(push!, animated: true)
                                
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
        
        return 1200
        
    }
}

extension VeterinarianTypes: UITableViewDelegate
{
    
}
