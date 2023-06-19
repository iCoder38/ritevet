//
//  VRThree.swift
//  RiteVet
//
//  Created by Apple on 12/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import BottomPopup

class VRThree: UIViewController, UITextFieldDelegate {
    
    var dictPetRegistration:NSDictionary!
    
    var arrVeterinarianRegistrationMultipleLicence:NSMutableArray = []
    
    var height: CGFloat = 600 // height
    
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "OTHER PET SERVICE PROVIDERS"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // self.tbleView.delegate = self
            // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var btnPlus:UIButton!
    
    var strStateId:String!
    var strStateName:String!
    var clickedButtonTag:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnPlus.addTarget(self, action: #selector(plusClickMethod), for: .touchUpInside)
        // btnNext.addTarget(self, action: #selector(nextClickMethod), for: .touchUpInside)
        
        Utils.buttonDR(button: btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        self.btnNext.isHidden = true
        
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
    
    @objc func plusClickMethod() {
        
        self.btnPlus.tag += 1
        
        // print(self.btnPlus.tag as Any)
        
        // print(self.arrVeterinarianRegistrationMultipleLicence as Any)
        
        // print(self.arrVeterinarianRegistrationMultipleLicence.lastObject as Any)
        
        /*let item = self.arrVeterinarianRegistrationMultipleLicence.lastObject as? [String:Any]
        // print(item!["licenceNo"] as! String)
        
        if item!["licenceNo"] as! String == "" {
          
            let alert = UIAlertController(title: "Error!", message: "Please enter Licence No. or State name.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {*/
         
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VRThreeTableCell
            
        let myDictionary: [String:String] = [
              
            "stateId"       : String(""),
            "stateName"     : String(""),
            "licenceNo"     : String("")
        ]
        
        self.arrVeterinarianRegistrationMultipleLicence.add(myDictionary)
            
        cell.clView.reloadData()
        cell.clView.scrollToItem(at:IndexPath(item: self.btnPlus.tag, section: 0), at: .right, animated: true)
            
        // cell.lblIndexCount.text = String(self.btnPlus.tag+1)+"/"+String(self.btnPlus.tag+1)
        cell.lblIndexCount.text = String(self.btnPlus.tag+1)+"/"+String(self.arrVeterinarianRegistrationMultipleLicence.count)
        // }
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VRThreeTableCell
       
        let visibleRect = CGRect(origin: cell.clView.contentOffset, size: cell.clView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = cell.clView.indexPathForItem(at: visiblePoint)
        
        // print(visibleIndexPath?[0] as Any)
        // print(visibleIndexPath![1] as Any)
        
        // cell.lblIndexCount.text = String(visibleIndexPath![1]+1)+"/"+String(self.btnPlus.tag+1)
        cell.lblIndexCount.text = String(visibleIndexPath![1]+1)+"/"+String(self.arrVeterinarianRegistrationMultipleLicence.count)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
            
            // print(textField.text as Any)
            // print(textField.tag as Any)
            
            // print(textField.tag+1 as Any)
            
            // print(self.arrVeterinarianRegistrationMultipleLicence[textField.tag] as Any)
            
            // print(self.arrVeterinarianRegistrationMultipleLicence as Any)
        
        // print(self.arrVeterinarianRegistrationMultipleLicence[textField.tag] as Any)
        
        self.arrVeterinarianRegistrationMultipleLicence.removeObject(at: textField.tag)
        // print(self.arrVeterinarianRegistrationMultipleLicence[textField.tag] as Any)
        
        // print(self.arrVeterinarianRegistrationMultipleLicence[textField.tag] as Any)
            
        let myDictionary: [String:String] = [
               
            "stateId"       : String(textField.tag),
            "stateName"     : String(""),
            "licenceNo"     : String(textField.text!)
        ]
         
        self.arrVeterinarianRegistrationMultipleLicence.insert(myDictionary, at: textField.tag)
             
            // print(self.arrVeterinarianRegistrationMultipleLicence as Any)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
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
        textField.resignFirstResponder();
        
        self.view.endEditing(true)
        
        return true
    }
    
    @objc func welcomeWB() {
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
                        
                         var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        self.dictPetRegistration = dict as NSDictionary
                        
                        // create screen
                        // self.makeInitialScreenFirstThreeIndex(dictFromServer: dict as NSDictionary)
                        
                        var ar : NSArray!
                        ar = (dict["multipleLicense"] as! Array<Any>) as NSArray
                        print(ar as Any)
                        
                        if ar.count == 0 {
                            
                            let myDictionary: [String:String] = [
                                  
                                "stateId"       : "",
                                "stateName"     : "",
                                "licenceNo"     : ""
                            ]
                                
                            self.arrVeterinarianRegistrationMultipleLicence.add(myDictionary)
                            
                        } else {
                            
                            for index in 0..<ar.count {
                                
                                let item = ar[index] as? [String:Any]
                                print(item as Any)
                                 
                                // let x : Int = (item!["stateId"] as! Int)
                                // let myString = String(x)
                                // state
                                if item!["stateId"] is String {
                                    print("Yes, it's a String")

                                    // self.strStateId = (item!["stateId"] as! String)
                                    
                                    let myDictionary: [String:String] = [
                                      
                                        "stateId"       : (item!["stateId"] as! String),
                                        "stateName"     : (item!["stateName"] as! String),
                                        "licenceNo"     : (item!["licenceNo"] as! String)
                                    ]
                                    
                                    self.arrVeterinarianRegistrationMultipleLicence.add(myDictionary)
                                    
                                } else if item!["stateId"] is Int {
                                    print("It is Integer")
                                                
                                    let x2 : Int = (item!["stateId"] as! Int)
                                    let myString2 = String(x2)
                                    // self.strStateId = myString2
                                    
                                    let myDictionary: [String:String] = [
                                      
                                        "stateId"       : myString2,
                                        "stateName"     : (item!["stateName"] as! String),
                                        "licenceNo"     : (item!["licenceNo"] as! String)
                                    ]
                                    
                                    
                                    self.arrVeterinarianRegistrationMultipleLicence.add(myDictionary)
                                    
                                } else {
                                    print("i am number")
                                                
                                    let temp:NSNumber = item!["stateId"] as! NSNumber
                                    let tempString = temp.stringValue
                                    // self.strStateId = tempString
                                    
                                    let myDictionary: [String:String] = [
                                      
                                        "stateId"       : tempString,
                                        "stateName"     : (item!["stateName"] as! String),
                                        "licenceNo"     : (item!["licenceNo"] as! String)
                                    ]
                                    
                                    self.arrVeterinarianRegistrationMultipleLicence.add(myDictionary)
                                    
                                }
                            }
                        }
                        
                        //  print(self.arrVeterinarianRegistrationMultipleLicence as Any)
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        
                        self.tbleView.reloadData()
                        
                        let indexPath = IndexPath.init(row: 0, section: 0)
                        let cell = self.tbleView.cellForRow(at: indexPath) as! VRThreeTableCell
                        
                        cell.txtFirstName.delegate = self
                        cell.txtMiddleName.delegate = self
                        cell.txtLastName.delegate = self
                        
                        cell.txtBusinessName.delegate = self
                        cell.txtBusinessLicenceNumber.delegate = self
                        cell.txtIENTAXidNumber.delegate = self
                        
                        cell.txtFirstName.text = (self.dictPetRegistration["VFirstName"] as! String)
                        cell.txtMiddleName.text = (self.dictPetRegistration["VmiddleName"] as! String)
                        cell.txtLastName.text = (self.dictPetRegistration["VLastName"] as! String)
                        
                        cell.txtBusinessName.text = (self.dictPetRegistration["VBusinessName"] as! String)
                        cell.txtBusinessLicenceNumber.text = (self.dictPetRegistration["BusinessLicenseNo"] as! String)
                        cell.txtIENTAXidNumber.text = (self.dictPetRegistration["VTaxID"] as! String)
                        
                        cell.lblIndexCount.text = String("1")+"/"+String(self.arrVeterinarianRegistrationMultipleLicence.count)
                        
                        self.stateListWB()
                        
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

    /*
     
     */
    
    
    @objc func submitDataToServer() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VRThreeTableCell
        
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             cell.txtFirstName.text = (self.dictPetRegistration["VFirstName"] as! String)
             cell.txtMiddleName.text = (self.dictPetRegistration["VmiddleName"] as! String)
             cell.txtLastName.text = (self.dictPetRegistration["VLastName"] as! String)
             
             cell.txtBusinessName.text = (self.dictPetRegistration["VBusinessName"] as! String)
             cell.txtBusinessLicenceNumber.text = (self.dictPetRegistration["BusinessLicenseNo"] as! String)
             cell.txtIENTAXidNumber.text = (self.dictPetRegistration["VTaxID"] as! String)
             */
            //if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any] {
            
            // print(self.arrVeterinarianRegistrationMultipleLicence as Any)
            
            // convert array into JSONSerialization
            let paramsArray = self.arrVeterinarianRegistrationMultipleLicence
            let paramsJSON = JSON(paramsArray)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
            
            parameters = [
                "action"          :   "petparentregistration",
                "userId"          :   String(myString),
                "UTYPE"           :   "3",
                
                "VFirstName"    :   String(cell.txtFirstName.text!),
                "VmiddleName"   :   String(cell.txtMiddleName.text!),
                "VLastName"     :   String(cell.txtLastName.text!),
                
                "VBusinessName" :   String(cell.txtBusinessName.text!),
                "BusinessLicenseNo" :   String(cell.txtBusinessLicenceNumber.text!),
                "VTaxID"        :   String(cell.txtIENTAXidNumber.text!),
                  
                "Multilicenses" : paramsString
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
                        
                        // var dict: Dictionary<AnyHashable, Any>
                        // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                        Utils.RiteVetIndicatorHide()
                                
                            // let defaults = UserDefaults.standard
                            // defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                                
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BusinessAddressTwoId")
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
    
    @objc func stateListWB() {
        
        var str_country_id:String!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person) //
            
            str_country_id = "\(person["countryId"]!)"
            
        }
        
        // Utils.RiteVetIndicatorShow()
        let urlString = BASE_URL_KREASE
        var parameters:Dictionary<AnyHashable, Any>!
        
        let defaults = UserDefaults.standard
        // if let myString = defaults.string(forKey: "keyDoneSelectingCountryId") {
        
        parameters = [
            "action"        : "statelist",
            "counttyId"     : String(str_country_id)
        ]
        defaults.set("", forKey: "keyDoneSelectingCountryId")
        defaults.set(nil, forKey: "keyDoneSelectingCountryId")
        // }
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
                        let ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        let defaults = UserDefaults.standard
                        defaults.set(ar, forKey: "keyStateListForEditProfile")
                        
                        
                        // self.bottomPopuPviewForState()
                        
                        
                        Utils.RiteVetIndicatorHide()
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
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
    
    @objc func bottomPopuPviewForState(_ sender:UIButton) {
        let btn:UIButton = sender
        print(btn.tag as Any)
        
        self.clickedButtonTag = btn.tag
        
        // print(self.arrVeterinarianRegistrationMultipleLicence[btn.tag] as Any)
        
        
            guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
            popupVC.height = self.height
            popupVC.topCornerRadius = self.topCornerRadius
            popupVC.presentDuration = self.presentDuration
            popupVC.dismissDuration = self.dismissDuration
            //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
            popupVC.popupDelegate = self
            popupVC.strGetDetails = "stateListFromEdit"
            //popupVC.getArrListOfCategory =
            self.present(popupVC, animated: true, completion: nil)
            
        
        
        
    }
    
    
}

extension VRThree: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
        // one
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VRThreeTableCell
        
        // let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        // let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        // let cell = self.tbleView.cellForRow(at: indexPath!) as! EditProfileTableCell
        
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "keyDoneSelectingCountryName")
        {
             print(myString)
            
            self.tbleView.reloadData()
            // defaults.set("", forKey: "keyDoneSelectingCountryName")
            // defaults.set(nil, forKey: "keyDoneSelectingCountryName")
        }
        /*
         // country id string
         var strMySelectedCountryId:String!
         // state id string
         var strMySelectedStateId:String!
         */
        
        if let myString = defaults.string(forKey: "keyDoneSelectingCountryId") {
             print(myString)
            
            // convert string to int
            // let a:Int? = Int(myString)
            // strMySelectedCountryId = a
            
            
            // if myString is String {
                print("Yes, it's a String")

                // self.strMySelectedCountryId = myString
                
            // }
            /*/else if myString is Int {
                print("It is Integer")
                            
                let x2 : Int = (myString as! Int)
                let myString2 = String(x2)
                self.strMySelectedCountryId = myString2
            } else {
                print("i am number")
                            
                let temp:NSNumber = myString as! NSNumber
                let tempString = temp.stringValue
                self.strMySelectedCountryId = tempString
            }*/
            
            
            
            
            
            // self.tbleView.reloadData()
            
            // defaults.set("", forKey: "keyDoneSelectingCountryId")
            // defaults.set(nil, forKey: "keyDoneSelectingCountryId")
        }
        
        // keyDoneSelectingStateName
        if let myString = defaults.string(forKey: "keyDoneSelectingStateName") {
             print(myString)
            
            // self.tbleView.reloadData()
            
            // var strStateId:String!
            // var strStateName:String!
            
            self.strStateName = myString
            
            defaults.set("", forKey: "keyDoneSelectingStateName")
            defaults.set(nil, forKey: "keyDoneSelectingStateName")
        }
        
        // state id
        if let myString = defaults.string(forKey: "keyDoneSelectingStateId") {
             print(myString)
            
            // convert string to int
            // let a:Int? = Int(myString)
            // strMySelectedStateId = a
            
            // self.strMySelectedStateId = myString
            
            // self.tbleView.reloadData()

            print(cell.lblIndexCount.text as Any)
            
            // let array = String(cell.lblIndexCount.text!).components(separatedBy: "/")
            // print(array as Any)
            
            // let a:Int? = Int(array[0])
            
            print(self.arrVeterinarianRegistrationMultipleLicence[self.clickedButtonTag] as Any)
            
            
            let item = self.arrVeterinarianRegistrationMultipleLicence[self.clickedButtonTag] as? [String:Any]
            print(item as Any)
            
            self.arrVeterinarianRegistrationMultipleLicence.removeObject(at: self.clickedButtonTag)
                  
            self.strStateId = myString
            print(self.strStateId as Any)
            print(self.strStateName as Any)
            
            let myDictionary: [String:String] = [
                   
                "stateId"       : String(self.strStateId),
                "stateName"     : self.strStateName,
                "licenceNo"     : String(item!["licenceNo"] as! String)
            ]
             
            self.arrVeterinarianRegistrationMultipleLicence.insert(myDictionary, at: self.clickedButtonTag)
            
            cell.clView.reloadData()
            // self.arrVeterinarianRegistrationMultipleLicence.removeObject(at: self.clickedButtonTag)
            // print(self.arrVeterinarianRegistrationMultipleLicence as Any)
           
            
            defaults.set("", forKey: "keyDoneSelectingStateId")
            defaults.set(nil, forKey: "keyDoneSelectingStateId")
        }
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}

// MARK:- COLLECTION VIEW -
extension VRThree: UICollectionViewDelegate {
    
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
        
        let index = collectionView.tag
        print(index as Any)
        
        /*if index == 0 {
            return self.arrListOfAllPhotos.count
        } else {*/
        return self.arrVeterinarianRegistrationMultipleLicence.count
        // }
        
    }
    
    //Write Delegate Code Here
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vRTwoCollectionCell", for: indexPath as IndexPath) as! VRTwoCollectionCell
       
        // MARK:- CELL CLASS -
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.6
        
        let index = collectionView.tag
        print(index as Any)
        
        cell.txtLicenceNumber.tag = indexPath.row
        cell.txtStateName.tag = indexPath.row
        
        cell.txtLicenceNumber.delegate = self
        cell.txtStateName.delegate = self
        
        let item = arrVeterinarianRegistrationMultipleLicence[indexPath.row] as? [String:Any]
        cell.txtLicenceNumber.text  = (item!["licenceNo"] as! String)
        cell.txtStateName.text      = (item!["stateName"] as! String)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteClickMethod), for: .touchUpInside)
        
        cell.btnStateName.tag = indexPath.row
        cell.btnStateName.addTarget(self, action: #selector(bottomPopuPviewForState), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnDeleteClickMethod(_ sender:UIButton) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VRThreeTableCell
        
        if self.arrVeterinarianRegistrationMultipleLicence.count == 1 {
            
            let alert = UIAlertController(title: "Alert!", message: "You can not delete Last Item.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let btn:UIButton = sender
            print(btn.tag as Any)
            print(self.btnPlus.tag as Any)
            
            // print(self.arrVeterinarianRegistrationMultipleLicence[btn.tag] as Any)
            
            let item = self.arrVeterinarianRegistrationMultipleLicence[btn.tag] as? [String:Any]
            // print(item as Any)
            
            let strLicenceNumber:String = (item!["licenceNo"] as! String)
            let strStateName:String = (item!["stateName"] as! String)
            
            let strFullMessage:String = "Are you sure you want to delete this \n\n Licence No. : "+strLicenceNumber+"\n\n State Name : "+strStateName
            
            let alert = UIAlertController(title: "Alert!", message: String(strFullMessage),preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Yes, Delete", style: UIAlertAction.Style.default, handler: { _ in
                
                // self.btnPlus.tag-=1
                
                // print(cell.lblIndexCount.text as Any)
                // print(self.arrVeterinarianRegistrationMultipleLicence[btn.tag] as Any)
                
                // print(self.arrVeterinarianRegistrationMultipleLicence[btn.tag] as Any)
                self.arrVeterinarianRegistrationMultipleLicence.removeObject(at: btn.tag)
                // print(self.arrVeterinarianRegistrationMultipleLicence as Any)
                
                // cell.clView.reloadData()
                // self.tbleView.reloadData()
                cell.lblIndexCount.text = String(btn.tag)+"/"+String(self.arrVeterinarianRegistrationMultipleLicence.count)
                self.tbleView.reloadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.destructive, handler: { _ in
                //Cancel Action
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
}

extension VRThree: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
        
        let index = collectionView.tag
        print(index as Any)
    }
}

extension VRThree: UICollectionViewDelegateFlowLayout {
    
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
        sizes = CGSize(width: self.view.frame.size.width, height: 100)
        // }
        
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
            return 0
        
        
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
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

// MARK:- TABLE VIEW -
extension VRThree: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if let cell = cell as? VRThreeTableCell {

            cell.clView.dataSource = self
            cell.clView.delegate = self
            cell.clView.tag = indexPath.section
            cell.clView.reloadData()

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
        /*
        let item = self.arrListOfAllMyOrders[section] as? [String:Any]
        var ar : NSArray!
        ar = (item!["SubCat"] as! Array<Any>) as NSArray
        
        return ar.count
        */
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         let cell:VRThreeTableCell = tableView.dequeueReusableCell(withIdentifier: "vRThreeTableCell") as! VRThreeTableCell
          
        // let item = self.arrListOfAllMyOrders[indexPath.section] as? [String:Any]
        // print(item as Any)
        
        // var ar : NSArray!
        // ar = (item!["SubCat"] as! Array<Any>) as NSArray
        
        // let item1 = ar[indexPath.row] as? [String:Any]
        
        // cell.lblTitle.text = (item1!["name"] as! String)
        
        //
        
        
        
        cell.btnNext.addTarget(self, action: #selector(submitDataToServer), for: .touchUpInside)
        
        cell.backgroundColor = .clear
        // cell.accessoryType = .disclosureIndicator
        
        cell.backgroundColor = .clear
        
        cell.txtFirstName.delegate = self
        cell.txtMiddleName.delegate = self
        cell.txtLastName.delegate = self
        
        cell.txtBusinessName.delegate = self
        cell.txtBusinessLicenceNumber.delegate = self
        cell.txtIENTAXidNumber.delegate = self
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        // let item = self.arrListOfAllMyOrders[indexPath.section] as? [String:Any]
        // var ar : NSArray!
        // ar = (item!["SubCat"] as! Array<Any>) as NSArray
        
        // let item1 = ar[indexPath.row] as? [String:Any]
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConversationStartersDetailsId") as? ConversationStartersDetails
        // push!.dictGetConversationStarters = item1 as NSDictionary?
        // self.navigationController?.pushViewController(push!, animated: true)
        
        //
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 1000 // UITableView.automaticDimension
    }
    
}

extension VRThree: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? VRThreeTableCell {
            // cachedPosition[indexPath] = cell.collectionView.contentOffset
            print(cell.clView.tag as Any)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // let item = self.arrListOfAllMyOrders[section] as? [String:Any]
        // print(item as Any)
        
        // if section == 0
        
        let headerView = UIView.init(frame: CGRect.init(x: 60, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        
         /*if section == 0 {*/
            label.text = "  "+"PET SERVICE PROVIDERS"
         /*} else {
             label.text = "  "+"Recommended Photographer Near You:"//(item!["fullName"] as! String)
         }*/
        
        label.textAlignment = .center
        
        label.backgroundColor = .white
        label.layer.cornerRadius = 0
        label.clipsToBounds = true
        label.font = UIFont.init(name: "Avenir Next Bold", size: 16)
        label.textColor = .black

        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}

