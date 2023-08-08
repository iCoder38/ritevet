//
//  PetAndParentsInformation.swift
//  RiteVet
//
//  Created by Apple  on 26/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CRNotifications

class PetAndParentsInformation: UIViewController,UITextFieldDelegate {

    let indicator = UIActivityIndicatorView()
    
    var strLoginUserId:String!
    
    var strDog:String!
    var strCat:String!
    var strPoultry:String!
    var strReptiles:String!
    var strExoticBirds:String!
    var strFoodAnimalAndDiary:String!
    var strLabAnimals:String!
    var strOthers:String!
    
    var strReloadTime:String!
    
    var arrListOfPetsDataFromServer:NSMutableArray = []
    var arrListOfPetsDataFromServer2:NSMutableArray = []
    var arrListOfPetsDataFromServer3:NSMutableArray = []
    
    var arrListOfIdSendToServer:NSMutableArray = []
    
    var addInitialMutable:NSMutableArray = []
    var arrListOfAllAddedPetsIndex:NSMutableArray! = []
    
    var arrArray:NSArray!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "PET & PARENTS INFORMATION"
            lblNavigationTitle.textColor = .white
        }
    }
    
    /*@IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtExplainAboutTheOtherAnimal:UITextField!
    
    @IBOutlet weak var btnNext:UIButton!*/
    
    @IBOutlet weak var btnDog:UIButton!
    @IBOutlet weak var btnCat:UIButton!
    @IBOutlet weak var btnPoultry:UIButton!
    @IBOutlet weak var btnReptiles:UIButton!
    @IBOutlet weak var btnExoticBirds:UIButton!
    @IBOutlet weak var btnFoodAnimalAndDiary:UIButton!
    @IBOutlet weak var btnLabAnimals:UIButton!
    @IBOutlet weak var btnOthers:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // self.tbleView.delegate = self
            // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.tbleView.isHidden = true
        
        self.strReloadTime = "0"
        self.listofAllPets()
        //self.welcomeWB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextClickMethod() {
        /*let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! PetAndParentsInformationTableCell
        
        var addAllStrings = String(strDog)+","+String(strCat)+","+String(strPoultry)+","+String(strReptiles)+","+String(strExoticBirds)+","+String(strLabAnimals)
        addAllStrings = addAllStrings.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        addAllStrings = addAllStrings.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        if cell.txtFirstName.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "First Name")
        }
        else if cell.txtLastName.text == "" {
            self.fieldShouldNotBeEmpty(textFieldName: "Last Name")
        }
        else if addAllStrings == "0"
        {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Hurray!", message:"Please select atleast on Type of Pet", dismissDelay: 1.5, completion:{})
        }
        else
        {
        let someDict:[String:String] = [
            "firstname":String(cell.txtFirstName.text!),
            "lastname":String(cell.txtLastName.text!),
            "typeofpets":String(addAllStrings),
            "explainaboutotheranimal":String(cell.txtExplainAboutTheOtherAnimal.text!)
        ]

            
        //print( someDict["explainaboutotheranimal"] as Any )
        
            /*
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddCreditCardPaymentId") as? AddCreditCardPayment
        push!.getDictValueOfPetAndParents = someDict
         self.navigationController?.pushViewController(push!, animated: true)
             */
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddBankInfoId") as? AddBankInfo
            push!.getDictValueOfFirstPage = someDict
            self.navigationController?.pushViewController(push!, animated: true)
        }*/
    }
    
    @objc func fieldShouldNotBeEmpty(textFieldName:String) {
        CRNotifications.showNotification(type: CRNotifications.error, title: "Hurray!", message:textFieldName+" Should not be empty", dismissDelay: 1.5, completion:{})
    }
    
    //MARK:- BUTTON TAGS (DOG) -
    @objc func dogClickMethod() {
        if btnDog.tag == 0 {
            btnDog.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnDog.tag = 1
            
            strDog = "1"
        }
        else if btnDog.tag == 1 {
            btnDog.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnDog.tag = 0
            
            strDog = "0"
        }
    }
    
    @objc func CatClickMethod() {
        if btnCat.tag == 0 {
            btnCat.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnCat.tag = 1
            
            strCat = "2"
        }
        else if btnCat.tag == 1 {
            btnCat.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnCat.tag = 0
            
            strCat = "0"
        }
    }
    
    @objc func PoultryClickMethod() {
        if btnPoultry.tag == 0 {
            btnPoultry.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnPoultry.tag = 1
            
            strPoultry = "3"
        }
        else if btnPoultry.tag == 1 {
            btnPoultry.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnPoultry.tag = 0
            
            strPoultry = "0"
            
        }
    }
    
    @objc func ReptilesClickMethod() {
        if btnReptiles.tag == 0 {
            btnReptiles.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnReptiles.tag = 1
            
            strReptiles = "4"
        }
        else if btnReptiles.tag == 1 {
            btnReptiles.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnReptiles.tag = 0
            
            strReptiles = "0"
        }
    }
    
    @objc func ExoticBirdsClickMethod() {
        if btnExoticBirds.tag == 0 {
            btnExoticBirds.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnExoticBirds.tag = 1
            
            strExoticBirds = "5"
        }
        else if btnExoticBirds.tag == 1 {
            btnExoticBirds.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnExoticBirds.tag = 0
            
            strExoticBirds = "0"
            
        }
    }
    
    @objc func FoodAnimalAndDiaryClickMethod() {
        if btnFoodAnimalAndDiary.tag == 0 {
            btnFoodAnimalAndDiary.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnFoodAnimalAndDiary.tag = 1
            
            strFoodAnimalAndDiary = "6"
        }
        else if btnFoodAnimalAndDiary.tag == 1 {
            btnFoodAnimalAndDiary.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnFoodAnimalAndDiary.tag = 0
            
            strFoodAnimalAndDiary = "0"
        }
    }
    
    @objc func LabAnimalsClickMethod() {
        if btnLabAnimals.tag == 0 {
            btnLabAnimals.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnLabAnimals.tag = 1
            
            strLabAnimals = "7"
        }
        else if btnLabAnimals.tag == 1 {
            btnLabAnimals.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnLabAnimals.tag = 0
            
            strLabAnimals = "0"
        }
    }
    
    @objc func othersClickMethod() {
        if btnOthers.tag == 0 {
            btnOthers.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnOthers.tag = 1
            
            strOthers = "8"
        }
        else if btnOthers.tag == 1 {
            btnOthers.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnOthers.tag = 0
            
            strOthers = "0"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    /*
     action: petparentregistration
     userId:
     UTYPE:
     VFirstName:
     VLastName:
     typeOfPets:
     otherPet:
     cardNo:
     expMon:
     expYear:
     CVV:
     VBusinessAddress:
     Vcity:
     stateId:
     VZipcode:
     ACName:
     BankName:
     AccountNo:
     RoutingNo:
     */
    
    
    @objc func savePetAndParentsInformation() {
        let someDict:[String:String] = [
            "1":"One",
            "2":"Two",
            "3":"Three"
        ]
        
        print( someDict["1"] as Any )
        print( someDict["2"] as Any )
        print( someDict["3"] as Any )
        
    }
    
    @objc func listofAllPets() {
        
        
            // indicator.startAnimating()
            Utils.RiteVetIndicatorShow()
               
            let urlString = BASE_URL_KREASE
                   
            var parameters:Dictionary<AnyHashable, Any>!
               
            // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                // print(person as Any)
                
                // let x : Int = (person["userId"] as! Int)
                // let myString = String(x)
                
                parameters = [
                    "action"    : "typeofpet",
                    
                ]
            // }
                    
            print("parameters-------\(String(describing: parameters))")
                       
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                   
                switch(response.result) {
                case .success(_):
                    if let data = response.value {

                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                                   
                                   //var strSuccessAlert : String!
                                   //strSuccessAlert = JSON["msg"]as Any as? String
                                   
                        if strSuccess == "success" {
                            // Utils.RiteVetIndicatorHide()
                            
                            // var dict: Dictionary<AnyHashable, Any>
                            // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfPetsDataFromServer2.addObjects(from: ar as! [Any])
                            
                            // print(self.arrListOfPetsDataFromServer)
                            
                            for index in 0..<self.arrListOfPetsDataFromServer2.count {
                                
                                let item = self.arrListOfPetsDataFromServer2[index] as? [String:Any]
                                
                                let x : Int = (item!["id"] as! Int)
                                let myString = String(x)
                                
                                let myDictionary: [String:String] = [
                                    
                                    "id":String(myString),
                                    "name":(item!["name"] as! String),
                                    "status":String("no")
                                    
                                ]
                                
                                var res = [[String: String]]()
                                res.append(myDictionary)
                                
                                // self.addInitialMutable.addObjects(from: res)
                                
                                self.arrListOfPetsDataFromServer.addObjects(from: res)
                            }
                            
                            print(self.arrListOfPetsDataFromServer as Any)
                            
                            
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            // self.typesOfPetFetchFromServer(dictGetAllData: dict as NSDictionary)
                            
                            self.serverData()
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
    
    @objc func serverData() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! PetAndParentsInformationTableCell
        
        cell.txtFirstName.delegate = self
        // cell.txtLastName.delegate = self
        cell.txtExplainAboutTheOtherAnimal.delegate = self
        
        /*indicator.style = .large
        indicator.color = .orange
        indicator.center = self.view.center
        self.view.addSubview(indicator)*/
        
        
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: cell.txtFirstName, placeHolder: "First Name", cornerRadius: 20, color: .white)
         Utils.textFieldDR(text: cell.txtLastName, placeHolder: "Last Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtExplainAboutTheOtherAnimal, placeHolder: "Explain about the other animal", cornerRadius: 20, color: .white)
        
        /****** BUTTON *********/
        Utils.buttonDR(button: cell.btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        // cell.btnNext.addTarget(self, action: #selector(nextClickMethod), for: .touchUpInside)
        
        cell.btnNext.setTitle("Submit", for: .normal)
        cell.btnNext.addTarget(self, action: #selector(petParentRegistrationWB), for: .touchUpInside)
        
        /*btnDog.tag = 0
        btnCat.tag = 0
        btnPoultry.tag = 0
        btnReptiles.tag = 0
        btnExoticBirds.tag = 0
        btnFoodAnimalAndDiary.tag = 0
        btnLabAnimals.tag = 0
        btnOthers.tag = 0
        
        btnDog.addTarget(self, action: #selector(dogClickMethod), for: .touchUpInside)
        btnCat.addTarget(self, action: #selector(CatClickMethod), for: .touchUpInside)
        btnPoultry.addTarget(self, action: #selector(PoultryClickMethod), for: .touchUpInside)
        btnReptiles.addTarget(self, action: #selector(ReptilesClickMethod), for: .touchUpInside)
        btnExoticBirds.addTarget(self, action: #selector(ExoticBirdsClickMethod), for: .touchUpInside)
        btnFoodAnimalAndDiary.addTarget(self, action: #selector(FoodAnimalAndDiaryClickMethod), for: .touchUpInside)
        btnLabAnimals.addTarget(self, action: #selector(LabAnimalsClickMethod), for: .touchUpInside)
        btnOthers.addTarget(self, action: #selector(othersClickMethod), for: .touchUpInside)*/
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            /*
             ["VBusinessAddress": , "typeOfPets": , "FixedTraditional": , "VLicenseNo": , "Freelance": , "VAstate": , "digonasticLab": , "stateName": Andaman and Nicobar Islands, "socialType": Facebook, "AccountNo": , "role": Android, "BImage": , "zipCode": , "RoutingNo": , "VPhone": , "VLastName": , "VBusinessName": , "firebaseId": , "countryName": Afghanistan, "VBSuite": , "device": , "mobileClicnic": , "ACName": , "TypeOfService": , "other": , "BankName": , "deviceToken": , "fullName": Satish, "biography": , "VState": , "VEmail": , "contactNumber": 6446646464, "socialId": , "Specialization": , "Vcity": , "VFirstName": , "userId": 37, "city": noida se6, "lastName": , "image": , "estimatePrice": , "VTaxID": , "YearInBusiness": , "categoryId": , "address": address noida, "Imaging": , "TotalCartProduct": 2, "VZipcode": , "email": sss@gmail.com]
             */
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            strLoginUserId = myString
            
            strLabAnimals = "0"
            strDog = "0"
            strCat = "0"
            strPoultry = "0"
            strReptiles = "0"
            strExoticBirds = "0"
            strFoodAnimalAndDiary = "0"
            strOthers = "0"
            //self.savePetAndParentsInformation()
            
            
        }
        else {
            print("something went wrong")
        }
        
        self.welcomeWB()
    }
    
    func welcomeWB() {
        // indicator.startAnimating()
        // Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "returnprofile",
                "userId"    : String(myString),
                "UTYPE"     : "1"
            ]
        }
                
        print("parameters-------\(String(describing: parameters))")
                   
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
               
            switch(response.result) {
            case .success(_):
                if let data = response.value {

                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                               
                               //var strSuccessAlert : String!
                               //strSuccessAlert = JSON["msg"]as Any as? String
                               
                    if strSuccess == "success" {
                        // Utils.RiteVetIndicatorHide()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        /*var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfPetsDataFromServer.addObjects(from: ar as! [Any])*/
                        
                        // print(self.arrListOfPetsDataFromServer)
                        
                        self.typesOfPetFetchFromServer(dictGetAllData: dict as NSDictionary)
                        
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
    
    
    
    @objc func typesOfPetFetchFromServer(dictGetAllData:NSDictionary) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! PetAndParentsInformationTableCell
        
        // print(dictGetAllData as Any)
        
        // VFirstName = one;
        // VLastName = two2;
        
        cell.txtFirstName.text  = (dictGetAllData["VFirstName"] as! String)
        cell.txtLastName.text   = (dictGetAllData["VLastName"] as! String)
        cell.txtExplainAboutTheOtherAnimal.text = (dictGetAllData["otherPet"] as! String)
        
        var strId1:String!
        var strId2:String!
        
        let array = (dictGetAllData["typeOfPets"] as! String).components(separatedBy: ",")
        // print(array)
        
        for index in 0..<array.count {
            strId1 = array[index]
            // print(strId1 as Any)
            
            for index2 in 0..<self.arrListOfPetsDataFromServer.count {
                // print(index2 as Any)
                
                let item2 = self.arrListOfPetsDataFromServer[index2] as? [String:Any]
                // print(item2 as Any)
                
                if item2 == nil {
                    
                    print("i am nil")
                    
                } else {
                  
                    strId2 = (item2!["id"] as! String)
                    
                    if strId2 == strId1 {
                        print("matched")
                        
                        self.arrListOfPetsDataFromServer.removeObject(at: index2)
                        
                        let myDictionary: [String:String] = [
                            
                            "id":item2!["id"] as! String,
                            "name":item2!["name"] as! String,
                            "status":"yes"
                            
                        ]
                       
                        self.arrListOfPetsDataFromServer.insert(myDictionary, at: index2)
                        
                    } else {
                        print("not matched")
                    }
                }
            }
        }
        
        let set = NSSet(array: self.arrListOfPetsDataFromServer as! [Any])
        self.arrListOfPetsDataFromServer.removeAllObjects()
        
        self.strReloadTime = "1"
        self.arrListOfPetsDataFromServer.addObjects(from: set.allObjects)
        
        Utils.RiteVetIndicatorHide()
        self.tbleView.isHidden = false
        self.tbleView.reloadData()
        
    }
   
    @objc func petParentRegistrationWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! PetAndParentsInformationTableCell
        
        // indicator.startAnimating()
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        print(self.arrListOfPetsDataFromServer as Any)
        
        for index in 0..<self.arrListOfPetsDataFromServer.count {
        
            let item = self.arrListOfPetsDataFromServer[index] as? [String:Any]
            print(item as Any)
            
            if item!["status"] as! String == "yes" {
                self.arrListOfIdSendToServer.add(item!["id"] as! String)
            } else {
                
            }
            
        }
        
        // print(self.arrListOfIdSendToServer as Any)
        
        let array: [String] = self.arrListOfIdSendToServer.copy() as! [String]
        
        let stringRepresentation = array.joined(separator: ",")
        // print(stringRepresentation as Any)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"        : "petparentregistration",
                "userId"        : String(myString),
                "UTYPE"         : "1",
                "VFirstName"    : String(cell.txtFirstName.text!),
                "VLastName"     : String(cell.txtLastName.text!),
                "typeOfPets"     : String(stringRepresentation),
                "otherPet"      : String(cell.txtExplainAboutTheOtherAnimal.text!),
            ]
        }
                
        print("parameters-------\(String(describing: parameters))")
                   
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
               
            switch(response.result) {
            case .success(_):
                if let data = response.value {

                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                               
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let alert = UIAlertController(title: strSuccess, message: String(strSuccess2),preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                            
                            // self.typesOfPetFetchFromServer(dictGetAllData: dict as NSDictionary)
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                                /*var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfDashboardItems.addObjects(from: ar as! [Any])*/
                             
                                
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
}

extension PetAndParentsInformation: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if let cell = cell as? PetAndParentsInformationTableCell {

            cell.clView.dataSource = self
            cell.clView.delegate = self
            cell.clView.tag = indexPath.section
            cell.clView.reloadData()

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PetAndParentsInformationTableCell = tableView.dequeueReusableCell(withIdentifier: "petAndParentsInformationTableCell") as! PetAndParentsInformationTableCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            cell.txtFirstName.text = (person["fullName"] as! String)
            cell.txtLastName.text = (person["lastName"] as! String)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
       
        cell.backgroundColor = .clear
       
        return cell
        
    }
    
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
}

extension PetAndParentsInformation: UITableViewDelegate {
    
}


// MARK:- COLLECTION VIEW -
extension PetAndParentsInformation: UICollectionViewDelegate {
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /*let index = collectionView.tag
        let item = self.arrListOfAllMyOrders[index] as? [String:Any]
        var ar : NSArray!
        ar = (item!["data"] as! Array<Any>) as NSArray
        return ar.count*/
        
        // let index = collectionView.tag
        // print(index as Any)
        return self.arrListOfPetsDataFromServer.count
        
        /*if index == 0 {
            return self.arrListOfAllPhotos.count
        } else {
            return self.arrListOfAllPhotographers.count
        }*/
        
    }
    
    //Write Delegate Code Here
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "petAndParentsCollectionCell", for: indexPath as IndexPath) as! PetAndParentsCollectionCell
           
        /*
         SubCat =             (
         );
         id = 1;
         image = "";
         name = "CBD OIL";
         */
        // self.addInitialMutable
        // MARK:- CELL CLASS -
        cell.layer.cornerRadius = 30
        cell.clipsToBounds = true
        cell.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        
        // let index = collectionView.tag
        // print(index as Any)
        
        // print(self.addInitialMutable as Any)
        
        let item = self.arrListOfPetsDataFromServer[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        cell.lblTitle.text = (item!["name"] as! String)
        
        if item!["status"] as! String == "yes" {
            
            cell.layer.borderColor = UIColor.white.cgColor // UIColor.clear.cgColor
            cell.layer.borderWidth = 0.6
            cell.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            cell.lblTitle.textColor = .white
            
        } else {
            
            cell.layer.borderColor = NAVIGATION_BACKGROUND_COLOR.cgColor // UIColor.clear.cgColor
            cell.layer.borderWidth = 0.6
            cell.backgroundColor = .clear
            cell.lblTitle.textColor = .black
            
        }
        
        return cell
    }
}

extension PetAndParentsInformation: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
        
        let index = collectionView.tag
        print(index as Any)
        
        
        
        // print(self.arrListOfPetsDataFromServer[indexPath.row] as Any)
        
        let item = self.arrListOfPetsDataFromServer[indexPath.row] as? [String:Any]
        print(item as Any)
        
        if item!["status"] as! String == "no" {
            
            self.arrListOfPetsDataFromServer.removeObject(at: indexPath.row)
            
            let myDictionary: [String:String] = [
                
                "id":item!["id"] as! String,
                "name":item!["name"] as! String,
                "status":"yes"
                
            ]
           
            self.arrListOfPetsDataFromServer.insert(myDictionary, at: indexPath.row)
            
        } else {
        
            self.arrListOfPetsDataFromServer.removeObject(at: indexPath.row)
            
            let myDictionary: [String:String] = [
                
                "id":item!["id"] as! String,
                "name":item!["name"] as! String,
                "status":"no"
                
            ]
           
            self.arrListOfPetsDataFromServer.insert(myDictionary, at: indexPath.row)
            
        }
        
        // print(self.arrListOfPetsDataFromServer as Any)
        
        self.tbleView.reloadData()
        
        
    }
    
}

extension PetAndParentsInformation: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
                
        // let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)
        
        // print(indexPath.row)
        
        /*if result.height == 480 {
            sizes = CGSize(width: 200, height: 272)
        }
        else if result.height == 568 {
            sizes = CGSize(width: 200, height: 272)
        }
        else if result.height == 667.000000 // 8
        {
            sizes = CGSize(width: 200, height: 272)
        }
        else if result.height == 736.000000 // 8 plus
        {
            sizes = CGSize(width: 200, height: 272)
        }
        else if result.height == 812.000000 // 11 pro
        {
            sizes = CGSize(width: 200, height: 272)
        }
        else if result.height == 896.000000 // 11 , 11 pro max
        {
            sizes = CGSize(width: 200, height: 272)
        }
        else
        {*/
            sizes = CGSize(width: 160, height: 60)
        // }
        
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let result = UIScreen.main.bounds.size
        if result.height == 667.000000 { // 8
            return 2
        } else if result.height == 812.000000 { // 11 pro
            return 4
        } else {
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // var sizes: CGSize
        
        /*let result = UIScreen.main.bounds.size
        if result.height == 667.000000 { // 8
            return UIEdgeInsets(top: 20, left: 4, bottom: 10, right: 4)
        } else if result.height == 736.000000 { // 8 plus
            return UIEdgeInsets(top: 2, left: 10, bottom: 10, right: 20)
        } else if result.height == 896.000000 { // 11 plus
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        } else if result.height == 812.000000 { // 11 pro
            return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        } else {*/
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        // }
          
    }
    
    
    /*func collectionView(_ tableView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? UserHomeCollectionCell {
            // cachedPosition[indexPath] = cell.collectionView.contentOffset
            // print(cell.clView.tag as Any)
            
            print(cell.tag as Any)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? UserHomeCollectionCell {
            // cachedPosition[indexPath] = cell.collectionView.contentOffset
            // print(cell.clView.tag as Any)
            
            print(cell.tag as Any)
        }
        
    }*/
    
}
