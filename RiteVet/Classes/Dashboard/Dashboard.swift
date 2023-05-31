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

class Dashboard: UIViewController {
    
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
            clView.delegate = self
            clView.dataSource = self
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
        
        self.updateLoginUserDeviceToken()
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
            if let myString = defaults.string(forKey: "deviceFirebaseToken") {
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
                                
                        self.clView!.dataSource = self
                        self.clView!.delegate = self
                        self.clView.reloadData()
                                
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
        
        cell.imgTitle.image = UIImage(named: arrListOfDashboardImages[indexPath.row])
        
        
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
            
            /*let alert = UIAlertController(title: "Alert!", message: "Working.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)*/
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRTwoId")
            self.navigationController?.pushViewController(push, animated: true)
        }
        
        if indexPath.row == 2 {
            
            /*let alert = UIAlertController(title: "Alert!", message: "Working.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)*/
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VRThreeId")
            self.navigationController?.pushViewController(push, animated: true)
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

