//
//  VeterinarianRegistration.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView

class VeterinarianRegistration: UIViewController {

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
    
    var myFirstName:String!
    var myLastName:String!
    var myLicenceNumber:String!
    var myState:String!
    var myBusinessName:String!
    var myBusinessLicenceNumber:String!
    var myIenTax:String!
    
    var dictgetAllDataVeterinarianFromSubscriptionPage:NSDictionary!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.UIdesignOfVeterinaryRegistration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextClickMethod() {
        
//        let someDict:[String:String] = [
//                    "firstname":String(txtFirstName.text!),
//                    "lastname":String(txtLastName.text!),
//                    "licencenumber":String(txtVeterinaryLicenceNumber.text!),
//                    "state":String(txtState.text!),
//                    "businessname":String(txtBusinessName.text!),
//                    "businesslicencenumber":String(txtBusinessLicenceNumber.text!),
//                    "ientaxid":String(txtIENTAXidNumber.text!),
//        ]
//        print(someDict as Any)
        
        self.veterianrianRegistrationFirstPage()
        
        
    }
    
    // MARK:-
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
        
        
        // get all value
        //print(dictgetAllDataVeterinarianFromSubscriptionPage as Any)
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
        
        if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any]
        {
            //print(person as Any)
            let fName : String = (person["VFirstName"] as! String)
            let lName : String = (person["VLastName"] as! String)
            let strLicenceNumber : String = (person["VLicenseNo"] as! String)
            let strState : String = (person["stateName"] as! String)
            let strBusinessName : String = (person["VBusinessName"] as! String)
            let strBusinessLicnceNumber : String = (person["BusinessLicenseNo"] as! String)
            let strIenTaxId : String = (person["VTaxID"] as! String)
            
            self.myFirstName = String(fName)
            self.myLastName = String(lName)
            self.myLicenceNumber = String(strLicenceNumber)
            self.myState = String(strState)
            self.myBusinessName = String(strBusinessName)
            self.myBusinessLicenceNumber = String(strBusinessLicnceNumber)
            self.myIenTax = String(strIenTaxId)
            
            self.txtFirstName.text = myFirstName
            self.txtLastName.text = myLastName
            self.txtVeterinaryLicenceNumber.text = myLicenceNumber
            self.txtState.text = myState
            self.txtBusinessName.text = myBusinessName
            self.txtBusinessLicenceNumber.text = myBusinessLicenceNumber
            self.txtIENTAXidNumber.text = myIenTax
        }
        
    }
    
    
    
    @objc func veterianrianRegistrationFirstPage() {
           Utils.RiteVetIndicatorShow()
           
               let urlString = BASE_URL_KREASE
               
               var parameters:Dictionary<AnyHashable, Any>!
           
        /*
         action: petparentregistration
         userId:
         UTYPE:
         TypeOfService:
         otherService:
         typeOfPets:
         otherPet:
         VFirstName:
         VMiddleName
         VLastName:
         VLicenseNo:
         VState:
         VBusinessName:
         BusinessLicenseNo:
         VTaxID:
         VBusinessAddress:
         VBSuite:
         countryId
         stateId:
         Vcity:
         VZipcode:
         VPhone:
         VEmail:
         latitude:
         longitude:
         */
        
        /*
         self.myFirstName = String(fName)
         self.myLastName = String(lName)
         self.myLicenceNumber = String(strLicenceNumber)
         self.myState = String(strState)
         self.myBusinessName = String(strBusinessName)
         self.myBusinessLicenceNumber = String(strBusinessLicnceNumber)
         self.myIenTax = String(strIenTaxId)
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
           
            //if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any] {
                   parameters = [
                       "action"         :   "petparentregistration",
                       "userId"         :   String(myString),
                       "UTYPE"          :   "2",
                       //"TypeOfService"   :   "",
                       //"otherService"    :   "",
                       //"typeOfPets"      :   "",
                       //"otherPet"        :   "",
                       "VFirstName"      :   String(self.txtFirstName.text!),
                       "VMiddleName"      :  "",
                       "VLastName"        :  String(self.txtLastName.text!),
                       "VLicenseNo" :  String(self.txtVeterinaryLicenceNumber.text!),
                       "VState"    : String(self.txtState.text!),
                       "VBusinessName"     : String(self.txtBusinessName.text!),
                       "BusinessLicenseNo"  : String(self.txtBusinessLicenceNumber.text!),
                       "VTaxID"            : String(self.txtIENTAXidNumber.text!),
                       //"VBusinessAddress"     :   (person["address"] as! String),
                       //"VBSuite"            :   (person["VBSuite"] as! String),
                       //"countryId"         :   (person["countryName"] as! String),
                       //"stateId"            :   (person["VState"] as! String),
                       //"Vcity"              :   (person["Vcity"] as! String),
                       //"VZipcode"         :   (person["VZipcode"] as! String),
                       //"VPhone"             : (person["VPhone"] as! String),
                       //"VEmail"            : (person["VEmail"] as! String),
                       //"latitude"          : "",
                       //"longitude"         : "",
                       
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
                               //print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               if strSuccess == "success" //true
                               {
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                                
                                
                                 let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BusinessAddressId") as? BusinessAddress
                                 self.navigationController?.pushViewController(push!, animated: true)
                                 
                                
                                
                                   
                                Utils.RiteVetIndicatorHide()
                               }
                               else
                               {
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
    
    
    
    
}
