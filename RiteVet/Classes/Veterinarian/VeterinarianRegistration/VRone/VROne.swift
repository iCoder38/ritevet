//
//  VROne.swift
//  RiteVet
//
//  Created by Apple on 09/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VROne: UIViewController, UITextFieldDelegate {

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
    
    @IBOutlet weak var btnPlus:UIButton!
    
    @IBOutlet weak var txtFirstName:UITextField!
    @IBOutlet weak var txtMiddleName:UITextField!
    @IBOutlet weak var txtLastName:UITextField!
    @IBOutlet weak var txtVeterinaryLicenceNumber:UITextField!
    @IBOutlet weak var txtState:UITextField!
    @IBOutlet weak var txtBusinessName:UITextField!
    @IBOutlet weak var txtBusinessLicenceNumber:UITextField!
    @IBOutlet weak var txtIENTAXidNumber:UITextField!
    
    var arrVeterinarianRegistrationMainArray:NSMutableArray = []
    var arrVeterinarianRegistrationBase:NSMutableArray = []
    
    var arrVeterinarianRegistrationCountryAndState:NSMutableArray = []
    
    var arrVeterinarianRegistrationLastThree:NSMutableArray = []
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // self.tbleView.delegate = self
            // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var btnNext:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnPlus.addTarget(self, action: #selector(plusClickMethod), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(nextClickMethod), for: .touchUpInside)
        
        Utils.buttonDR(button: btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        self.tbleView.separatorColor = .clear
        
        self.welcomeWB()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // self.UIdesignOfVeterinaryRegistration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     let jsonObject: [Any]  = [
         [
              "type_id": singleStructDataOfCar.typeID,
              "model_id": singleStructDataOfCar.modelID,
              "transfer": savedDataTransfer,
              "hourly": savedDataHourly,
              "custom": savedDataReis,
              "device_type":"iOS"
         ]
     ]
     */
    @objc func makeInitialScreenFirstThreeIndex(dictFromServer:NSDictionary) {
        // print(dictFromServer as Any)
        
        let strFirstName:String     = (dictFromServer["VFirstName"] as! String)
        let strMiddleName:String    = (dictFromServer["VmiddleName"] as! String)
        let strLastName:String      = (dictFromServer["VLastName"] as! String)
        
        let strBusinessName:String     = (dictFromServer["VBusinessName"] as! String)
        let strBusinesslicenceNumber:String    = (dictFromServer["BusinessLicenseNo"] as! String)
        let strTax:String      = (dictFromServer["VTaxID"] as! String)
        
        let myDictionary: [Any] = [
            [
                "title"         : "First Name",
                "title2"         : "State Name",
                "subTitle"      : strFirstName,
                "cellHeight"    : "single",
                "placeholder"    : "first name...",
                "placeholder2"   : "state name...",
                "licenceNo"    : "",
                "stateId"    : "",
                "stateName"       : "",
                "licenceCellCount": "",
                "businessName":strBusinessName,
                "businessLicenceNumber":"",
                "taxIdNumber":""
                ],[
                    "title"         : "Middle Name",
                    "title2"         : "State Name",
                    "subTitle"      : strMiddleName,
                    "cellHeight"    : "single",
                    "placeholder"    : "middle name...",
                    "placeholder2"   : "state name...",
                    "licenceNo"    : "",
                    "stateId"    : "",
                    "stateName"       : "",
                    "licenceCellCount": "",
                    "businessName":"",
                    "businessLicenceNumber":strBusinesslicenceNumber,
                    "taxIdNumber":""
                ],[
                    "title"         : "Last Name",
                    "title2"         : "State Name",
                    "subTitle"      : strLastName,
                    "cellHeight"    : "single",
                    "placeholder"    : "last name...",
                    "placeholder2"   : "state name...",
                    "licenceNo"    : "",
                    "stateId"    : "",
                    "stateName"       : "",
                    "licenceCellCount": "",
                    "businessName":"",
                    "businessLicenceNumber":"",
                    "taxIdNumber":strTax],
            [
                "title"         : "Business Name",
                "title2"         : "State Name",
                "subTitle"      : strBusinessName,
                "cellHeight"    : "single",
                "placeholder"    : "business name",
                "placeholder2"   : "state name...",
                "licenceNo"    : "",
                "stateId"    : "",
                "stateName"       : "",
                "licenceCellCount": "",
                "businessName":strBusinessName,
                "businessLicenceNumber":"",
                "taxIdNumber":""
                ],[
                    "title"         : "Business Licence Number",
                    "title2"         : "State Name",
                    "subTitle"      : strBusinesslicenceNumber,
                    "cellHeight"    : "single",
                    "placeholder"    : "business licence number...",
                    "placeholder2"   : "state name...",
                    "licenceNo"    : "",
                    "stateId"    : "",
                    "stateName"       : "",
                    "licenceCellCount": "",
                    "businessName":"",
                    "businessLicenceNumber":strBusinesslicenceNumber,
                    "taxIdNumber":""
                ],[
                    "title"         : "IEN / TAX ID Number",
                    "title2"         : "State Name",
                    "subTitle"      : strTax,
                    "cellHeight"    : "single",
                    "placeholder"    : "last name...",
                    "placeholder2"   : "state name...",
                    "licenceNo"    : "",
                    "stateId"    : "",
                    "stateName"       : "",
                    "licenceCellCount": "",
                    "businessName":"",
                    "businessLicenceNumber":"",
                    "taxIdNumber":strTax]
        ]
       
        // var res = [[String: String]]()
        // res.append(myDictionary)
        
        self.arrVeterinarianRegistrationBase.addObjects(from: myDictionary)
        
        // print(self.arrVeterinarianRegistrationBase as Any)
        
        self.arrVeterinarianRegistrationMainArray.addObjects(from: self.arrVeterinarianRegistrationBase as! [Any])
        // print(self.arrVeterinarianRegistrationMainArray as Any)
        
        self.countryAndState(dictGetMultipleLicence: dictFromServer)
    
    }
    
    @objc func countryAndState(dictGetMultipleLicence:NSDictionary) {
        print(dictGetMultipleLicence as Any)
        
        var ar : NSArray!
        ar = (dictGetMultipleLicence["multipleLicense"] as! Array<Any>) as NSArray
        print(ar as Any)
        
        // self.arrListOfPetsDataFromServer.addObjects(from: ar as! [Any])
        
        if ar.count == 0 {
            
            let myDictionary: [Any] = [
                [
                    "title"         : "Licence No.",
                    "title2"         : "State Name",
                    "subTitle"      : "iAmState",
                    "cellHeight"    : "double",
                    "placeholder"    : "licence no...",
                    "placeholder2"   : "state name...",
                    "licenceNo"     : "",
                    "stateId"       : "",
                    "stateName"       : "",
                    "licenceCellCount": "1",
                    "businessName":"",
                    "businessLicenceNumber":"",
                    "taxIdNumber":""
                    ]
            ]
           
            self.arrVeterinarianRegistrationCountryAndState.addObjects(from: myDictionary)
            
        } else {
        
            for index in 0..<ar.count {
               
                let item = ar[index] as! [String:Any]
                print(item as Any)
                
                let x : Int = (item["stateId"] as! Int)
                let myString = String(x)
                
                let myDictionary: [Any] = [
                    [
                        "title"         : "Licence No.",
                        "title2"         : "State Name",
                        "subTitle"      : "iAmState",
                        "cellHeight"    : "double",
                        "placeholder"   : "licence no...",
                        "placeholder2"   : "state name...",
                        "licenceNo"     : (item["licenceNo"] as! String),
                        "stateId"       : String(myString),
                        "stateName"     : (item["stateName"] as! String),
                        "licenceCellCount": String(index),
                        "businessName":"",
                        "businessLicenceNumber":"",
                        "taxIdNumber":""
                    ]
                ]
               
                self.arrVeterinarianRegistrationCountryAndState.addObjects(from: myDictionary)
                 
            }
            
            // print(self.arrVeterinarianRegistrationCountryAndState as Any)
        }
        
        self.arrVeterinarianRegistrationMainArray.addObjects(from: self.arrVeterinarianRegistrationCountryAndState as! [Any])
        // print(self.arrVeterinarianRegistrationMainArray as Any)
        
        
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        self.tbleView.reloadData()
        // self.makeInitialScreenLastThreeIndex(dictFromServer: dictGetMultipleLicence)
    }
    
    @objc func makeInitialScreenLastThreeIndex(dictFromServer:NSDictionary) {
        // print(dictFromServer as Any)
        
        let strBusinessName:String     = (dictFromServer["VBusinessName"] as! String)
        let strBusinesslicenceNumber:String    = (dictFromServer["BusinessLicenseNo"] as! String)
        let strTax:String      = (dictFromServer["VTaxID"] as! String)
        
        let myDictionary: [Any] = [
            [
                "title"         : "Business Name",
                "title2"         : "State Name",
                "subTitle"      : strBusinessName,
                "cellHeight"    : "single",
                "placeholder"    : "business name",
                "placeholder2"   : "state name...",
                "licenceNo"    : "",
                "stateId"    : "",
                "stateName"       : "",
                "licenceCellCount": "",
                "businessName":strBusinessName,
                "businessLicenceNumber":"",
                "taxIdNumber":""
                ],[
                    "title"         : "Business Licence Number",
                    "title2"         : "State Name",
                    "subTitle"      : strBusinesslicenceNumber,
                    "cellHeight"    : "single",
                    "placeholder"    : "business licence number...",
                    "placeholder2"   : "state name...",
                    "licenceNo"    : "",
                    "stateId"    : "",
                    "stateName"       : "",
                    "licenceCellCount": "",
                    "businessName":"",
                    "businessLicenceNumber":strBusinesslicenceNumber,
                    "taxIdNumber":""
                ],[
                    "title"         : "IEN / TAX ID Number",
                    "title2"         : "State Name",
                    "subTitle"      : strTax,
                    "cellHeight"    : "single",
                    "placeholder"    : "last name...",
                    "placeholder2"   : "state name...",
                    "licenceNo"    : "",
                    "stateId"    : "",
                    "stateName"       : "",
                    "licenceCellCount": "",
                    "businessName":"",
                    "businessLicenceNumber":"",
                    "taxIdNumber":strTax]
        ]
       
        // var res = [[String: String]]()
        // res.append(myDictionary)
        
        self.arrVeterinarianRegistrationLastThree.addObjects(from: myDictionary)
        
        // print(self.arrVeterinarianRegistrationBase as Any)
        
        self.arrVeterinarianRegistrationMainArray.addObjects(from: self.arrVeterinarianRegistrationLastThree as! [Any])
        // print(self.arrVeterinarianRegistrationMainArray as Any)
        
        // self.countryAndState(dictGetMultipleLicence: dictFromServer)
    
        DispatchQueue.main.async {
            let index = IndexPath(row: self.arrVeterinarianRegistrationMainArray.count-1, section: 0)
            self.tbleView.scrollToRow(at: index, at: .bottom, animated: true)
        }
        
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        self.tbleView.reloadData()
        
        
        
    }
    
    @objc func nextClickMethod() {
        
        /*var addAllStrings = strClinicHospital+","+strMobileClinic+","+strVirtualServices
        addAllStrings = addAllStrings.replacingOccurrences(of: "0,", with: "", options: [.regularExpression, .caseInsensitive])
        addAllStrings = addAllStrings.replacingOccurrences(of: ",0", with: "", options: [.regularExpression, .caseInsensitive])*/
        
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
                               print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               if strSuccess == "success" {
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                                
                                 let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BusinessAddressId") as? BusinessAddress
                                         
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
    
    
    // MARK:- WB -
    func welcomeWB() {
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
                    // print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        // create screen
                        self.makeInitialScreenFirstThreeIndex(dictFromServer: dict as NSDictionary)
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

extension VROne: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVeterinarianRegistrationMainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VROneTableCell = tableView.dequeueReusableCell(withIdentifier: "vROneTableCell") as! VROneTableCell
        
        cell.backgroundColor = .clear
        
        let item = self.arrVeterinarianRegistrationMainArray[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        /*
         
         */
        if item!["subTitle"] as! String == "iAmState" {
            
            cell.lblTitle.text = (item!["title"] as! String)
            cell.lblTitle2.text = (item!["title2"] as! String)
            cell.txtTitle.placeholder = (item!["placeholder"] as! String)
            cell.txtTitle2.placeholder = (item!["placeholder2"] as! String)
            cell.txtTitle.text = (item!["licenceNo"] as! String)
            cell.txtTitle2.text = (item!["stateName"] as! String)
            
            cell.btnPlus.isHidden = true
            cell.btnMinus.isHidden = false
            cell.viewBG.backgroundColor = UIColor.init(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1)
            
        }/* else if item!["subTitle"] as! String == "lastThree" {
            
            cell.lblTitle.text = (item!["title"] as! String)
            cell.txtTitle.placeholder = (item!["placeholder"] as! String)
            cell.txtTitle.text = (item!["subTitle"] as! String)
            
            // hidden data
            cell.lblTitle2.text = (item!["title2"] as! String)
            cell.txtTitle2.text = (item!["stateName"] as! String)
            
            cell.btnPlus.isHidden = true
            cell.btnMinus.isHidden = true
            cell.viewBG.backgroundColor = .clear
            
        } */else {
            
            cell.lblTitle.text = (item!["title"] as! String)
            cell.txtTitle.placeholder = (item!["placeholder"] as! String)
            cell.txtTitle.text = (item!["subTitle"] as! String)
            
            // hidden data
            cell.lblTitle2.text = (item!["title2"] as! String)
            cell.txtTitle2.text = (item!["stateName"] as! String)
            
            cell.btnPlus.isHidden = true
            cell.btnMinus.isHidden = true
            cell.viewBG.backgroundColor = .clear
            
        }
        
        // licenceCellCount
        
        // cell.btnPlus.tag = indexPath.row
        cell.btnMinus.tag = indexPath.row
       
        // cell.btnPlus.addTarget(self, action: #selector(plusClickMethod), for: .touchUpInside)
        cell.btnMinus.addTarget(self, action: #selector(minusClickMethod), for: .touchUpInside)
        
        cell.txtTitle.tag = indexPath.row
        cell.txtTitle.delegate = self
        cell.txtTitle2.delegate = self
        
        return cell
    }
    
    @objc func plusClickMethod(_ sender:UIButton) {
        let btnP:UIButton = sender
        print(btnP.tag as Any)
        
        /*print(self.arrVeterinarianRegistrationMainArray.count as Any)
        let item = self.arrVeterinarianRegistrationMainArray[self.arrVeterinarianRegistrationMainArray.count+1] as? [String:Any]
        print(item as Any)
        
        if item!["licenceNo"] as! String == "" {
            
            let alert = UIAlertController(title: "Error", message: "Please Enter licence number.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if item!["stateName"] as! String == "" {
            
            let alert = UIAlertController(title: "Error", message: "Please Enter State Name.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            */
        
        // print(self.arrVeterinarianRegistrationMainArray.lastObject)
        
        // let item = self.arrVeterinarianRegistrationMainArray.lastObject as? [String:Any]
        
        /*if item!["licenceNo"] as! String == "" {
            
            let alert = UIAlertController(title: "Error", message: "Licence should not be Empty",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if item!["stateName"] as! String == "" {
            
            let alert = UIAlertController(title: "Error", message: "State name should not be Empty",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {*/
            
            let myDictionary: [String:String] = [
                    "title"             : "Licence No.",
                    "title2"            : "State Name",
                    "subTitle"          : "iAmState",
                    "cellHeight"        : "double",
                    "placeholder"       : "licence no...",
                    "placeholder2"      : "state name...",
                    "licenceNo"         : "",
                    "stateId"           : "",
                    "stateName"         : "",
                    "businessName"      :"",
                    "businessLicenceNumber":"",
                    "taxIdNumber"       :""
            ]
            
            self.arrVeterinarianRegistrationMainArray.add(myDictionary)
            
        // }
       
        DispatchQueue.main.async {
            let index = IndexPath(row: self.arrVeterinarianRegistrationMainArray.count-1, section: 0)
            self.tbleView.scrollToRow(at: index, at: .bottom, animated: true)
        }
        
        self.tbleView.reloadData()
        
            
        // }
        
        
        // print(self.arrVeterinarianRegistrationMainArray as Any)
        // self.arrVeterinarianRegistrationMainArray.addObjects(from: self.arrVeterinarianRegistrationCountryAndState as! [Any])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            print("TextField did begin editing method called")
    }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            print("TextField did end editing method called\(textField.text!)")
            
            if textField.tag == 0 {
                self.arrVeterinarianRegistrationMainArray.removeObject(at: textField.tag)
                let strTitleName:String!
                let strPlaceholderName:String!
                
                
                strTitleName = "First Name"
                strPlaceholderName = "first name..."
                
                let myDictionary: [String:String] = [
                    
                    "title"         : strTitleName,
                    "title2"        : "State Name",
                    "subTitle"      : String(textField.text!),
                    "cellHeight"    : "single",
                    "placeholder"   : strPlaceholderName,
                    "placeholder2"  : "state name...",
                    "licenceNo"     : "",
                    "stateId"       : "",
                    "stateName"     : "",
                    "licenceCellCount" : "",
                    "businessName" :"",
                    "businessLicenceNumber" :"",
                    "taxIdNumber" :""
                ]
            
                self.arrVeterinarianRegistrationMainArray.insert(myDictionary, at: textField.tag)
                
            } else if textField.tag == 1 {
                self.arrVeterinarianRegistrationMainArray.removeObject(at: textField.tag)
                let strTitleName:String!
                let strPlaceholderName:String!
                
                strTitleName = "Middle Name"
                strPlaceholderName = "middle name..."
                
                let myDictionary: [String:String] = [
                    
                        "title"         : strTitleName,
                        "title2"         : "State Name",
                        "subTitle"      : String(textField.text!),
                        "cellHeight"    : "single",
                        "placeholder"    : strPlaceholderName,
                        "placeholder2"   : "state name...",
                        "licenceNo"    : "",
                        "stateId"    : "",
                        "stateName"       : "",
                        "licenceCellCount": "",
                        "businessName":"",
                        "businessLicenceNumber":"",
                        "taxIdNumber":""
                        ]
            
                self.arrVeterinarianRegistrationMainArray.insert(myDictionary, at: textField.tag)
                
            } else if textField.tag == 2 {
                self.arrVeterinarianRegistrationMainArray.removeObject(at: textField.tag)
                let strTitleName:String!
                let strPlaceholderName:String!
                
                strTitleName = "Last Name"
                strPlaceholderName = "last name..."
                
                let myDictionary: [String:String] = [
                    
                        "title"         : strTitleName,
                        "title2"         : "State Name",
                        "subTitle"      : String(textField.text!),
                        "cellHeight"    : "single",
                        "placeholder"    : strPlaceholderName,
                        "placeholder2"   : "state name...",
                        "licenceNo"    : "",
                        "stateId"    : "",
                        "stateName"       : "",
                        "licenceCellCount": "",
                        "businessName":"",
                        "businessLicenceNumber":"",
                        "taxIdNumber":""
                        ]
            
                self.arrVeterinarianRegistrationMainArray.insert(myDictionary, at: textField.tag)
                
            } else if textField.tag == 3 {
                self.arrVeterinarianRegistrationMainArray.removeObject(at: textField.tag)
                let strTitleName:String!
                let strPlaceholderName:String!
                
                strTitleName = "Business Name"
                strPlaceholderName = "business name..."
                
                let myDictionary: [String:String] = [
                    
                        "title"         : strTitleName,
                        "title2"         : "State Name",
                        "subTitle"      : String(textField.text!),
                        "cellHeight"    : "single",
                        "placeholder"    : strPlaceholderName,
                        "placeholder2"   : "state name...",
                        "licenceNo"    : "",
                        "stateId"    : "",
                        "stateName"       : "",
                        "licenceCellCount": "",
                        "businessName":"",
                        "businessLicenceNumber":"",
                        "taxIdNumber":""
                        ]
            
                self.arrVeterinarianRegistrationMainArray.insert(myDictionary, at: textField.tag)
                
            } else if textField.tag == 4 {
                self.arrVeterinarianRegistrationMainArray.removeObject(at: textField.tag)
                let strTitleName:String!
                let strPlaceholderName:String!
                
                strTitleName = "Business Licence Number"
                strPlaceholderName = "business licence number..."
                
                let myDictionary: [String:String] = [
                    
                        "title"         : strTitleName,
                        "title2"         : "State Name",
                        "subTitle"      : String(textField.text!),
                        "cellHeight"    : "single",
                        "placeholder"    : strPlaceholderName,
                        "placeholder2"   : "state name...",
                        "licenceNo"    : "",
                        "stateId"    : "",
                        "stateName"       : "",
                        "licenceCellCount": "",
                        "businessName":"",
                        "businessLicenceNumber":"",
                        "taxIdNumber":""
                        ]
            
                self.arrVeterinarianRegistrationMainArray.insert(myDictionary, at: textField.tag)
                
            } else if textField.tag == 5 {
                self.arrVeterinarianRegistrationMainArray.removeObject(at: textField.tag)
                let strTitleName:String!
                let strPlaceholderName:String!
                
                strTitleName = "IEN / TAX ID Number"
                strPlaceholderName = "ien / tax id number"
                
                let myDictionary: [String:String] = [
                    
                        "title"         : strTitleName,
                        "title2"         : "State Name",
                        "subTitle"      : String(textField.text!),
                        "cellHeight"    : "single",
                        "placeholder"    : strPlaceholderName,
                        "placeholder2"   : "state name...",
                        "licenceNo"    : "",
                        "stateId"    : "",
                        "stateName"       : "",
                        "licenceCellCount": "",
                        "businessName":"",
                        "businessLicenceNumber":"",
                        "taxIdNumber":""
                        ]
            
                self.arrVeterinarianRegistrationMainArray.insert(myDictionary, at: textField.tag)
                
            } else {
                
               // multiple data array
                print("\("text field tag id is : ")",textField.tag as Any)
                
                print(textField.text as Any)
                
                self.arrVeterinarianRegistrationMainArray.removeObject(at: textField.tag)
                
                let myDictionary: [String:String] = [
                    "title"             : "Licence No.",
                    "title2"            : "State Name",
                    "subTitle"          : "iAmState",
                    "cellHeight"        : "double",
                    "placeholder"       : "licence no...",
                    "placeholder2"      : "state name...",
                    "licenceNo"         : String(textField.text!),
                    "stateId"           : "",
                    "stateName"         : "",
                    "businessName"      :"",
                    "businessLicenceNumber":"",
                    "taxIdNumber"       :""
                ]
                
                print(myDictionary as Any)
                
                self.arrVeterinarianRegistrationMainArray.insert(myDictionary, at: textField.tag)
                
                 self.tbleView.reloadData()
                
            }
            
            // self.tbleView.reloadData()
        }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
            
        print(textField.tag as Any)
            
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
            // textField.resignFirstResponder();
        return true
    }
    
    @objc func minusClickMethod(_ sender:UIButton) {
        let btnM:UIButton = sender
        print(btnM.tag as Any)
        
        print(self.arrVeterinarianRegistrationMainArray.count)
        
        // let item = self.arrVeterinarianRegistrationMainArray[btnM.tag] as? [String:Any]
        // print(item as Any)
        
        /*let myDictionary: [Any] = [
            [
                "title"         : (item!["title"] as! String),
                "title2"         : (item!["title2"] as! String),
                "subTitle"      : (item!["subTitle"] as! String),
                "cellHeight"    : (item!["cellHeight"] as! String),
                "placeholder"    : (item!["placeholder"] as! String),
                "placeholder2"   : (item!["placeholder2"] as! String),
                "licenceNo"     : (item!["licenceNo"] as! String),
                "stateId"       : (item!["stateId"] as! String),
                "stateName"       : (item!["stateName"] as! String)
                ]
        ]*/
        
        // self.arrVeterinarianRegistrationCountryAndState.removeObject(at: btnM.tag)
        
        /*print(self.arrVeterinarianRegistrationCountryAndState.count)
        
        if self.arrVeterinarianRegistrationCountryAndState.count == 1 {
            
            let alert = UIAlertController(title: "Alert", message: "You can not delete last item.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.arrVeterinarianRegistrationMainArray.removeObject(at: btnM.tag)
            // self.arrVeterinarianRegistrationCountryAndState.count = self.arrVeterinarianRegistrationCountryAndState.count-1
        }
        
        print(self.arrVeterinarianRegistrationMainArray as Any)*/
        
        /*let item = self.arrVeterinarianRegistrationMainArray[btnM.tag] as? [String:Any]
        let myDictionary: [Any] = [
            [
                "title"         : (item!["title"] as! String),
                "title2"         : (item!["title2"] as! String),
                "subTitle"      : (item!["subTitle"] as! String),
                "cellHeight"    : (item!["cellHeight"] as! String),
                "placeholder"    : (item!["placeholder"] as! String),
                "placeholder2"   : (item!["placeholder2"] as! String),
                "licenceNo"     : (item!["licenceNo"] as! String),
                "stateId"       : (item!["stateId"] as! String),
                "stateName"       : (item!["stateName"] as! String)
                ]
        ]
        self.arrVeterinarianRegistrationCountryAndState.removeObjects(in: myDictionary)
        
        print(self.arrVeterinarianRegistrationCountryAndState as Any)
        print(self.arrVeterinarianRegistrationMainArray as Any)*/
        
        if self.arrVeterinarianRegistrationMainArray.count == 7 {
            
            let alert = UIAlertController(title: "Alert", message: "You can not delete last item.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.arrVeterinarianRegistrationMainArray.removeObject(at: btnM.tag)
        }
        
        
        self.tbleView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = self.arrVeterinarianRegistrationMainArray[indexPath.row] as? [String:Any]
        if item!["cellHeight"] as! String == "single" {
            return 90
        } /*else if item!["cellHeight"] as! String == "three" {
            return 200
        }*/ else {
            return 200
        }
        
    }
}

extension VROne: UITableViewDelegate {
    
}
