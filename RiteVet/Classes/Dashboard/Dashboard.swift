//
//  Dashboard.swift
//  RiteVet
//
//  Created by Apple  on 26/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFAudio
import StoreKit
import JKCalendar
import FirebaseCore
import FirebaseFirestoreInternal

// c0S4VOesvUkmqYk4DdPKNP:APA91bGtpV4tHt9QROmHgtJOyulnSJ53ced-uYvjMtkvSbKs2wWMZfHO49p_bmjpemFob2ly2r_pWupAMncnwiOqGCTvZ8ogiiATVwJBTOa5usE2FPRw8vGQY5yDiEvEFPU0EO_aPDtE

class Dashboard: UIViewController, SKPaymentTransactionObserver {
    
    var str_pet_data:String!
    var str_other_data:String!
    
    var str_pet_parent_apple_pay_show:String! = "0"
    
    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var theValueString: String!
    
    var strSchoolId: String!
    var strSchoolFullStackId: String!
    var strMySchoolNameIs: String!
    var strAdmissionStatusIs: String!
    var strAdmissionStatusComentIs: String!
    
    //var arrListOfDashboardItems:Array<Any>!
    
    //var razorpay: Razorpay! // payment
    var strThePrice:String!
    
    var myDeviceTokenIs:String!
    
     var arrListOfDashboardItems = ["one","one","one","one","one","one"]
    
    var arrListOfDashboardImages = ["pet","register","other","drequest","free","pet-sore"]
    
    // var arrListOfDashboardItems:NSMutableArray! = []
    
    var str_admin_approved_pet:String!
    var str_admin_approved_other:String!
    
    var str_user_select:String! = "0"
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btn_call:UIButton!
    
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "WELCOME"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var clView: UICollectionView! {
        didSet
        {
            //collection
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
            screenHeight = screenSize.height
            
            // Do any additional setup after loading the view, typically from a nib
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            
            
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            clView!.backgroundColor = .clear
        }
    }
    var audioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*print(Date.getCurrentDate())
        print(TimeZone.current.abbreviation()!)
        print(TimeZone.current)
        
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        print(localTimeZoneAbbreviation)
        
        let timeZone = TimeZone.current.identifier
        print(timeZone)
        
        print(TimeZone.current.localizedName(for: .standard, locale: .current))
        
        print(TimeZone(abbreviation: "UTC+07")!.localizedName(for: .shortStandard, locale: nil)!) // => GMT+7)
        
        print(TimeZone.current.offsetFromUTC()) // output is +0530
        print(TimeZone.current.currentTimezoneOffset()) // output is "+05:30"*/

        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        
        self.sideBarMenu()
        
        self.askPermissionIfNeeded()
        self.updateLoginUserDeviceToken()
        //
        self.pet_parent_WB()
        //
        self.btn_call.isHidden = true
        self.btn_call.addTarget(self, action: #selector(dummy_video_call_click_method), for: .touchUpInside)
        
        
        let clickSound = URL(fileURLWithPath: Bundle.main.path(forResource: "inOrOut", ofType: "mp3")!)
        do {
            
            print("===============")
            print("SPEAKER IS TRUE")
            print("===============")
            
            self.audioPlayer = try AVAudioPlayer(contentsOf: clickSound)
            self.audioPlayer.play()
            // self.agoraKit.setEnableSpeakerphone(true)
            
        } catch {
            
        }
        
        
        
    }
    
