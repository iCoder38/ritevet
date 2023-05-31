//
//  Registration.swift
//  RiteVet
//
//  Created by Apple  on 26/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Registration: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SIGN IN"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var imgLogo:UIImageView!
    
    var arrCountryList:NSMutableArray! = []
    var arrCountryListToShow:NSMutableArray! = []
    
    var arrStateList:NSMutableArray! = []
    var arrStateListToShow:NSMutableArray! = []
    
    
    
    // MARK:- SELECT GENDER -
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    var strCountryId:String!
    var strStateId:String!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UIdesignOfLoginScreen()
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        strStateId = "0"
        strCountryId = "0"
        
         
        self.countryListWb()
        // self.registrationClickAgterMapLocation()
        
        
    }
    
    @objc func openPopupClickMethod() {
        // [action] => termAndConditions
        
        
        let alertController = UIAlertController(title: "Terms And Privacy Policy", message: nil, preferredStyle: .actionSheet)
        
        let Edit = UIAlertAction(title: "Terms and Conditions", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Edit Pressed")
            
            self.ourTermsAndConditionsWB(strPrivacyOrTerms: "termAndConditions")
            
        }
        let delete = UIAlertAction(title: "Privacy policy", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Delete Pressed")
            
            self.ourTermsAndConditionsWB(strPrivacyOrTerms: "privacypolicy")
        }
        
        let okAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        alertController.addAction(Edit)
        alertController.addAction(delete)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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
    
    //MARK:-
    @objc func UIdesignOfLoginScreen() {
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        
        /****** TEXT FIELDS *********/
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
        Utils.textFieldDR(text: cell.txtName, placeHolder: "Full Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtEmail, placeHolder: "Email address", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtPhone, placeHolder: "Phone Number", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtAddress, placeHolder: "Address", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtCountry, placeHolder: "Country", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtState, placeHolder: "State", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtCity, placeHolder: "City", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtZipcode, placeHolder: "Zip Code", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtPassword, placeHolder: "Password", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtConfirmPassword, placeHolder: "Confirm Password", cornerRadius: 20, color: .white)
 
        cell.txtName.delegate = self
        cell.txtEmail.delegate = self
        cell.txtPhone.delegate = self
        cell.txtAddress.delegate = self
        cell.txtCountry.delegate = self
        cell.txtState.delegate = self
        cell.txtCity.delegate = self
        cell.txtZipcode.delegate = self
        cell.txtPassword.delegate = self
        cell.txtConfirmPassword.delegate = self
        
        /****** SIGN UP BUTTON *********/
        Utils.buttonDR(button: cell.btnSignUp, text: "SIGN UP", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        /****** SIGN IN BUTTON *********/
        cell.btnSignIn.addTarget(self, action: #selector(pushToRegistration), for: .touchUpInside)
        
        /****** CHECK UNCHECK BUTTON *********/
        cell.btnCheckUncheck.addTarget(self, action: #selector(checkUncheckClickMethod), for: .touchUpInside)
        cell.btnCheckUncheck.tag = 0
    
    /****** FACEBOOK *********/
        cell.btnFB.backgroundColor = UIColor.init(red: 46.0/255.0, green: 79.0/255.0, blue: 183.0/255.0, alpha: 1)
        cell.btnFB.layer.cornerRadius = 20
        cell.btnFB.clipsToBounds = true
        // cell.btnFB.setTitle("f", for: .normal)
        cell.btnFB.setTitleColor(.white, for: .normal)
        cell.btnFB.addTarget(self, action: #selector(fbClickMethod), for: .touchUpInside)
        
    /****** G+ *********/
        cell.btnGooglePlus.backgroundColor = UIColor.init(red: 193.0/255.0, green: 47.0/255.0, blue: 38.0/255.0, alpha: 1)
        cell.btnGooglePlus.layer.cornerRadius = 20
        cell.btnGooglePlus.clipsToBounds = true
        // cell.btnGooglePlus.setTitle("g+", for: .normal)
        cell.btnGooglePlus.setTitleColor(.white, for: .normal)
        cell.btnGooglePlus.addTarget(self, action: #selector(gClickMethod), for: .touchUpInside)
        
        cell.btnSignUp.isUserInteractionEnabled = false
        cell.btnSignUp.backgroundColor = .lightGray
        cell.btnSignUp.setTitleColor(.black, for: .normal)
        
        cell.btnCountry.addTarget(self, action: #selector(countryListPopup), for: .touchUpInside)
        cell.btnState.addTarget(self, action: #selector(stateListWb), for: .touchUpInside)
        
        /****** SIGN UP BUTTON *********/
        cell.btnSignUp.addTarget(self, action: #selector(signUpClickMethod), for: .touchUpInside)
        
        cell.btnIagree.addTarget(self, action: #selector(openPopupClickMethod), for: .touchUpInside)
    }
    
    @objc func pushToRegistration() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signUpClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
        if cell.btnCheckUncheck.tag == 0 {
            self.agreeOurTermsAndConditions()
        } else {
            self.validationBeforeRegistration()
        }
        
    }
    
    @objc func fbClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
        if cell.btnCheckUncheck.tag == 0 {
            self.agreeOurTermsAndConditions()
        } else {
            
        }
    }
    
    @objc func gClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
        if cell.btnCheckUncheck.tag == 0 {
            self.agreeOurTermsAndConditions()
        } else {
            
        }
    }
    
    @objc  func agreeOurTermsAndConditions() {
        
        let alert = UIAlertController(title: "Alert!", message: "Please agree our Terms and Conditions",preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func ourTermsAndConditionsWB(strPrivacyOrTerms:String) {
        
        
        //indicator.startAnimating()
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE

        var parameters:Dictionary<AnyHashable, Any>!
        
            parameters = [
                "action"        :   String(strPrivacyOrTerms)//"termAndConditions",
 
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
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == "success" {
                            // var dict: Dictionary<AnyHashable, Any>
                            //dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            Utils.RiteVetIndicatorHide()
                            let htmlString = "<span style=\"font-family: Avenier-Next; font-size: 16.0\">\(strSuccess2 ?? "test")</span>"
                            let data = htmlString.data(using: String.Encoding.unicode)! // mind "!"
                            let attrStr = try? NSAttributedString( // do catch
                                data: data,
                                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                documentAttributes: nil)
                            // suppose we have an UILabel, but any element with NSAttributedString will do
                            // cell2.lblProductDescription.attributedText = attrStr
                            
                            
                            let s = attrStr!.string as NSString
                            
                            let alert = UIAlertController(title: "Terms!", message: String(s),preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                                //Cancel Action
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
 
                        } else {
                            Utils.RiteVetIndicatorHide()

                        }
                        
                         }

                    case .failure(_):
                        print("Error message:\(String(describing: response.error))")
                        //self.whileLoadingEnable()
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func checkUncheckClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
        if cell.btnCheckUncheck.tag == 0 {
            cell.btnCheckUncheck.setImage(UIImage(named: "regCheck"), for: .normal)
            cell.btnCheckUncheck.tag = 1
            
            cell.btnSignUp.isUserInteractionEnabled = true
            
              /****** SIGN UP BUTTON *********/
            Utils.buttonDR(button: cell.btnSignUp, text: "SIGN UP", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        }
        else if cell.btnCheckUncheck.tag == 1 {
            cell.btnCheckUncheck.setImage(UIImage(named: "regUncheck"), for: .normal)
            cell.btnCheckUncheck.tag = 0
            
            cell.btnSignUp.isUserInteractionEnabled = false
            cell.btnSignUp.backgroundColor = .lightGray
            cell.btnSignUp.setTitleColor(.black, for: .normal)
            
        }
    }
    
    /*
     @IBOutlet weak var txtName:UITextField!
     @IBOutlet weak var txtEmail:UITextField!
     @IBOutlet weak var txtPhone:UITextField!
     @IBOutlet weak var txtCountry:UITextField!
     @IBOutlet weak var txtState:UITextField!
     @IBOutlet weak var txtCity:UITextField!
     @IBOutlet weak var txtAddress:UITextField!
     @IBOutlet weak var txtPassword:UITextField!
     @IBOutlet weak var txtConfirmPassword:UITextField!
     @IBOutlet weak var txtZipcode:UITextField!
     */
    @objc func validationBeforeRegistration() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
        if cell.txtName.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtEmail.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtPhone.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtCountry.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtState.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtCity.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtAddress.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtPassword.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtConfirmPassword.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else if cell.txtZipcode.text == "" {
            self.fieldShouldNotBeEmptyPopup()
        } else {
            self.registrationClickAgterMapLocation()
        }
        
        
    }
    
    @objc func fieldShouldNotBeEmptyPopup() {
    
        let alert = UIAlertController(title: "Error!", message: "Field should not be Empty.",preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func registrationClickAgterMapLocation() {
        
        
        //indicator.startAnimating()
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE

        /*
         action:registration
         email:abc@gmail.com
         fullName:raushan kumar
         contactNumber:45124512
         password:123456
         image:
         device:IOS
         deviceToken:4541246454
         firebaseId:
         address:gggggggg
         role:Member/Vendor
         countryId:
         stateId:
         city:
         zipCode

         UTYPE:   //action Welcome Type
         lat:
         longs:
         */
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
        var parameters:Dictionary<AnyHashable, Any>!
        
            parameters = [
                "action"        :   "registration",
                "email"         :   String(cell.txtEmail.text!),
                "fullName"      :   String(cell.txtName.text!),
                "contactNumber" :   String(cell.txtPhone.text!),
                "password"      :   String(cell.txtPassword.text!),
                "address"       :   String(cell.txtAddress.text!),
                "city"          :   String(cell.txtCity.text!),
                "stateId"       :   String(self.strStateId),
                "countryId"     :   String(self.strCountryId),
                "device"        :   "iOS",
                "deviceToken"   :   String(""),
                "role"          :   "Member",
                "zipCode"       :   String(cell.txtZipcode.text!),
 
            ]
       
         
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
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == "success" {
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: "keyLoginFullData")
                                 
                            let alert = UIAlertController(title: strSuccess, message: String(strSuccess2),preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                                self.pushFromLoginPage()
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
 
                        } else {
                           

                        }
                        
                         }

                    case .failure(_):
                        print("Error message:\(String(describing: response.error))")
                        //self.whileLoadingEnable()
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
    
    @objc func pushFromLoginPage() {
        Utils.RiteVetIndicatorHide()
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    @objc func countryListWb() {
        // indicator.startAnimating()
        Utils.RiteVetIndicatorShow()
           
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
                    // print(JSON)
                    
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
            
            let alert = UIAlertController(title: "Alert!", message: "Please select your Country.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.arrStateList.removeAllObjects()
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
                        // print(JSON)
                        
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
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
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
                                                
                                                    cell.txtCountry.text = "\(expMonth)"
                                                    cell.txtState.text = ""
                                                    
                                                    // self.selectedStateName = selectedValue
                                                    self.strCountryId = String(expMonth2)
                                                    print(self.strCountryId as Any)
                                                    self.strStateId = "0"
                                                 } else {
                                                     
                                                    let fullNameArr = selectedValue.components(separatedBy: ".")

                                                    let expMonth2    = fullNameArr[0]
                                                    let expMonth    = fullNameArr[1]
                                                    
                                                    cell.txtCountry.text = "\(expMonth)"
                                                    self.strCountryId = String(expMonth2)
                                                    print(self.strCountryId as Any)
                                                    
                                                    cell.txtState.text = ""
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
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationCell
        
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
                                                
                                                    cell.txtState.text = "\(expMonth)"
                                                
                                                    // self.selectedStateName = selectedValue
                                                    self.strStateId = String(expMonth2)
                                                    
                                                 } else {
                                                     
                                                    let fullNameArr = selectedValue.components(separatedBy: ".")

                                                    let expMonth2    = fullNameArr[0]
                                                    let expMonth    = fullNameArr[1]
                                                    
                                                    cell.txtState.text = "\(expMonth)"
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

extension Registration: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        // if let cell = cell as? PetAndParentsInformationTableCell {

            // cell.clView.dataSource = self
            // cell.clView.delegate = self
            // cell.clView.tag = indexPath.section
            // cell.clView.reloadData()

        // }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:RegistrationCell = tableView.dequeueReusableCell(withIdentifier: "registrationCell") as! RegistrationCell
          
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
        return 1200
    }
    
}

extension Registration: UITableViewDelegate {
    
}
