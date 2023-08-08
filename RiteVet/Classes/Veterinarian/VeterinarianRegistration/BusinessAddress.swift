//
//  BusinessAddress.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView

class BusinessAddress: UIViewController, UITextFieldDelegate {

    var arrCountryList:NSMutableArray! = []
    var arrCountryListToShow:NSMutableArray! = []
    
    var arrStateList:NSMutableArray! = []
    var arrStateListToShow:NSMutableArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "VETERINARIAN REGISTRATION"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // MARK:- SELECT GENDER -
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    var dictgetAllDataVeterinarianFromVeterianrianPage:NSDictionary!
    var dictGetTextFieldDataFromVeterinarianPage:NSDictionary!
    
    var strClinicHospital:String!
    var strMobileClinic:String!
    var strVirtualServices:String!
    
    var myStreetAddress:String!
    var mySuit:String!
    var myCity:String!
    var myState:String!
    var myZipcode:String!
    var myCountry:String!
    var myPhoneNumber:String!
    var myEmail:String!
    
    var strCountryId:String!
    var strStateId:String!
    
    @IBOutlet weak var txtStreetAddress:UITextField!
    @IBOutlet weak var txtSuit:UITextField!
    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtZipcode:UITextField!
    @IBOutlet weak var txtCountry:UITextField!
    @IBOutlet weak var txtPhone:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtYearsInBusinessExperience:UITextField!
    
    @IBOutlet weak var btnNext:UIButton!
    
    @IBOutlet weak var btnClinicOrHospital:UIButton!
    @IBOutlet weak var btnMobilClinic:UIButton!
    @IBOutlet weak var btnVirtualVeterianarian:UIButton!
    
    @IBOutlet weak var btnCountry:UIButton!
    @IBOutlet weak var btnState:UIButton!
    
    
    var saveChatFunc:String! = "1"
    var saveAudioFunc:String! = "1"
    var saveVideoFunc:String! = "1"
    
