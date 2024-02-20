//
//  EditProfile.swift
//  RiteVet
//
//  Created by evs_SSD on 1/8/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import BottomPopup
import CRNotifications

class EditProfile: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    var str_pet_data:String!
    var str_other_data:String!
    var str_pet_parent_apple_pay_show:String! = "0"
    
    var str_admin_approved_pet:String!
    var str_admin_approved_other:String!
    
    let cellReuseIdentifier = "editProfileTableCell"
    
    // bottom view popup
    
    var height: CGFloat = 600 // height
    
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    // string for cell
    var strUsername:String!
    var strEmail:String!
    var strPhoneNumber:String!
    var strAddress:String!
    var strCountry:String!
    var strState:String!
    var strCity:String!
    var strZipcode:String!
    
    // country id string
    var strMySelectedCountryId:String!
    // state id string
    var strMySelectedStateId:String!
    
    var imgUploadYesOrNo:String!
    
    // image
    var imageStr:String!
    var imgData:Data!
    
    var str_user_select:String! = "0"
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "EDIT PROFILE"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        
        
        
        imgUploadYesOrNo = "0"
        
        // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        
        self.sideBarMenu()
        
        
        strUsername = ""
        strEmail = ""
        strPhoneNumber = ""
        strAddress = ""
        strCountry = ""
        strState = ""
        strCity = ""
        strZipcode = ""
        
        serverValue()
    }
    @objc func sideBarMenu() {
            if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
                revealViewController().rearViewRevealWidth = 300
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
    }
    @objc func serverValue() {
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             // print(person)
            // (person["fullName"] as! String)
            /*
             ["city": Dishant Rajput Vendor,
             "other": ,
             "lastName": ,
             "VEmail": ,
             "VBusinessAddress": ,
             "role": Member,
             "fullName": Dishant Rajput,
             "VTaxID": ,
             "Vcity": ,
             "email": abcd@gmail.com,
             "deviceToken": f7y1QHHeFGw:APA91bHCVg4ZKgG9BTTWjGa2zuLevyly_k5O9uoQCcPIwL8NEIhTflRINIhI2pr3xdr_Knh73LKQ8xMFmmkwofvXX7IHyNlEOjaMnyfHcfdkrGR0NmsWD8yciVTnOnNtd4UuLC2jgldf,
             "VZipcode": ,
             "socialId": ,
             "Imaging": ,
             "mobileClicnic": ,
             "firebaseId": noFirebaseId,
             "VBSuite": ,
             "categoryId": ,
             "VAstate": ,
             "VLastName": ,
             "TotalCartProduct": 0,
             "VLicenseNo": ,
             "device": Android,
             "BankName": ,
             "typeOfPets": ,
             "BImage": ,
             "ACName": ,
             "AccountNo": ,
             "Freelance": ,
             "countryId": 5,
             "zipCode": 9966,
             "RoutingNo": ,
             "VFirstName": ,
             "estimatePrice": ,
             "Specialization": ,
             "socialType": ,
             "address": hunijininin,
             "VPhone": ,
             "image": ,
             "stateName": Andorra la Vella,
             "VBusinessName": ,
             "biography": ,
             "FixedTraditional": ,
             "YearInBusiness": ,
             "VState": ,
             "userId": 105,
             "contactNumber": 1234567899,
             "countryName": Andorra,
             "TypeOfService": , "digonasticLab": ]
             (lldb)
             */
         //let x : Int = (person["userId"] as! Int)
         //let myString = String(x)
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
            
            cell.txtUsername.text   = (person["fullName"] as! String)
            cell.txtLastUsername.text   = (person["lastName"] as! String)
            cell.txtEmail.text      = (person["email"] as! String)
            cell.txtPhone.text      = (person["contactNumber"] as! String)
            cell.txtAddress.text    = (person["address"] as! String)
            cell.txtCountry.text    = (person["countryName"] as! String)
            cell.txtState.text      = (person["stateName"] as! String)
            cell.txtCity.text       = (person["city"] as! String)
            cell.txtZipcode.text    = (person["zipCode"] as! String)
            cell.txtEmail.isUserInteractionEnabled = false
            
            
            if person["countryId"] is String {
                print("Yes, it's a String")

                self.strMySelectedCountryId = (person["countryId"] as! String)
                
            } else if person["countryId"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (person["countryId"] as! Int)
                let myString2 = String(x2)
                self.strMySelectedCountryId = myString2
            } else {
                print("i am number")
                            
                let temp:NSNumber = person["countryId"] as! NSNumber
                let tempString = temp.stringValue
                self.strMySelectedCountryId = tempString
            }
            
            if person["stateId"] is String {
                print("Yes, it's a String")

                self.strMySelectedStateId = (person["stateId"] as! String)
                
            } else if person["stateId"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (person["stateId"] as! Int)
                let myString2 = String(x2)
                self.strMySelectedStateId = myString2
            } else {
                print("i am number")
                            
                let temp:NSNumber = person["stateId"] as! NSNumber
                let tempString = temp.stringValue
                self.strMySelectedStateId = tempString
            }
            
            
            // strMySelectedCountryId = (person["countryId"] as! Int)
            // strMySelectedStateId = (person["stateId"] as! Int)
            
            cell.imgUploadPhoto.layer.cornerRadius = 60
            cell.imgUploadPhoto.clipsToBounds = true
            
            cell.imgUploadPhoto.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo-500")) // my profile image
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.pet_parent_reg()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // action:
    
    @objc func bottomPopuPview() {
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
        popupVC.height = self.height
        popupVC.topCornerRadius = self.topCornerRadius
        popupVC.presentDuration = self.presentDuration
        popupVC.dismissDuration = self.dismissDuration
        //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
        popupVC.popupDelegate = self
        popupVC.strGetDetails = "countryListFromEdit"
        //popupVC.getArrListOfCategory =
        self.present(popupVC, animated: true, completion: nil)
    }
    
    @objc func btnCountryListWB(_ sender: UIButton) {

        Utils.RiteVetIndicatorShow()
        let urlString = BASE_URL_KREASE
        var parameters:Dictionary<AnyHashable, Any>!
        
                       parameters = [
                                        "action"        :   "countrylist"
                                    ]
                       print("parameters-------\(String(describing: parameters))")
                       
                       AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
                           {
                               response in
                   
                               switch(response.result) {
                               case .success(_):
                                  if let data = response.value {

                                   
                                   let JSON = data as! NSDictionary
                                    // print(JSON)
                                    
                                   var strSuccess : String!
                                   strSuccess = JSON["status"]as Any as? String
                                   
                                   if strSuccess == "success" //true
                                   {
                                    let ar : NSArray!
                                    ar = (JSON["data"] as! Array<Any>) as NSArray
                                    
                                    let defaults = UserDefaults.standard
                                    defaults.set(ar, forKey: "keyCountryListForEditProfile")
        
                                    self.bottomPopuPview()
    
                                    
                                    Utils.RiteVetIndicatorHide()
                                   }
                                   else
                                   {
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
    
    @objc func btnStateListWB(_ sender: UIButton) {
        
        Utils.RiteVetIndicatorShow()
        let urlString = BASE_URL_KREASE
        var parameters:Dictionary<AnyHashable, Any>!
        
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "keyDoneSelectingCountryId")
        {
            
            parameters = [
                "action"        :   "statelist",
                "counttyId"      :   String(myString)
            ]
            defaults.set("", forKey: "keyDoneSelectingCountryId")
            defaults.set(nil, forKey: "keyDoneSelectingCountryId")
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
                        let ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        let defaults = UserDefaults.standard
                        defaults.set(ar, forKey: "keyStateListForEditProfile")
                        
                        
                        self.bottomPopuPviewForState()
                        
                        
                        Utils.RiteVetIndicatorHide()
                    }
                    else
                    {
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
    
    @objc func bottomPopuPviewForState() {
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
    
    @objc func submitEditProfileClickMethod(_ sender:UIButton) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
        
        
        if cell.txtUsername.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else
        if cell.txtEmail.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else
        if cell.txtPhone.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else
        if cell.txtAddress.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else
        if cell.txtCountry.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else
        if cell.txtState.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else
        if cell.txtCity.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else
        if cell.txtZipcode.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        
        else
        {
            
            // imgUploadYesOrNo
            if imgUploadYesOrNo == "1" {
                // yes image upload
                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
                {
                    let x : Int = (person["userId"] as! Int)
                    let myString = String(x)
                    
                    var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                    urlRequest.httpMethod = "POST"
                    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                    
                    // let indexPath = IndexPath.init(row: 0, section: 0)
                    // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
                    
                    //Set Your Parameter
                    let parameterDict = NSMutableDictionary()
                    parameterDict.setValue("editprofile", forKey: "action")
                    parameterDict.setValue(String(myString), forKey: "userId")
                    
                    // Now Execute
                    AF.upload(multipartFormData: { multiPart in
                        for (key, value) in parameterDict {
                            if let temp = value as? String {
                                multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                            }
                            if let temp = value as? Int {
                                multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                            }
                            if let temp = value as? NSArray {
                                temp.forEach({ element in
                                    let keyObj = key as! String + "[]"
                                    if let string = element as? String {
                                        multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                    } else
                                    if let num = element as? Int {
                                        let value = "\(num)"
                                        multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                    }
                                })
                            }
                        }
                        multiPart.append(self.imgData, withName: "image", fileName: "add_club_logo.png", mimeType: "image/png")
                    }, with: urlRequest)
                    .uploadProgress(queue: .main, closure: { progress in
                        //Current upload progress of file
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    .responseJSON(completionHandler: { data in
                        
                        switch data.result {
                            
                        case .success(_):
                            do {
                                
                                let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                                
                                print("Success!")
                                print(dictionary)
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                let JSON = dictionary
                                print(JSON)
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "keyLoginFullData")
                                
                            }
                            catch {
                                // catch error.
                                print("catch error")
                                ERProgressHud.sharedInstance.hide()
                            }
                            break
                            
                        case .failure(_):
                            print("failure")
                            ERProgressHud.sharedInstance.hide()
                            break
                            
                        }
                        
                        
                    })
                    
                }
            }
            else
            {
                // no image upload
                self.uploadDataNotImage()
                
            }
            
        }
    }
    
    @objc func uploadDataNotImage() {
       
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
        
       Utils.RiteVetIndicatorShow()
       let urlString = BASE_URL_KREASE
       var parameters:Dictionary<AnyHashable, Any>!
       
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            
            /*
             @Part("action") RequestBody action,
             @Part("userId") RequestBody userId,
             @Part("fullName") RequestBody fullName,
             @Part("contactNumber") RequestBody contactNumber,
             @Part("device") RequestBody device,
             @Part("address") RequestBody address,
             @Part("city") RequestBody city,
             @Part("countryId") RequestBody country,
             @Part("stateId") RequestBody state,
             @Part("deviceToken") RequestBody deviceToken,
             @Part("role") RequestBody role,
             @Part("zipCode") RequestBody zipCode,
             @Part MultipartBody.Part image
             */
            
            print(strMySelectedStateId as Any)
            if strMySelectedCountryId == nil {
                
            }
            else if strMySelectedCountryId == "0" {
                
            }
            
         let x : Int = (person["userId"] as! Int)
         let myString = String(x)
           parameters = [
                        "action"        :   "editprofile",
                        "userId"        :   String(myString),
                        "contactNumber"  :   String(cell.txtPhone.text!),
                        "address"       :   String(cell.txtAddress.text!),
                        "fullName"      :   String(cell.txtUsername.text!),
                        "lastName"      :   String(cell.txtLastUsername.text!),
                        "device"        :   String("ios"),
                        "city"          :   String(cell.txtCity.text!),
                        "countryId"     :   String(strMySelectedCountryId),
                        "stateId"       :   String(strMySelectedStateId),
                        //"deviceToken"       :   String(cell.txtAddress.text!),
                        //"deviceToken"       :   String("deviceToken"),
                        "zipCode"       :   String(cell.txtZipcode.text!),
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
                    // print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "success" //true
                    {
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        // self.bottomPopuPviewForState()
                        
                        
                        Utils.RiteVetIndicatorHide()
                    }
                    else
                    {
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
    
    @objc func textFieldShouldNotBeEmpty() {
        CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Fields should not be Empty.", dismissDelay: 1.5, completion:{})
    }
    
    @objc func pet_parent_reg() {
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
                    
                    if strSuccess == "success" {
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        self.str_pet_data = (dict["VFirstName"] as! String)
                        
                        //
                        /*if "\(dict["verifyAdmin"]!)" == "1"{
                         self.str_admin_approved_pet = "1" // active
                         
                         } else {
                         self.str_admin_approved_pet = "0" // in active
                         }*/
                        
                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "1"
                            
                        }
                        self.check_vet_reg()
                       
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
    
    @objc func check_vet_reg() {
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
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>

                        self.str_pet_data = (dict["VFirstName"] as! String)
                        
                        //
                        /*if "\(dict["verifyAdmin"]!)" == "1"{
                            self.str_admin_approved_pet = "1" // active

                        } else {
                            self.str_admin_approved_pet = "0" // in active
                        }*/
                        
                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "2"
                            
                        }
                        
                        self.check_vet_reg_other()
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
    
    @objc func check_vet_reg_other() {
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
                             
                        self.str_other_data = (dict["VFirstName"] as! String)
                        
                        /*if "\(dict["verifyAdmin"]!)" == "1"{
                            self.str_admin_approved_other = "1" // active
                        } else {
                            self.str_admin_approved_other = "0" // in active
                        }*/
                        
                        // self.clView.delegate = self
                        // self.clView.dataSource = self
                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "3"
                            
                        }
                        self.set_buttons()
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
    
    @objc func set_buttons() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
        
        print(self.str_user_select as Any)
        
        if (self.str_user_select == "1") {
            
            cell.btn_update_pet_parent.isUserInteractionEnabled = true
            cell.btn_vet_profile.isUserInteractionEnabled = false
            cell.btn_other_pet_Service_provider.isUserInteractionEnabled = false
            
            cell.btn_vet_profile.backgroundColor = .systemGray
            cell.btn_other_pet_Service_provider.backgroundColor = .systemGray
            
        } else if (self.str_user_select == "2") {
            
            cell.btn_update_pet_parent.isUserInteractionEnabled = false
            cell.btn_vet_profile.isUserInteractionEnabled = true
            cell.btn_other_pet_Service_provider.isUserInteractionEnabled = false
            
            cell.btn_update_pet_parent.backgroundColor = .systemGray
            cell.btn_other_pet_Service_provider.backgroundColor = .systemGray
            
        }   else if (self.str_user_select == "3") {
            
            cell.btn_update_pet_parent.isUserInteractionEnabled = false
            cell.btn_vet_profile.isUserInteractionEnabled = false
            cell.btn_other_pet_Service_provider.isUserInteractionEnabled = true
            
            cell.btn_update_pet_parent.backgroundColor = .systemGray
            cell.btn_vet_profile.backgroundColor = .systemGray
            
        } else if (self.str_user_select == "0") {
            
            cell.btn_vet_profile.isUserInteractionEnabled = true
            cell.btn_vet_profile.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            
            cell.btn_update_pet_parent.isUserInteractionEnabled = true
            cell.btn_update_pet_parent.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            
            cell.btn_other_pet_Service_provider.isUserInteractionEnabled = true
            cell.btn_other_pet_Service_provider.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
        /*
        if (self.str_pet_data == "") {
            
            cell.btn_vet_profile.isUserInteractionEnabled = true
            cell.btn_vet_profile.backgroundColor = .systemGray
            
        } else {
            
            if (self.str_admin_approved_pet == "1") {
                cell.btn_vet_profile.isUserInteractionEnabled = true
                cell.btn_vet_profile.backgroundColor = NAVIGATION_BACKGROUND_COLOR
                
            } else {
                cell.btn_vet_profile.isUserInteractionEnabled = false
                cell.btn_vet_profile.backgroundColor = .systemGray
            }
            
        }
        
        
        //
        if (self.str_other_data == "") {
            
            cell.btn_other_pet_Service_provider.isUserInteractionEnabled = true
            cell.btn_other_pet_Service_provider.backgroundColor = .systemGray
            
        } else {
            
            if (self.str_admin_approved_other == "1") {
                cell.btn_other_pet_Service_provider.isUserInteractionEnabled = true
                cell.btn_other_pet_Service_provider.backgroundColor = NAVIGATION_BACKGROUND_COLOR
                
            } else {
                cell.btn_other_pet_Service_provider.isUserInteractionEnabled = false
                cell.btn_other_pet_Service_provider.backgroundColor = .systemGray
            }
            
        }
        */
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
        
        if (textField == cell.txtPhone) {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 10
            
        
       
        }  else {
            
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 30
            
        }
        
    }
    
}

extension EditProfile: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:EditProfileTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! EditProfileTableCell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        Utils.textFieldDR(text: cell.txtUsername, placeHolder: "First Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtLastUsername, placeHolder: "Last Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtEmail, placeHolder: "Email", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtPhone, placeHolder: "Phone Number", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtAddress, placeHolder: "Address", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtCountry, placeHolder: "Country", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtState, placeHolder: "State", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtCity, placeHolder: "City", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtZipcode, placeHolder: "Zipcode", cornerRadius: 20, color: .white)
        
        cell.btnCountry.addTarget(self, action: #selector(btnCountryListWB(_:)), for: .touchUpInside)
        cell.btnState.addTarget(self, action: #selector(btnStateListWB), for: .touchUpInside)
        cell.btnChangePassword.addTarget(self, action: #selector(change_password_click_method), for: .touchUpInside)
        
        
        cell.btn_vet_profile.addTarget(self, action: #selector(vet_profile_click_method), for: .touchUpInside)
        cell.btn_other_pet_Service_provider.addTarget(self, action: #selector(other_pet_click_method), for: .touchUpInside)
        cell.btn_update_pet_parent.addTarget(self, action: #selector(update_pet_click_method), for: .touchUpInside)
        
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "keyDoneSelectingCountryName")
        {
            // print(myString)
            
            cell.txtCountry.text = String(myString)
            cell.txtState.text = ""
            strCountry = String(myString)
            
             defaults.set("", forKey: "keyDoneSelectingCountryName")
             defaults.set(nil, forKey: "keyDoneSelectingCountryName")
        }
        
        if let myString = defaults.string(forKey: "keyDoneSelectingStateName")
        {
            cell.txtState.text = String(myString)
            strState = String(myString)
            
            defaults.set("", forKey: "keyDoneSelectingStateName")
            defaults.set(nil, forKey: "keyDoneSelectingStateName")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imgUploadPhoto.isUserInteractionEnabled = true
        cell.imgUploadPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        cell.btnSubmit.addTarget(self, action: #selector(submitEditProfileClickMethod), for: .touchUpInside)
        
        
        cell.btn_id_proof.addTarget(self, action: #selector(push_to_id_proof_page), for: .touchUpInside)
        
        return cell
    }
    
    @objc func push_to_id_proof_page() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "pet_store_id_proof_id") as? pet_store_id_proof
        
        push!.str_from_edit = "from_edit"
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func vet_profile_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    @objc func other_pet_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRThreeId")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    @objc func update_pet_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetAndParentsInformationId") as? PetAndParentsInformation
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
         //let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.uploadImageOpenActionSheet()
        // Your action
    }
    
    @objc func change_password_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordId") as? ChangePassword
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func uploadImageOpenActionSheet() {
        let alert = UIAlertController(title: "Upload image", message: "Camera or Gallery", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
             self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
             self.openGallery()
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler:{ (UIAlertAction)in
            //print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            //print("completion block")
        })
    }
    @objc func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        imgUploadYesOrNo = "1"
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tbleView.cellForRow(at: indexPath) as! EditProfileTableCell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        cell.imgUploadPhoto.image = image_data // show image on image view
        let imageData:Data = image_data!.pngData()!
        imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        
        imgData = image_data!.jpegData(compressionQuality: 0.2)!
        //print(type(of: imgData))
        //print(imgData)
        
    }
    
    @objc func stepperValueChanged(_ sender: UIButton) {
        // let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        // let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        // let cell = self.tbleView.cellForRow(at: indexPath!) as! EditProfileTableCell
        
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 1200
    }
}

extension EditProfile: UITableViewDelegate
{
    
}

extension EditProfile: BottomPopupDelegate {
    
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

                self.strMySelectedCountryId = myString
                
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
            
            
            
            
            
            self.tbleView.reloadData()
            
            // defaults.set("", forKey: "keyDoneSelectingCountryId")
            // defaults.set(nil, forKey: "keyDoneSelectingCountryId")
        }
        
        // keyDoneSelectingStateName
        if let myString = defaults.string(forKey: "keyDoneSelectingStateName")
        {
             print(myString)
            
            self.tbleView.reloadData()
        }
        
        // state id
        if let myString = defaults.string(forKey: "keyDoneSelectingStateId")
        {
             print(myString)
            
            // convert string to int
            // let a:Int? = Int(myString)
            // strMySelectedStateId = a
            self.strMySelectedStateId = myString
            
            self.tbleView.reloadData()

        }
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
