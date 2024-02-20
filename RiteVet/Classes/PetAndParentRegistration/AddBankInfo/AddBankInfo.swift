//
//  AddBankInfo.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CRNotifications

class AddBankInfo: UIViewController,UITextFieldDelegate {

    let indicator = UIActivityIndicatorView()
    
    var getDictValueOfFirstPage:Dictionary<AnyHashable, Any>!
    // var getDictValueOfCreditCardInfo:Dictionary<AnyHashable, Any>!
    
    //MARK:- SECOND PAGE DATA
    var firstName:String!
    var lastName:String!
    var typeOfPets:String!
    var explainAboutOther:String!
    
    /*
    //MARK:- SECOND PAGE DATA
    var state:String!
    var cvv:String!
    var zipcode:String!
    var nameOfCard:String!
    var creditCardNumber:String!
    var address:String!
    var expiryDate:String!
    var city:String!
    */
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ADD BANK INFO (OPTIONAL)"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var txtYourName:UITextField!
    @IBOutlet weak var txtSelectBank:UITextField!
    @IBOutlet weak var txtBankAccountNumber:UITextField!
    @IBOutlet weak var txtSwitchNumberForAccounts:UITextField!
    @IBOutlet weak var txtRoutingCode:UITextField!
    @IBOutlet weak var txtAccountType:UITextField!
    
