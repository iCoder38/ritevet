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
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let dateString = "2016-01-25T10:04:53.498Z"
         
         // Setup a date formatter to match the format of your string
         let dateFormatter = DateFormatter()
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
         
         // Create a date object from the string
         if let date = dateFormatter.date(from: dateString) {
         
         if date < Date() {
         print("Before now")
         } else {
         print("After now")
         }
         }*/
        
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        
        self.sideBarMenu()
        
        //btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // self.welcomeWB()
        
        
        self.askPermissionIfNeeded()
        self.updateLoginUserDeviceToken()
        //
        self.check_vet_reg()
        //
        // in-app purchase
        // print(SKPaymentQueue.default().finishTransaction(Transaction//))
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
            
            parameters = [
                "action"        : "editprofile",
                "userId"        : myString,
                "deviceToken"   : String(self.myDeviceTokenIs),
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
                        
                        /*var ar : NSArray!
                         ar = (JSON["data"] as! Array<Any>) as NSArray
                         self.arrListOfDashboardItems.addObjects(from: ar as! [Any])*/
                        
                        /*self.clView!.dataSource = self
                         self.clView!.delegate = self
                         self.clView.reloadData()*/
                        
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
                        
                        if (dict["expiryDate"] as! String) != "" {
                            
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
                            
                        }
                        
                        
                    

                        //
                        if "\(dict["verifyAdmin"]!)" == "1"{
                            self.str_admin_approved_pet = "1" // active

                        } else {
                            self.str_admin_approved_pet = "0" // in active
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
                        
                        if "\(dict["verifyAdmin"]!)" == "1"{
                            self.str_admin_approved_other = "1" // active
                        } else {
                            self.str_admin_approved_other = "0" // in active
                        }
                        
                        self.clView.delegate = self
                        self.clView.dataSource = self
                        
                        
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

extension Dashboard: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCollectionCell", for: indexPath as IndexPath) as! DashboardCollectionCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.70
    
        // let item = arrListOfDashboardItems[indexPath.row] as? [String:Any]
        
        //print(item!["id"] as! NSNumber)
        //print(item!["name"] as! String)
        //cell.
        
        // cell.imgTitle.image = UIImage(named: arrListOfDashboardImages[indexPath.row])
        // var arrListOfDashboardImages = ["pet","register","other","drequest","free","pet-sore"]
        if (indexPath.row == 0) {
            
            cell.imgTitle.image = UIImage(named: "pet")
            
        } else  if (indexPath.row == 1) {

            /*if (self.str_pet_data == "") {
                cell.imgTitle.image = UIImage(named: "register")
            } else {*/
                if (self.str_admin_approved_pet == "1") {
                    cell.imgTitle.image = UIImage(named: "register")
                } else {
                    cell.imgTitle.image = UIImage(named: "grey_register")
                }
            // }
            
            
        } else  if (indexPath.row == 2) {
            
            // str_other_data
            
            /*if (self.str_other_data == "") {
                cell.imgTitle.image = UIImage(named: "other")
            } else {*/
                if (self.str_admin_approved_other == "1") {
                    cell.imgTitle.image = UIImage(named: "other")
                } else {
                    cell.imgTitle.image = UIImage(named: "grey_other")
                }
            // }
            
            
            
        } else  if (indexPath.row == 3) {
            
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
        /*
        print(indexPath.row)
        */

        if indexPath.row == 0 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PetAndParentsInformationId") as? PetAndParentsInformation
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
        if indexPath.row == 1 {

            // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionId")
            // self.navigationController?.pushViewController(push, animated: true)
            
            print(self.str_admin_approved_pet as Any)
            
            if (self.str_pet_data == "") {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
                self.navigationController?.pushViewController(push, animated: true)
                
            } else {
                
                if (self.str_admin_approved_pet == "1") {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
                    self.navigationController?.pushViewController(push, animated: true)
                } else {
                    
                }
                
            }
            //
            
            
//            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
//            self.navigationController?.pushViewController(push, animated: true)
            
        }
        
        if indexPath.row == 2 {
            
            if (self.str_other_data == "") {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRThreeId")
                self.navigationController?.pushViewController(push, animated: true)
                
            } else {
                
                if (self.str_admin_approved_other == "1") {
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRThreeId")
                    self.navigationController?.pushViewController(push, animated: true)
                } else {
                    
                }
                
            }
            
            
            
            
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