    @objc func dummy_video_call_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "outgoing_video_call_id") as? outgoing_video_call
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    /*@objc func dummy_call() {
        print("Call button pressed")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let uuid = UUID().uuidString
            print(uuid)
            
            Firestore.firestore().collection(audio_call_collection_path).addDocument(data: [
                
                "audio_call_id" : String(uuid),
                "type"          : "audio_call",
                "call_status"   : "calling",
                
            ]){
                (error) in
                
                if error != nil {
                    print("=====================================================================")
                    print("=====================================================================")
                    print("ERROR : \(error!)")
                    print("=====================================================================")
                    print("=====================================================================")
                } else {
                    print("=====================================================================")
                    print("=====================================================================")
                    print("FIREBASE : DATA STORE SUCCESSFULLY. NOW SEND NOTIFICATION TO RECEIVER")
                    print("=====================================================================")
                    print("=====================================================================")
                    
                    // get data now
                    self.getDataForAudioCallSystem(getAudioCallId: String(uuid))
                }
            }
            
        }
        
        
    }*/
    
    /*func getDataForAudioCallSystem(getAudioCallId:String) {
        
        var token_1:String!
        var token_2:String!
        
        // when run in 7
        token_1 = "e4XnHFi20kNNgG_3d7zy9z:APA91bGsiU8ei0kE9V95CVkdXzSNcTXyGCLu3_CAPApnPNbSGDlr5qJOmgsu-NDmdvYnJ-Ik3sD7A3YDPX9lQntmpMQsHFCyrO1YKGsIldlo7oS9iJcnhAHhzi6VKPIy6LgFz6b52vH_"
        
        
        // when run in max
        token_2 = "ecqQOjjqkEjfjjORhKxl6D:APA91bGIYKKo6oxPpC8eJ-Rnf2coZWMVRd-rz7INSLMxuD4c0SOrtvbPoJdFETfNTmJMEy42LfxHBdzTC15WRL7QS3wG30uPi-6DPqFHVyDBxLz17Nl5QULao1umDSE_ejLEv5D5pPoB"
        
        self.send_notification_for_audio_call(receiver_userId: "dummy_id",
                                              receiver_name: "receiver_name",
                                              receiver_device_name: "iOS",
                                              receiver_device_image: "receiver_image",
                                              receiver_device_token: String(token_2),
                                              audio_call_id: String(getAudioCallId))
        
    }*/

    /*func send_notification_for_audio_call(receiver_userId:String,
                                          receiver_name:String,
                                          receiver_device_name:String,
                                          receiver_device_image:String,
                                          receiver_device_token:String,
                                          
                                          audio_call_id:String) {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            parameters = [
                "action"        : "sendnotification",
                
                "Token"        : String(receiver_device_token), // receiver's token
                
                // "Token" : "cjHxmGICoUm3uOCsdPX1LQ:APA91bGazY6JeiN7gF0cNAvVhPMq52G9fLwMhpQbNCgjpUPd9ANuIrGJymi18nxHysGUey3ni0hZw_jvBFDzgwsdNgLmcMBCcN5C9c5FbHTtI9GAFYaZyM7rE5wR3kXKuP8V43DSgAEq",
                    
                "message"       : (person["fullName"] as! String)+" is calling", // custom message
                "device"        : "iOS", // receiver's device
                
                // receiver's custom data
                "receiver_name"     : String(receiver_name),
                "receiver_id"       : String(receiver_userId),
                "receiver_image"    : String(receiver_device_image),
                
                // sender's custom data
                "sender_id"             : String(myString),
                "sender_name"           : (person["fullName"] as! String),
                "sender_device"         : "iOS",
                "sender_device_token"   : (person["deviceToken"] as! String),
                "sender_image"          : (person["image"] as! String),
                
                //
                "audio_call_id" : String(audio_call_id),
                
                //
                "type"          : "audio_call",
            ]
            
            print("parameters-------\(String(describing: parameters))")
            // "135+133"
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                [self]
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
                            
                            /*var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>*/
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "audio_outgoing_call_id") as? audio_outgoing_call
                            //push!.dictGetAllDataForAudioCall = dict as NSDictionary
                            push!.channel_id_for_audio_call = String(audio_call_id)
                            self.navigationController?.pushViewController(push!, animated: true)
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
        
    }*/
    
    func getCurrentTimeZone() -> String {
            let localTimeZoneAbbreviation: Int = TimeZone.current.secondsFromGMT()
            let gmtAbbreviation = (localTimeZoneAbbreviation / 60)
            return "\(gmtAbbreviation)"
    }
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction])
    
    {
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    
                    // if you successfully purchased an item
                    print("Product Purchased")
                    // print(transactions.)
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    // Handle the purchase
                    UserDefaults.standard.set(true , forKey: "purchased")
                    
                    break;
                case .failed:
                    
                    ERProgressHud.sharedInstance.hide()
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    let alertController = UIAlertController(title: "Alert", message: "Something went wrong. Please try again after some time.", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                        //
                        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
                        self.navigationController?.pushViewController(push, animated: true)*/
                        //
                    }
                    
                    alertController.addAction(cancel)
                    self.present(alertController, animated: true, completion:nil)
                    
                    break;
                    
                case .restored:
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    print("Already Purchased");
                    SKPaymentQueue.default().restoreCompletedTransactions()
                                        
                    // Handle the purchase
                    UserDefaults.standard.set(true , forKey: "purchased")
                    //adView.hidden = true

                    break;
                    
                default:
                    break;
                }
            }
        }
        
    }
    
    
    
    func askPermissionIfNeeded() {
        let session = AVAudioSession.sharedInstance()
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                } else {
                    print("not granted")
                }
            })
        }
    }
    
    @objc func updateLoginUserDeviceToken() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // Create UserDefaults
            let defaults = UserDefaults.standard
            if let myString = defaults.string(forKey: "key_my_device_token") {
                self.myDeviceTokenIs = myString
                
            }
            else {
                self.myDeviceTokenIs = "111111111111111111111"
            }
            
            // ecqQOjjqkEjfjjORhKxl6D:APA91bGIYKKo6oxPpC8eJ-Rnf2coZWMVRd-rz7INSLMxuD4c0SOrtvbPoJdFETfNTmJMEy42LfxHBdzTC15WRL7QS3wG30uPi-6DPqFHVyDBxLz17Nl5QULao1umDSE_ejLEv5D5pPoB
            
            parameters = [
                "action"        : "editprofile",
                "userId"        : myString,
                "deviceToken"   : String(self.myDeviceTokenIs),
                "device"        : "iOS",
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
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: "keyLoginFullData")
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
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    
    
    @objc func uploadClickMethod() {
        /*
        let hideUnhide = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CategoryId") as? Category
        self.navigationController?.pushViewController(hideUnhide!, animated: true)
         */
    }
    
    
    func welcomeWB() {
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //self.disableService()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"        :   "welcome"
        ]
        
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
                        
                       
                        
                    }
                    else {
                        //                                   self.indicator.stopAnimating()
                        //                                   self.enableService()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
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
    
    @objc func pet_parent_WB() {
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
                        
                        /*if (dict["expiryDate"] as! String) != "" {
                            
                            //
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            //
                            let diffInDays = NSCalendar.current.dateComponents([.day], from: Date(), to: dateFormatter.date(from: (dict["expiryDate"] as! String))!).day
                            print(diffInDays as Any)
                            
                            if ("\(diffInDays!)") == "1" {
                                self.str_pet_parent_apple_pay_show = "1"
                            } else if ("\(diffInDays!)") == "0" {
                                print("stop and apple pay")
                                self.str_pet_parent_apple_pay_show = "1"
                            } else if ("\(diffInDays!)") < "0" {
                                print("stop and apple pay")
                                self.str_pet_parent_apple_pay_show = "1"
                            } else {
                                self.str_pet_parent_apple_pay_show = "0"
                            }
                            
                            print(self.str_pet_parent_apple_pay_show as Any)
                            
                        }*/
                        
                        //
                        /*if "\(dict["verifyAdmin"]!)" == "1" {
                            self.str_admin_approved_pet = "1" // active

                        } else {
                            self.str_admin_approved_pet = "0" // in active
                        }*/
                        
                        
                        //
                        
                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "1"
                            
                            Utils.RiteVetIndicatorHide()
                            self.clView.delegate = self
                            self.clView.dataSource = self
                            
                        } else {
                            self.check_vet_reg()
                        }
                        
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
                        
                        
                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "2"
                            
                            Utils.RiteVetIndicatorHide()
                            self.clView.delegate = self
                            self.clView.dataSource = self
                            
                        } else {
                            self.check_vet_reg_other()
                        }
                        
                        
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
                             
                        self.str_other_data = (dict["VFirstName"] as! String)
                        
                        /*if "\(dict["verifyAdmin"]!)" == "1"{
                            self.str_admin_approved_other = "1" // active
                        } else {
                            self.str_admin_approved_other = "0" // in active
                        }*/
                        
                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "3"
                            
                            Utils.RiteVetIndicatorHide()
                            self.clView.delegate = self
                            self.clView.dataSource = self
                            
                        } else {
                            
                            Utils.RiteVetIndicatorHide()
                            self.clView.delegate = self
                            self.clView.dataSource = self
                            
                        }
                        
                        
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

