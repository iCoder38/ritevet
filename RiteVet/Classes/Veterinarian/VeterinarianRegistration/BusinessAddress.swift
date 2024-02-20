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
            lblNavigationTitle.text = "BUSINESS INFORMATION"
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
    
    
    
    
    var saveChatFunc:String! = "1"
    var saveAudioFunc:String! = "1"
    var saveVideoFunc:String! = "1"
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            // tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
            // tbleView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        
        
        self.welcome2()
        
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        if (textField == cell.txtPhone) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 10
            
        
        } else if (textField == cell.txtZipcode) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 6
            
        
        }  else {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 30
            
        }
        
    }
    
    @objc func chatClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        if self.saveChatFunc == "1" {
            cell.btnChat.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnChat.tag = 1
            
            self.saveChatFunc = "2"
            
        } else {
            
            cell.btnChat.tag = 0
            cell.btnChat.setImage(UIImage(named: "tickWhite"), for: .normal)
            
            self.saveChatFunc = "1"
        }
        
    }
    
    @objc func audioClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        if self.saveAudioFunc == "1" {
            cell.btnAudio.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnAudio.tag = 1
            
            self.saveAudioFunc = "2"
        } else {
            
            cell.btnAudio.tag = 0
            cell.btnAudio.setImage(UIImage(named: "tickWhite"), for: .normal)
            
            self.saveAudioFunc = "1"
        }
        
    }
    
    @objc func videoClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        if self.saveVideoFunc == "1" {
            cell.btnVideo.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnVideo.tag = 1
            
            self.saveVideoFunc = "2"
            
        } else {
            
            cell.btnVideo.tag = 0
            cell.btnVideo.setImage(UIImage(named: "tickWhite"), for: .normal)
            
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
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        
        
    }
    
    
    
    @objc func nextClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        
        if cell.txtStreetAddress.text == "" {
            
            let alert = UIAlertController(title: "Error!", message: "Please enter street address.",preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if cell.txtState.text == "" {
            
            let alert = UIAlertController(title: "Error!", message: "Please enter state.",preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if cell.txtZipcode.text == "" {
            
            let alert = UIAlertController(title: "Error!", message: "Please enter zipcode.",preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if cell.txtCity.text == "" {
            
            let alert = UIAlertController(title: "Error!", message: "Please enter city.",preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if cell.txtPhone.text == "" {
            
            let alert = UIAlertController(title: "Error!", message: "Please enter phone number.",preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if cell.txtYearsInBusinessExperience.text == "" {
            
            let alert = UIAlertController(title: "Error!", message: "Please enter years in business.",preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if cell.txtEmail.text == "" {
            
            let alert = UIAlertController(title: "Error!", message: "Please enter email.",preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            if (self.strCountryId == "231") {
                if cell.txtZipcode.text == "" {
                    
                    let alert = UIAlertController(title: "Error!", message: "Please enter zipcode.",preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    if cell.txtEmail.text!.isValidEmail() {
                        self.veterianrianRegistrationSecondPage()
                    }else {
                        let alert = UIAlertController(title: "Error!", message: "Email address is not valid.",preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
            } else {
                if cell.txtEmail.text!.isValidEmail() {
                    self.veterianrianRegistrationSecondPage()
                }else {
                    let alert = UIAlertController(title: "Error!", message: "Email address is not valid.",preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
       
        
    }
    
    @objc func welcome2() {
        // indicator.startAnimating()
        Utils.RiteVetIndicatorShow()
        
        // self.tbleView.reloadData()
         
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
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        
                        let indexPath = IndexPath.init(row: 0, section: 0)
                        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
                        cell.txtStreetAddress.text  = (dict["VBusinessAddress"] as! String)
                        cell.txtSuit.text           = (dict["VBSuite"] as! String)
                        cell.txtCity.text           = (dict["Vcity"] as! String)
                        cell.txtState.text          = (dict["VState"] as! String)
                        cell.txtZipcode.text        = (dict["VZipcode"] as! String)
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
                        
                        cell.txtPhone.text        = (dict["VPhone"] as! String)
                        cell.txtYearsInBusinessExperience.text        = (dict["YearInBusiness"] as! String)
                        cell.txtEmail.text        = (dict["VEmail"] as! String)
                        
                        // typeOfBusiness = 2;
                        // tickWhite
                        // tickGreen
                        
                        // Specialization
                        let array = (dict["typeOfBusiness"] as! String).components(separatedBy: ",")
                        print(array as Any)
                        
                        cell.btnClinicOrHospital.tag = 0
                        cell.btnMobilClinic.tag = 0
                        cell.btnVirtualVeterianarian.tag = 0
                        
                        cell.btnClinicOrHospital.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnMobilClinic.setImage(UIImage(named: "tickWhite"), for: .normal)
                        cell.btnVirtualVeterianarian.setImage(UIImage(named: "tickWhite"), for: .normal)
                        
                        for index in 0..<array.count {
                            
                            let item = array[index]
                            print(item as Any)
                            
                            if item == "1" {
                                
                                self.strClinicHospital = "1"
                                cell.btnClinicOrHospital.tag = 1
                                cell.btnClinicOrHospital.setImage(UIImage(named: "tickGreen"), for: .normal)
                                
                            } else if item == "2" {
                                
                                self.strMobileClinic = "2"
                                cell.btnMobilClinic.tag = 1
                                cell.btnMobilClinic.setImage(UIImage(named: "tickGreen"), for: .normal)
                                
                            }  else if item == "3" {
                                
                                self.strVirtualServices = "3"
                                cell.btnVirtualVeterianarian.tag = 1
                                cell.btnVirtualVeterianarian.setImage(UIImage(named: "tickGreen"), for: .normal)
                                
                            } else {
                                
                                cell.btnClinicOrHospital.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnMobilClinic.setImage(UIImage(named: "tickWhite"), for: .normal)
                                cell.btnVirtualVeterianarian.setImage(UIImage(named: "tickWhite"), for: .normal)
                                
                            }
                            
                        }
                        
                        cell.btnClinicOrHospital.addTarget(self, action: #selector(self.clinicClickMethod), for: .touchUpInside)
                        cell.btnMobilClinic.addTarget(self, action: #selector(self.mobilClickMethod), for: .touchUpInside)
                        cell.btnVirtualVeterianarian.addTarget(self, action: #selector(self.virtualClickMethod), for: .touchUpInside)
                        
                        
                        // MessageChat = 1;
                        // videoChat = 1;
                        // AudioChat = 1;
                        
                        self.saveChatFunc = "\(dict["MessageChat"] as! Int)"
                        self.saveVideoFunc = "\(dict["videoChat"] as! Int)"
                        self.saveAudioFunc = "\(dict["AudioChat"] as! Int)"
                        
                        // chat
                        if self.saveChatFunc == "2" {
                            cell.btnChat.setImage(UIImage(named: "tickGreen"), for: .normal)
                        } else {
                            cell.btnChat.setImage(UIImage(named: "tickWhite"), for: .normal)
                        }
                        
                        // audio
                        if self.saveAudioFunc == "2" {
                            cell.btnAudio.setImage(UIImage(named: "tickGreen"), for: .normal)
                        } else {
                            cell.btnAudio.setImage(UIImage(named: "tickWhite"), for: .normal)
                        }
                        
                        // video
                        if self.saveVideoFunc == "2" {
                            cell.btnVideo.setImage(UIImage(named: "tickGreen"), for: .normal)
                        } else {
                            cell.btnVideo.setImage(UIImage(named: "tickWhite"), for: .normal)
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
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        if cell.btnClinicOrHospital.tag == 0 {
            cell.btnClinicOrHospital.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnClinicOrHospital.tag = 1
            
            strClinicHospital = "1"
            
            UserDefaults.standard.set(strClinicHospital, forKey: "VRclinic")
        }
        else if cell.btnClinicOrHospital.tag == 1 {
            cell.btnClinicOrHospital.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnClinicOrHospital.tag = 0
            
            strClinicHospital = "0"
            UserDefaults.standard.set(strClinicHospital, forKey: "VRclinic")
        }
    }
    @objc func mobilClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        if cell.btnMobilClinic.tag == 0 {
            cell.btnMobilClinic.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnMobilClinic.tag = 1
            
            strMobileClinic = "2"
            UserDefaults.standard.set(strMobileClinic, forKey: "VRmobile")
        }
        else if cell.btnMobilClinic.tag == 1 {
            cell.btnMobilClinic.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnMobilClinic.tag = 0
            
            strMobileClinic = "0"
            UserDefaults.standard.set(strMobileClinic, forKey: "VRmobile")
        }
    }
    @objc func virtualClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
        if cell.btnVirtualVeterianarian.tag == 0 {
            cell.btnVirtualVeterianarian.setImage(UIImage(named: "tickGreen"), for: .normal)
            cell.btnVirtualVeterianarian.tag = 1
            
            strVirtualServices = "3"
            UserDefaults.standard.set(strVirtualServices, forKey: "VRvirtual")
        }
        else if cell.btnVirtualVeterianarian.tag == 1 {
            cell.btnVirtualVeterianarian.setImage(UIImage(named: "tickWhite"), for: .normal)
            cell.btnVirtualVeterianarian.tag = 0
            
            strVirtualServices = "0"
            UserDefaults.standard.set(strVirtualServices, forKey: "VRvirtual")
        }
    }
    
    
    @objc func veterianrianRegistrationSecondPage() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
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
                    "VBusinessAddress"  :   String(cell.txtStreetAddress.text!),
                    "VBSuite"           :   String(cell.txtSuit.text!),
                    "countryId"         :   String(self.strCountryId),
                    "countryName"       :   String(cell.txtCountry.text!),
                    "VState"            :   String(cell.txtState.text!),
                    "stateId"           :   String(self.strStateId),
                    "Vcity"             :   String(cell.txtCity.text!),
                    "VZipcode"          :   String(cell.txtZipcode.text!),
                    "VEmail"            :   String(cell.txtEmail.text!),
                    "typeOfBusiness"    :   String(addAllStrings),
                    "MessageChat"       :   String(saveChatFunc),
                    "videoChat"         :   String(saveVideoFunc),
                    "AudioChat"         :   String(saveAudioFunc),
                    "YearInBusiness"    :   String(cell.txtYearsInBusinessExperience.text!),
                    "VPhone"            :   String(cell.txtPhone.text!),
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
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
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
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! BusinessAddressTableCell
        
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


extension BusinessAddress: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BusinessAddressTableCell = tableView.dequeueReusableCell(withIdentifier: "BusinessAddressTableCell")
            as! BusinessAddressTableCell
        
        cell.backgroundColor = .clear
        
        cell.btnNext.addTarget(self, action: #selector(nextClickMethod), for: .touchUpInside)
        
        cell.btnChat.addTarget(self, action: #selector(chatClickMethod), for: .touchUpInside)
        cell.btnAudio.addTarget(self, action: #selector(audioClickMethod), for: .touchUpInside)
        cell.btnVideo.addTarget(self, action: #selector(videoClickMethod), for: .touchUpInside)
        
        strClinicHospital   = "0"
        strMobileClinic     = "0"
        strVirtualServices  = "0"
        
        strStateId = "0"
        strCountryId = "0"
        cell.txtPhone.delegate = self
        cell.txtZipcode.delegate = self
       
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: cell.txtStreetAddress, placeHolder: "Street address*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSuit, placeHolder: "Suite", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtCity, placeHolder: "City*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtState, placeHolder: "State*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtZipcode, placeHolder: "Zipcode*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtCountry, placeHolder: "Country*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtPhone, placeHolder: "Phone Number*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtEmail, placeHolder: "Email address*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtYearsInBusinessExperience, placeHolder: "Years in Business*", cornerRadius: 20, color: .white)
        
        
        /****** FINISH BUTTON *********/
        Utils.buttonDR(button: cell.btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        cell.txtStreetAddress.delegate = self
        cell.txtSuit.delegate = self
        cell.txtCity.delegate = self
        cell.txtState.delegate = self
        cell.txtZipcode.delegate = self
        cell.txtCountry.delegate = self
        cell.txtPhone.delegate = self
        cell.txtEmail.delegate = self
        cell.txtYearsInBusinessExperience.delegate = self
       
        cell.btnState.addTarget(self, action: #selector(stateListWb), for: .touchUpInside)
        cell.btnCountry.addTarget(self, action: #selector(countryListPopup(_:)), for: .touchUpInside)
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        print(person) //
            
            cell.btnCountry.isUserInteractionEnabled = false
            cell.txtCountry.text = (person["countryName"] as! String)
            cell.txtCountry.isUserInteractionEnabled = false
            
            self.strCountryId = "\(person["countryId"]!)"
            
        }
         
        // cell.btnNext.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 800
        
    }
}
class BusinessAddressTableCell: UITableViewCell {
    
    
    
    @IBOutlet weak var txtStreetAddress:UITextField!
    @IBOutlet weak var txtSuit:UITextField!
    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtZipcode:UITextField!  {
        didSet {
            txtZipcode.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtCountry:UITextField!
    @IBOutlet weak var txtPhone:UITextField!  {
        didSet {
            txtPhone.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtYearsInBusinessExperience:UITextField!   {
        didSet {
            txtYearsInBusinessExperience.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var btnNext:UIButton!
    
    @IBOutlet weak var btnClinicOrHospital:UIButton!
    @IBOutlet weak var btnMobilClinic:UIButton!
    @IBOutlet weak var btnVirtualVeterianarian:UIButton!
    
    @IBOutlet weak var btnCountry:UIButton!
    @IBOutlet weak var btnState:UIButton!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