    @IBOutlet weak var btnChat:UIButton! {
        didSet {
            btnChat.tag = 0
        }
    }
    @IBOutlet weak var btnAudio:UIButton! {
        didSet {
            btnAudio.tag = 0
        }
    }
    @IBOutlet weak var btnVideo:UIButton! {
        didSet {
            btnVideo.tag = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(nextClickMethod), for: .touchUpInside)
        
        btnChat.addTarget(self, action: #selector(chatClickMethod), for: .touchUpInside)
        btnAudio.addTarget(self, action: #selector(audioClickMethod), for: .touchUpInside)
        btnVideo.addTarget(self, action: #selector(videoClickMethod), for: .touchUpInside)
        
        strClinicHospital   = "0"
        strMobileClinic     = "0"
        strVirtualServices  = "0"
        strStateId = "0"
        strCountryId = "0"
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        print(person) //
            
            self.btnCountry.isUserInteractionEnabled = false
            self.txtCountry.text = (person["countryName"] as! String)
            self.txtCountry.isUserInteractionEnabled = false
            
            self.strCountryId = "\(person["countryId"]!)"
            
        }
        
        self.UIdesignOfBusinessAddress()
    }
    
    @objc func chatClickMethod() {
        
        if self.saveChatFunc == "1" {
            btnChat.setImage(UIImage(named: "tickGreen"), for: .normal)
            self.btnChat.tag = 1
            
            self.saveChatFunc = "2"
            
        } else {
            
            self.btnChat.tag = 0
            btnChat.setImage(UIImage(named: "tickWhite"), for: .normal)
            
            self.saveChatFunc = "1"
        }
        
    }
    
    @objc func audioClickMethod() {
        
        if self.saveAudioFunc == "1" {
            btnAudio.setImage(UIImage(named: "tickGreen"), for: .normal)
            self.btnAudio.tag = 1
            
            self.saveAudioFunc = "2"
        } else {
            
            self.btnAudio.tag = 0
            btnAudio.setImage(UIImage(named: "tickWhite"), for: .normal)
            
            self.saveAudioFunc = "1"
        }
        
    }
    
    @objc func videoClickMethod() {
        
        if self.saveVideoFunc == "1" {
            btnVideo.setImage(UIImage(named: "tickGreen"), for: .normal)
            self.btnVideo.tag = 1
            
            self.saveVideoFunc = "2"
            
        } else {
            
            self.btnVideo.tag = 0
            btnVideo.setImage(UIImage(named: "tickWhite"), for: .normal)
            
            self.saveVideoFunc = "1"
            
        }
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK:- TEXT FIELD -
    @objc func UIdesignOfBusinessAddress() {
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: txtStreetAddress, placeHolder: "Street address*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtSuit, placeHolder: "Suite", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtCity, placeHolder: "City*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtState, placeHolder: "State*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtZipcode, placeHolder: "Zipcode*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtCountry, placeHolder: "Country*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtPhone, placeHolder: "Phone Number*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtEmail, placeHolder: "Email address*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtYearsInBusinessExperience, placeHolder: "Years in Business*", cornerRadius: 20, color: .white)
        
        
        /****** FINISH BUTTON *********/
        Utils.buttonDR(button: btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        txtStreetAddress.delegate = self
        txtSuit.delegate = self
        txtCity.delegate = self
        txtState.delegate = self
        txtZipcode.delegate = self
        txtCountry.delegate = self
        txtPhone.delegate = self
        txtEmail.delegate = self
        txtYearsInBusinessExperience.delegate = self
        
        /*btnClinicOrHospital.tag = 0
        btnMobilClinic.tag = 0
        btnVirtualVeterianarian.tag = 0*/
        
        
        
        /*
         Optional({
             ACName = "";
             AccountNo = "";
             BImage = "";
             BankName = "";
             BusinessLicenseNo = f;
             CVV = "";
             PaypalEmail = "";
             RoutingNo = "";
             Specialization = 1;
             TypeOfService = 5;
             VAstate = "";
             VBSuite = "";
             VBusinessAddress = "";
             VBusinessName = f;
             VEmail = "dishantrajput38@gmail.com";
             VFirstName = "Mobile Gaming";
             VLastName = "iPhone X";
             VLicenseNo = "";
             VPhone = "+918929963";
             VState = "";
             VTaxID = t;
             VZipcode = "";
             Vcity = "";
             YearInBusiness = 55;
             accountType = "";
             address = hunijininin;
             cardNo = "";
             city = "Dishant Rajput Vendor";
             contactNumber = 1234567899;
             countryName = Afghanistan;
             email = "abcd@gmail.com";
             estimatePrice = "";
             expMon = "";
             expYear = "";
             fullName = "Dishant Rajput";
             image = "";
             lastName = "";
             multipleLicense =     (
             );
             otherPet = "";
             otherService = "";
             otherSpecialization = "";
             ownPicture = "";
             paypalAccount = "";
             role = Member;
             stateName = Badakhshan;
             swiftNumber = "";
             typeOfBusiness = "1,2";
             typeOfPetSetting = "";
             typeOfPetSettingOther = "";
             typeOfPets = "2,6";
             uploadDocument = "";
             uploadLicense = "";
             uploadTranscript = "";
             userId = 105;
             zipCode = 9966;
         })
         */
        
        // ae76@D$$dRE
        /*if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any] {
            print(person as Any)
            let streetAddress : String = (person["address"] as! String)
            let suit : String = (person["VBSuite"] as! String)
            let city : String = (person["Vcity"] as! String)
            let state : String = (person["VState"] as! String)
            let zipcode : String = (person["VState"] as! String)
            let country : String = (person["countryName"] as! String)
            let phonenumber : String = (person["VPhone"] as! String)
            let emailaddress : String = (person["VEmail"] as! String)
            
            self.myStreetAddress = String(streetAddress)
            self.mySuit = String(suit)
            self.myCity = String(city)
            self.myState = String(state)
            self.myZipcode = String(zipcode)
            self.myCountry = String(country)
            self.myPhoneNumber = String(phonenumber)
            self.myEmail = String(emailaddress)
            
            
            self.txtStreetAddress.text = myStreetAddress
            self.txtSuit.text = mySuit
            self.txtCity.text = myCity
            self.txtState.text = myState
            self.txtZipcode.text = myZipcode
            self.txtCountry.text = myCountry
            self.txtPhone.text = myPhoneNumber
            self.txtEmail.text = myEmail
            
            //let str:String = (person["Specialization"] as! String)
            //print(str as Any)
            
            if let myLoadedString1 = UserDefaults.standard.string(forKey: "VRclinic")
            {
                if myLoadedString1 == "0"
                {
                    btnClinicOrHospital.setImage(UIImage(named: "tickWhite"), for: .normal)
                }
                else if myLoadedString1 == "1"
                {
                    btnClinicOrHospital.setImage(UIImage(named: "tickGreen"), for: .normal)
                }
            }
            
            if let myLoadedString2 = UserDefaults.standard.string(forKey: "VRmobile")
            {
                if myLoadedString2 == "0"
                {
                    btnMobilClinic.setImage(UIImage(named: "tickWhite"), for: .normal)
                }
                else if myLoadedString2 == "2"
                {
                    btnMobilClinic.setImage(UIImage(named: "tickGreen"), for: .normal)
                }
            }
            
            if let myLoadedString3 = UserDefaults.standard.string(forKey: "VRvirtual")
            {
                if myLoadedString3 == "0"
                {
                    btnVirtualVeterianarian.setImage(UIImage(named: "tickWhite"), for: .normal)
                }
                else if myLoadedString3 == "3"
                {
                    btnVirtualVeterianarian.setImage(UIImage(named: "tickGreen"), for: .normal)
                }
            }
            
            
            
           }*/
        
        
        self.btnState.addTarget(self, action: #selector(stateListWb), for: .touchUpInside)
        self.btnCountry.addTarget(self, action: #selector(countryListPopup(_:)), for: .touchUpInside)
        
        self.welcome2()
        
    }
    
    
    
    @objc func nextClickMethod() {
        
        if (self.strCountryId == "231") {
            if self.txtZipcode.text == "" {
                
                let alert = UIAlertController(title: "Error!", message: "Please enter zipcode.",preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                self.veterianrianRegistrationSecondPage()
            }
            
        } else {
            self.veterianrianRegistrationSecondPage()
        }
        
    }
    
    @objc func welcome2() {
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
                   
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
               
            switch(response.result) {
            case .success(_):
                if let data = response.value {

                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                              
                    if strSuccess == "success" {
                        // Utils.RiteVetIndicatorHide()
                        
                         var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        self.txtStreetAddress.text  = (dict["VBusinessAddress"] as! String)
                        self.txtSuit.text           = (dict["VBSuite"] as! String)
                        self.txtCity.text           = (dict["Vcity"] as! String)
                        self.txtState.text          = (dict["VState"] as! String)
                        self.txtZipcode.text        = (dict["VZipcode"] as! String)
                        //self.txtCountry.text        = (dict["countryName"] as! String)
                        
                        // let x : Int = (dict["countryId"] as! Int)
                        // let myString = String(x)
                        // self.strCountryId = myString
                        
                        // country
                        /*if dict["countryId"] is String {
                            print("Yes, it's a String")

                            self.strCountryId = (dict["countryId"] as! String)
                            
                        } else if dict["countryId"] is Int {
                            print("It is Integer")
                                        
                            let x2 : Int = (dict["countryId"] as! Int)
                            let myString2 = String(x2)
                            self.strCountryId = myString2
                        } else {
                            print("i am number")
                                        
                            let temp:NSNumber = dict["countryId"] as! NSNumber
                            let tempString = temp.stringValue
                            self.strCountryId = tempString
                        }*/
                        
                        
                        // state
                        if dict["stateId"] is String {
                            print("Yes, it's a String")

                            self.strStateId = (dict["stateId"] as! String)
                            
                        } else if dict["stateId"] is Int {
                            print("It is Integer")
                                        
                            let x2 : Int = (dict["stateId"] as! Int)
                            let myString2 = String(x2)
                            self.strStateId = myString2
                        } else {
                            print("i am number")
                                        
                            let temp:NSNumber = dict["stateId"] as! NSNumber
                            let tempString = temp.stringValue
                            self.strStateId = tempString
                        }
                        // let x2 : Int = (dict["stateId"] as! Int)
                        // let myString2 = String(x2)
                        // self.strStateId = myString2
                        
                        self.txtPhone.text        = (dict["VPhone"] as! String)
                        self.txtYearsInBusinessExperience.text        = (dict["YearInBusiness"] as! String)
                        self.txtEmail.text        = (dict["VEmail"] as! String)
                        
                        // typeOfBusiness = 2;
                        // tickWhite
                        // tickGreen
                        
                        // Specialization
                        let array = (dict["typeOfBusiness"] as! String).components(separatedBy: ",")
                        print(array as Any)
                        
                        self.btnClinicOrHospital.tag = 0
                        self.btnMobilClinic.tag = 0
                        self.btnVirtualVeterianarian.tag = 0
                        
                        self.btnClinicOrHospital.setImage(UIImage(named: "tickWhite"), for: .normal)
                        self.btnMobilClinic.setImage(UIImage(named: "tickWhite"), for: .normal)
                        self.btnVirtualVeterianarian.setImage(UIImage(named: "tickWhite"), for: .normal)
                        
                        /*for index in 0..<array.count {
                            
                            let item = array[index]
                            print(item as Any)
                            
                            if item == "1" {
                                
                                self.strClinicHospital = "1"
                                self.btnClinicOrHospital.tag = 1
                                self.btnClinicOrHospital.setImage(UIImage(named: "tickGreen"), for: .normal)
                                
                            } else if item == "2" {
                                
                                self.strMobileClinic = "2"
                                self.btnMobilClinic.tag = 1
                                self.btnMobilClinic.setImage(UIImage(named: "tickGreen"), for: .normal)
                                
                            } else {
                                
                                self.strVirtualServices = "3"
                                self.btnVirtualVeterianarian.tag = 1
                                self.btnVirtualVeterianarian.setImage(UIImage(named: "tickGreen"), for: .normal)
                                
                            }
                            
                        }*/
                        
                        self.btnClinicOrHospital.addTarget(self, action: #selector(self.clinicClickMethod), for: .touchUpInside)
                        self.btnMobilClinic.addTarget(self, action: #selector(self.mobilClickMethod), for: .touchUpInside)
                        self.btnVirtualVeterianarian.addTarget(self, action: #selector(self.virtualClickMethod), for: .touchUpInside)
                        
                        
                        // MessageChat = 1;
                        // videoChat = 1;
                        // AudioChat = 1;
                        
                        self.saveChatFunc = "\(dict["MessageChat"] as! Int)"
                        self.saveVideoFunc = "\(dict["videoChat"] as! Int)"
                        self.saveAudioFunc = "\(dict["AudioChat"] as! Int)"
                        
                        // chat
                        if self.saveChatFunc == "2" {
                            self.btnChat.setImage(UIImage(named: "tickGreen"), for: .normal)
                        } else {
                            self.btnChat.setImage(UIImage(named: "tickWhite"), for: .normal)
                        }
                        
                        // audio
                        if self.saveAudioFunc == "2" {
                            self.btnAudio.setImage(UIImage(named: "tickGreen"), for: .normal)
                        } else {
                            self.btnAudio.setImage(UIImage(named: "tickWhite"), for: .normal)
                        }
                        
                        // video
                        if self.saveVideoFunc == "2" {
                            self.btnVideo.setImage(UIImage(named: "tickGreen"), for: .normal)
                        } else {
                            self.btnVideo.setImage(UIImage(named: "tickWhite"), for: .normal)
                        }
                        
                        self.countryListWb()
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
    
    //MARK:- BUTTON TAGS (CLINIC) -
    @objc func clinicClickMethod() {
        if btnClinicOrHospital.tag == 0 {
            btnClinicOrHospital.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnClinicOrHospital.tag = 1
            
            strClinicHospital = "1"
            
            UserDefaults.standard.set(strClinicHospital, forKey: "VRclinic")
        }
        else if btnClinicOrHospital.tag == 1 {
            btnClinicOrHospital.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnClinicOrHospital.tag = 0
            
            strClinicHospital = "0"
            UserDefaults.standard.set(strClinicHospital, forKey: "VRclinic")
        }
    }
    @objc func mobilClickMethod() {
        if btnMobilClinic.tag == 0 {
            btnMobilClinic.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnMobilClinic.tag = 1
            
            strMobileClinic = "2"
            UserDefaults.standard.set(strMobileClinic, forKey: "VRmobile")
        }
        else if btnMobilClinic.tag == 1 {
            btnMobilClinic.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnMobilClinic.tag = 0
            
            strMobileClinic = "0"
            UserDefaults.standard.set(strMobileClinic, forKey: "VRmobile")
        }
    }
    @objc func virtualClickMethod() {
        if btnVirtualVeterianarian.tag == 0 {
            btnVirtualVeterianarian.setImage(UIImage(named: "tickGreen"), for: .normal)
            btnVirtualVeterianarian.tag = 1
            
            strVirtualServices = "3"
            UserDefaults.standard.set(strVirtualServices, forKey: "VRvirtual")
        }
        else if btnVirtualVeterianarian.tag == 1 {
            btnVirtualVeterianarian.setImage(UIImage(named: "tickWhite"), for: .normal)
            btnVirtualVeterianarian.tag = 0
            
            strVirtualServices = "0"
            UserDefaults.standard.set(strVirtualServices, forKey: "VRvirtual")
        }
    }
    
    
    @objc func veterianrianRegistrationSecondPage() {
        
        var addAllStrings = strClinicHospital+","+strMobileClinic+","+strVirtualServices
        addAllStrings = addAllStrings.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        addAllStrings = addAllStrings.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])
        
        print(addAllStrings as Any)
        
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             self.saveChatFunc = "\(dict["MessageChat"] as! Int)"
             self.saveAudioFunc = "\(dict["videoChat"] as! Int)"
             self.saveVideoFunc = "\(dict["AudioChat"] as! Int)"
             */
            //if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any] {
            
                   parameters = [
                    "action"            :   "petparentregistration",
                    "userId"            :   String(myString),
                    "UTYPE"             :   "2",
                    "VBusinessAddress"  :   String(txtStreetAddress.text!),
                    "VBSuite"           :   String(txtSuit.text!),
                    "countryId"         :   String(strCountryId),
                    "countryName"       :   String(txtCountry.text!),
                    "VState"            :   String(txtState.text!),
                    "stateId"           :   String(strStateId),
                    "Vcity"             :   String(txtCity.text!),
                    "VZipcode"          :   String(txtZipcode.text!),
                    "VEmail"            :   String(txtEmail.text!),
                    "typeOfBusiness"    :   String(addAllStrings),
                    "MessageChat"       :   String(saveChatFunc),
                    "videoChat"         :   String(saveVideoFunc),
                    "AudioChat"         :   String(saveAudioFunc),
                    "YearInBusiness"    :   String(self.txtYearsInBusinessExperience.text!),
                    "VPhone"            :   String(self.txtPhone.text!),
                       //"latitude"          :   "",
                       //"longitude"         :   "",
                       
                   ]
                
            //}
        }
                
                   print("parameters-------\(String(describing: parameters))")
                   
                   AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
                       {
                           response in
               
                           switch(response.result) {
                           case .success(_):
                              if let data = response.value {

                               
                               let JSON = data as! NSDictionary
                               print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               if strSuccess == "success" {
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                                
                                
                                 let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VeterinarianTypesId") as? VeterinarianTypes
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                                Utils.RiteVetIndicatorHide()
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

    @objc func countryListWb() {
        // indicator.startAnimating()
        // Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            // let x : Int = (person["userId"] as! Int)
            // let myString = String(x)
            
            parameters = [
                "action"    : "countrylist",
                
            ]
        
                
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
                              
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        
                        // var dict: Dictionary<AnyHashable, Any>
                        // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrCountryList.addObjects(from: ar as! [Any])
                        // arrStateList
                        
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
    
    @objc func stateListWb() {
        // indicator.startAnimating()
        // Utils.RiteVetIndicatorShow()
           
        if strCountryId == "0" {
            
        } else {
            
            let urlString = BASE_URL_KREASE
                   
            var parameters:Dictionary<AnyHashable, Any>!
               
            // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                // print(person as Any)
                
                // let x : Int = (person["userId"] as! Int)
                // let myString = String(x)
                
                parameters = [
                    "action"    : "statelist",
                    "counttyId" : String(strCountryId)
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
                                  
                        if strSuccess == "success" {
                            Utils.RiteVetIndicatorHide()
                            
                            // var dict: Dictionary<AnyHashable, Any>
                            // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrStateList.addObjects(from: ar as! [Any])
                            // arrStateList
                            
                            self.stateListPopup()
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
    
    
    @objc func countryListPopup(_ sender:UIButton) {
        
        self.arrCountryListToShow.removeAllObjects()
        
        // let myString1 = productQuantity
        // let myInt1 = Int(myString1!)
        print(self.arrCountryList as Any)
        
        for index in 0..<self.arrCountryList.count {
                
            // convert int quantity to string then save to nutable array
            // let x : Int = qList
            // let myString = String(x)
            // strStateId
            let item = self.arrCountryList[index] as? [String:Any]
            print(item as Any)
            
            let strName:String!
            let strId:String!
            
            strName = (item!["name"] as! String)
            
            // country id
            let x : Int = item!["id"] as! Int
            let myString = String(x)
            strId = myString
            self.arrCountryListToShow.add(strId+". "+strName as Any)
            // arrStateListToShow
            
        }
            
        print(self.arrCountryListToShow as Any)
            
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Country",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : NAVIGATION_BACKGROUND_COLOR,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "search country",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Okay",
            doneButtonColor     : .black,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named:"red_ic_checked"),
            itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
            itemColor           : .black,
            itemFont            : regularFont
        )
             
            // MARK:- CONVERT MUTABLE ARRAY TO ARRAY -
            let array: [String] = arrCountryListToShow.copy() as! [String]
            
            let arrGender = array
            let picker = YBTextPicker.init(with: arrGender, appearance: redAppearance,
                                           onCompletion: { (selectedIndexes, selectedValues) in
                                            if let selectedValue = selectedValues.first{
                                                if selectedValue == arrGender.last!{
                                                     
                                                    let fullNameArr = selectedValue.components(separatedBy: ".")

                                                    let expMonth2    = fullNameArr[0]
                                                    let expMonth    = fullNameArr[1]
                                                
                                                    self.txtCountry.text = "\(expMonth)"
                                                    self.txtState.text = ""
                                                    
                                                    // self.selectedStateName = selectedValue
                                                    self.strCountryId = String(expMonth2)
                                                    print(self.strCountryId as Any)
                                                    self.strStateId = "0"
                                                 } else {
                                                     
                                                    let fullNameArr = selectedValue.components(separatedBy: ".")

                                                    let expMonth2    = fullNameArr[0]
                                                    let expMonth    = fullNameArr[1]
                                                    
                                                    self.txtCountry.text = "\(expMonth)"
                                                    self.strCountryId = String(expMonth2)
                                                    print(self.strCountryId as Any)
                                                    
                                                    self.txtState.text = ""
                                                    self.strStateId = "0"
                                                    // self.selectedStateName = selectedValue
                                                    
                                                 }
                                             } else {
                                                 // self.btnGenderPicker.setTitle("What's your gender?", for: .normal)
                                                 // cell.txtSelectGender.text = "What's your gender?"
                                                
                                                print()
                                                
                                             }
             },
                                            onCancel: {
                                                print("Cancelled")
             })
             
            picker.show(withAnimation: .FromBottom)
        
        
    }
    
    @objc func stateListPopup() {
        
        self.arrStateListToShow.removeAllObjects()
        
        // let myString1 = productQuantity
        // let myInt1 = Int(myString1!)
        print(self.arrStateList as Any)
        
        for index in 0..<self.arrStateList.count {
                
            // convert int quantity to string then save to nutable array
            // let x : Int = qList
            // let myString = String(x)
            // strStateId
            let item = self.arrStateList[index] as? [String:Any]
            print(item as Any)
            
            let strName:String!
            let strId:String!
            
            strName = (item!["name"] as! String)
            
            // country id
            let x : Int = item!["id"] as! Int
            let myString = String(x)
            strId = myString
            self.arrStateListToShow.add(strId+". "+strName as Any)
            // arrStateListToShow
            
        }
            
        print(self.arrStateListToShow as Any)
            
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select State",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : NAVIGATION_BACKGROUND_COLOR,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "search state",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Okay",
            doneButtonColor     : .black,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named:"red_ic_checked"),
            itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
            itemColor           : .black,
            itemFont            : regularFont
        )
             
            // MARK:- CONVERT MUTABLE ARRAY TO ARRAY -
            let array: [String] = arrStateListToShow.copy() as! [String]
            
            let arrGender = array
            let picker = YBTextPicker.init(with: arrGender, appearance: redAppearance,
                                           onCompletion: { (selectedIndexes, selectedValues) in
                                            if let selectedValue = selectedValues.first{
                                                if selectedValue == arrGender.last!{
                                                     
                                                    let fullNameArr = selectedValue.components(separatedBy: ".")

                                                    let expMonth2    = fullNameArr[0]
                                                    let expMonth    = fullNameArr[1]
                                                
                                                    self.txtState.text = "\(expMonth)"
                                                
                                                    // self.selectedStateName = selectedValue
                                                    self.strStateId = String(expMonth2)
                                                    
                                                 } else {
                                                     
                                                    let fullNameArr = selectedValue.components(separatedBy: ".")

                                                    let expMonth2    = fullNameArr[0]
                                                    let expMonth    = fullNameArr[1]
                                                    
                                                    self.txtState.text = "\(expMonth)"
                                                    self.strStateId = String(expMonth2)
                                                    
                                                    // self.selectedStateName = selectedValue
                                                    
                                                 }
                                             } else {
                                                 // self.btnGenderPicker.setTitle("What's your gender?", for: .normal)
                                                 // cell.txtSelectGender.text = "What's your gender?"
                                                
                                                print()
                                                
                                             }
             },
                                            onCancel: {
                                                print("Cancelled")
             })
             
            picker.show(withAnimation: .FromBottom)
        
        
    }
    
}

/*
extension BusinessAddress: UITableViewDataSource , UITableViewDelegate {
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
       
        return 1000
        
    }
}
class BusinessAddressTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
*/