extension Dashboard: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCollectionCell", for: indexPath as IndexPath) as! DashboardCollectionCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.70
    
        if (indexPath.row == 0) {
            
            if (self.str_user_select == "1") {
                cell.imgTitle.image = UIImage(named: "pet")
            } else if (self.str_user_select == "0") {
                cell.imgTitle.image = UIImage(named: "pet")
            } else {
                cell.imgTitle.image = UIImage(named: "grey_pet_parent")
            }
            
        } else if (indexPath.row == 1) {
            
            if (self.str_user_select == "2") {
                cell.imgTitle.image = UIImage(named: "register")
            } else if (self.str_user_select == "0") {
                cell.imgTitle.image = UIImage(named: "register")
            } else {
                cell.imgTitle.image = UIImage(named: "grey_register")
            }
            
        } else if (indexPath.row == 2) {
            
            if (self.str_user_select == "3") {
                cell.imgTitle.image = UIImage(named: "other")
            } else if (self.str_user_select == "0") {
                cell.imgTitle.image = UIImage(named: "other")
            } else {
                cell.imgTitle.image = UIImage(named: "grey_other")
            }
            
        } else if (indexPath.row == 3) {
            
            cell.imgTitle.image = UIImage(named: "drequest")
            
        } else  if (indexPath.row == 4) {
            
            cell.imgTitle.image = UIImage(named: "free")
            
        } else  if (indexPath.row == 5) {
            
            cell.imgTitle.image = UIImage(named: "pet-sore")
            
        }
        
        return cell
        
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrListOfDashboardItems.count
    }
}