    @IBOutlet weak var btnFinish:UIButton!
    @IBOutlet weak var btnSkip:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator.style = .large
        indicator.color = .orange
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.textFieldUI()
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        btnSkip.addTarget(self, action: #selector(petAndParentInformationFinalRegistrationWebservice), for: .touchUpInside)
        btnFinish.addTarget(self, action: #selector(petAndParentInformationFinalRegistrationWebservice), for: .touchUpInside)
        
        /*
         @IBOutlet weak var txtYourName:UITextField!
         @IBOutlet weak var txtSelectBank:UITextField!
         @IBOutlet weak var txtBankAccountNumber:UITextField!
         @IBOutlet weak var txtSwitchNumberForAccounts:UITextField!
         @IBOutlet weak var txtRoutingCode:UITextField!
         @IBOutlet weak var txtAccountType:UITextField!
         */
        
        txtYourName.delegate = self
        txtSelectBank.delegate = self
        txtBankAccountNumber.delegate = self
        txtRoutingCode.delegate = self
        txtAccountType.delegate = self
        txtSwitchNumberForAccounts.delegate = self
        
        //print(getDictValueOfFirstPage as Any)
        //print(getDictValueOfCreditCardInfo as Any)
        
        /*
         Optional([AnyHashable("firstname"): "Dishant", AnyHashable("lastname"): "Rajput", AnyHashable("typeofpets"): "1,3,4,7", AnyHashable("explainaboutotheranimal"): ""])
         Optional([AnyHashable("state"): "DWARKA", AnyHashable("cvv"): "123", AnyHashable("zipcode"): "110075", AnyHashable("nameoncard"): "D RAJPUT", AnyHashable("creditcardnumber"): "1234123412341234", AnyHashable("address"): "FLAT 102", AnyHashable("city"): "DELHI", AnyHashable("expirydate"): "1120"])
         */
        
//        print(getDictValueOfFirstPage["firstname"] as Any)
//        print(getDictValueOfFirstPage["lastname"] as Any)
//        print(getDictValueOfFirstPage["typeofpets"] as Any)
//        print(getDictValueOfFirstPage["explainaboutotheranimal"] as Any)
//
//        print(getDictValueOfCreditCardInfo["state"] as Any)
//        print(getDictValueOfCreditCardInfo["cvv"] as Any)
//        print(getDictValueOfCreditCardInfo["zipcode"] as Any)
//        print(getDictValueOfCreditCardInfo["nameoncard"] as Any)
//        print(getDictValueOfCreditCardInfo["creditcardnumber"] as Any)
//        print(getDictValueOfCreditCardInfo["address"] as Any)
//        print(getDictValueOfCreditCardInfo["city"] as Any)
//        print(getDictValueOfCreditCardInfo["expirydate"] as Any)
        
        

        //MARK:- FIRST PAGE DATA
        firstName           = (getDictValueOfFirstPage["firstname"] as! String)
        lastName            = (getDictValueOfFirstPage["lastname"] as! String)
        typeOfPets          = (getDictValueOfFirstPage["typeofpets"] as! String)
        explainAboutOther   = (getDictValueOfFirstPage["explainaboutotheranimal"] as! String)
        
        //MARK:- SECOND PAGE DATA
        // state               = (getDictValueOfCreditCardInfo["state"] as! String)
        // cvv                 = (getDictValueOfCreditCardInfo["cvv"] as! String)
        // zipcode             = (getDictValueOfCreditCardInfo["zipcode"] as! String)
        // nameOfCard          = (getDictValueOfCreditCardInfo["nameoncard"] as! String)
        // creditCardNumber    = (getDictValueOfCreditCardInfo["creditcardnumber"] as! String)
        // address             = (getDictValueOfCreditCardInfo["address"] as! String)
        // city                = (getDictValueOfCreditCardInfo["city"] as! String)
        // expiryDate          = (getDictValueOfCreditCardInfo["expirydate"] as! String)
        
        
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
    
    //MARK:- TEXT FIELD UI
    @objc func textFieldUI() {
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: txtYourName, placeHolder: "Your Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtSelectBank, placeHolder: "Select Bank", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtBankAccountNumber, placeHolder: "Bank Account Number", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtSwitchNumberForAccounts, placeHolder: "Switch number for accounts outside the US", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtRoutingCode, placeHolder: "Routing Code", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: txtAccountType, placeHolder: "Account Type", cornerRadius: 20, color: .white)
        
        /****** FINISH BUTTON *********/
        Utils.buttonDR(button: btnFinish, text: "FINISH", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        /****** SKIP BUTTON *********/
        Utils.buttonDR(button: btnSkip, text: "SKIP", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
    }
    
    //MARK:- PET AND PARENT REGISTRATION (WEBSERVICE)
    @objc func petAndParentInformationFinalRegistrationWebservice() {
        
        //indicator.startAnimating()
        //self.disableService()
        
        Utils.RiteVetIndicatorShow()
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"                :   "petparentregistration",
                "userId"                :   String(myString),
                "UTYPE"                 :   "1",
                "VFirstName"            :   String(firstName),
                "VLastName"             :   String(lastName),
                "typeOfPets"            :   String(typeOfPets),
                "otherPet"              :   String(explainAboutOther),
                // "cardNo"                :   String(creditCardNumber),
                // "expMon"                :   String(expiryDate),
                // "expYear"               :   String(expiryDate),
                // "CVV"                   :   String(cvv),
                // "VBusinessAddress"      :   String(address),
                // "Vcity"                 :   String(city),
                // "stateId"               :   String(state),
                // "VZipcode"              :   String(zipcode),
                "ACName"                :   String(txtYourName.text!),
                "BankName"              :   String(txtSelectBank.text!),
                "AccountNo"             :   String(txtBankAccountNumber.text!),
                "RoutingNo"             :   String(txtRoutingCode.text!)
            ]
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
                            
                            var strSuccessAlert : String!
                            strSuccessAlert = JSON["msg"]as Any as? String
                            
                            if strSuccess == "success" //true
                            {
                                //self.enableService()
                                
                                self.indicator.stopAnimating()
                                Utils.RiteVetIndicatorHide()
                                CRNotifications.showNotification(type: CRNotifications.success, title: "Hurray!", message:strSuccessAlert!, dismissDelay: 1.5, completion:{})
                                
                                self.pushToDashboard()
                            }
                            else
                            {
                                self.indicator.stopAnimating()
                                Utils.RiteVetIndicatorHide()
                                //self.enableService()
                            }
                            
                        }

                        case .failure(_):
                            print("Error message:\(String(describing: response.error))")
                            self.indicator.stopAnimating()
                            Utils.RiteVetIndicatorHide()
                            //self.enableService()
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
    
    @objc func pushToDashboard() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
}