extension Dashboard: UICollectionViewDataSource {
    //Write DataSource Code Here
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.row == 0 {
            
            if (self.str_user_select == "1" || self.str_user_select == "0") {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetAndParentsInformationId") as? PetAndParentsInformation
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
        
        if indexPath.row == 1 {

            // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionId")
            // self.navigationController?.pushViewController(push, animated: true)
            
            // print(self.str_admin_approved_pet as Any)
            
            if (self.str_user_select == "2" || self.str_user_select == "0") {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
                self.navigationController?.pushViewController(push, animated: true)
            }
            
            /*if (self.str_pet_data == "") {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
                self.navigationController?.pushViewController(push, animated: true)
                
            } else {
                
                if (self.str_admin_approved_pet == "1") {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
                    self.navigationController?.pushViewController(push, animated: true)
                } else {
                    
                }
                
            }*/
            //
            
            // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
            // self.navigationController?.pushViewController(push, animated: true)
            
        }
        
        if indexPath.row == 2 {
            
            if (self.str_user_select == "3" || self.str_user_select == "0") {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRThreeId")
                self.navigationController?.pushViewController(push, animated: true)
            }
            
            /*if (self.str_other_data == "") {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRThreeId")
                self.navigationController?.pushViewController(push, animated: true)
                
            } else {
                
                if (self.str_admin_approved_other == "1") {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRThreeId")
                    self.navigationController?.pushViewController(push, animated: true)
                } else {
                    
                }
                
            }*/
       
        }
        
        if indexPath.row == 3 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestServiceId") as? RequestService
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
        if indexPath.row == 4 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FreeStuffId") as? FreeStuff
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
        if indexPath.row == 5 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetStoreHomeId") as? PetStoreHome // BrowsePetStore
            self.navigationController?.pushViewController(push!, animated: true)
            
            /*let defaults = UserDefaults.standard
            if let name = defaults.string(forKey: "keyReadTermsAndCondition") {
                print(name)
                if name == "Yes" {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetStoreHomeId") as? PetStoreHome // BrowsePetStore
                    self.navigationController?.pushViewController(push!, animated: true)
                }
                else {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetStoreTermsAndConditionsId") as? PetStoreTermsAndConditions
                    self.navigationController?.pushViewController(push!, animated: true)
                }
            
            }
            else {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetStoreTermsAndConditionsId") as? PetStoreTermsAndConditions
                self.navigationController?.pushViewController(push!, animated: true)
            }*/
            
        }
    }
}

extension Dashboard: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
        
        let result = UIScreen.main.bounds.size
//                    NSLog("%f",result.height);
        if result.height == 480
        {
            //Load 3.5 inch xib
            sizes = CGSize(width: 170.0, height: 190.0)
        }
        else if result.height == 568
        {
            //Load 4 inch xib
            sizes = CGSize(width: 130.0, height: 150.0)
        }
        else if result.height == 667.000000
        {
            //Load 4.7 inch xib
            sizes = CGSize(width: 170.0, height: 190.0)
        }
        else if result.height == 736.000000
        {
            // iphone 6s Plus and 7 Plus
            sizes = CGSize(width: 190.0, height: 210.0)
        }
        else if result.height == 812.000000
        {
            // iphone X
            sizes = CGSize(width: 170.0, height: 190.0)
        }
        else if result.height == 896.000000
        {
            // iphone Xr
            sizes = CGSize(width: 190.0, height: 210.0)
        }
        else
        {
            sizes = CGSize(width: 170.0, height: 190.0)
        }
        
        return sizes
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }
    
}


extension TimeZone {
    
    func offsetFromUTC() -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }
    
 
    func currentTimezoneOffset() -> String {
      let timeZoneFormatter = DateFormatter()
      timeZoneFormatter.dateFormat = "ZZZZZ"
      return timeZoneFormatter.string(from: Date())
  }
}
