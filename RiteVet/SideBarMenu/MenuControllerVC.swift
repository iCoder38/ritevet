//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

class MenuControllerVC: UIViewController {

    let cellReuseIdentifier = "menuControllerVCTableCell"
    
    var bgImage: UIImageView?
    
    var arrMenuItemList = ["Dashboard",
                           "Edit Profile",
                           "Free Stuff",
                           "Post Free Stuff",
                           "Request Services",
                           "Pet Store",
                           "Sell items",
                           "Missed Call",
                           "Chat",
                           "Reviews Received",
                           "Items Purchased",
                           "Orders Received",
                           "My Cart",
                           "Manage Appointments",
                           "My Bookings",
                           "Wallet",
                           "Change Password",
                           "Help",
                           "Delete Account",
                           "Sign out",
    ]
    
    var arrMenuItemImage = ["m_dashboard",
                            "m_edit_profile",
                            "m_my_posts",
                            "m_submit_new_post",
                            "m_request_services",
                            "m_pet_store",
                            "m_my_products",
                            "m_missed_call",
                            "m_chat",
                            "m_my_orders",
                            "m_my_orders",
                            "m_order_received",
                            "m_my_cart",
                            "m_appointments",
                            "m_my_bookings",
                            "m_wallet",
                            "m_change_password",
                            "m_help",
                            "remove",
                                "m_sign_out"]
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "NAVIGATION"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet var menuButton:UIButton!
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            // tbleView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tbleView.separatorColor = .white
        sideBarMenuClick()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            
            
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            self.lblName.text = (person["fullName"] as! String)
            self.lblAddress.text = (person["address"] as! String)
        }
    }
    
    @objc func sideBarMenuClick() {
        if revealViewController() != nil {
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func logout_WB() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    :   "logout",
                "userId"    :   myString,
               
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
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == "Success" || strSuccess == "success"  {
                        Utils.RiteVetIndicatorHide()
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue("", forKey: "keyLoginFullData")
                        defaults.setValue(nil, forKey: "keyLoginFullData")
                        
                        defaults.setValue("", forKey: "key_first_time_vet_reg")
                        defaults.setValue(nil, forKey: "key_first_time_vet_reg")
                        
                        defaults.setValue("", forKey: "key_first_time_other_reg")
                        defaults.setValue(nil, forKey: "key_first_time_other_reg")
                        
                        
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginId") as! Login
                        // obj.strBookingOrAppointment = "bookingIs"
                        let navController = UINavigationController(rootViewController: obj)
                        navController.setViewControllers([obj], animated:true)
                        self.revealViewController().setFront(navController, animated: true)
                        self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                        
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
    
    
    
    
    
    
    
    @objc func delete_generateOTP() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"       :   "deleteotp",
                "userId"       :   myString,
//                "OTP":""
               
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
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == "Success" || strSuccess == "success"  {
                        Utils.RiteVetIndicatorHide()
                        
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "delete_account_id") as! delete_account
                         obj.str_delete_account_message = String(strSuccess2)
                        let navController = UINavigationController(rootViewController: obj)
                        navController.setViewControllers([obj], animated:true)
                        self.revealViewController().setFront(navController, animated: true)
                        self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                        
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

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenuItemList.count // arrMenuItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        
        cell.backgroundColor = .clear
        cell.lblName.text = self.arrMenuItemList[indexPath.row]
        cell.lblName.textColor = .white
        cell.imgProfile.image = UIImage(named: self.arrMenuItemImage[indexPath.row])
        
        /*if  indexPath.row == 0 {
            let label = UILabel(frame: CGRect(x: 15, y: 10, width: 345, height: 30))
            label.textAlignment = .left
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                label.text = (person["fullName"] as! String)
            }
            
            label.textColor = .black
            label.font = UIFont.init(name: "OpenSans-Bold", size: 20)
            cell.addSubview(label)
            
            let image : UIImage = UIImage(named:"location")!
            bgImage = UIImageView(image: image)
            bgImage!.frame = CGRect(x: 15, y: 46, width: 20, height: 20)
            cell.addSubview(bgImage!)
            
            let label2 = UILabel(frame: CGRect(x: 44, y: 40, width: 311, height: 30))
            label2.textAlignment = .left
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                label2.text = (person["address"] as! String)
            }
            label2.textColor = .black
            cell.addSubview(label2)
            cell.backgroundColor = UIColor.init(red: 252.0/255.0, green: 195.0/255.0, blue: 10.0/255.0, alpha: 1)
        }
         if  indexPath.row == 1 {
            let mScreenSize = UIScreen.main.bounds
            let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
            let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
            mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
            cell.addSubview(mAddSeparator)
            
            let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
            bgImage = UIImageView(image: image)
            bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
            cell.addSubview(bgImage!)
            
            let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
            label.textAlignment = .left
            label.text = "Dashboard" // arrMenuItemList[indexPath.row]
            label.font = UIFont.init(name: "OpenSans-Light", size: 20)
            label.textColor = .white
            cell.addSubview(label)
            cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
        }
         if  indexPath.row == 2 {
            let mScreenSize = UIScreen.main.bounds
            let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
            let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
            mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
            cell.addSubview(mAddSeparator)
            
            let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
            bgImage = UIImageView(image: image)
            bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
            cell.addSubview(bgImage!)
            
            let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
            label.textAlignment = .left
            label.text =  "Edit Profile" // arrMenuItemList[indexPath.row]
            label.font = UIFont.init(name: "OpenSans-Light", size: 20)
            label.textColor = .white
            cell.addSubview(label)
            cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
        }
         if  indexPath.row == 3 {
            let mScreenSize = UIScreen.main.bounds
            let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
            let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
            mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
            cell.addSubview(mAddSeparator)
            
            let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
            bgImage = UIImageView(image: image)
            bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
            cell.addSubview(bgImage!)
            
            let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
            label.textAlignment = .left
            label.text = "My Post" //  arrMenuItemList[indexPath.row]
            label.font = UIFont.init(name: "OpenSans-Light", size: 20)
            label.textColor = .white
            cell.addSubview(label)
            cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
        }
             if  indexPath.row == 4 {
                let mScreenSize = UIScreen.main.bounds
                let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
                let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
                mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
                cell.addSubview(mAddSeparator)
                
                let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
                cell.addSubview(bgImage!)
                
                let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
                label.textAlignment = .left
                label.text = "Submit New Post" // arrMenuItemList[indexPath.row]
                label.font = UIFont.init(name: "OpenSans-Light", size: 20)
                label.textColor = .white
                cell.addSubview(label)
                cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
            }
             if  indexPath.row == 5 {
                let mScreenSize = UIScreen.main.bounds
                let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
                let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
                mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
                cell.addSubview(mAddSeparator)
                
                let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
                cell.addSubview(bgImage!)
                
                let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
                label.textAlignment = .left
                label.text = "Request Service" // arrMenuItemList[indexPath.row]
                label.font = UIFont.init(name: "OpenSans-Light", size: 20)
                label.textColor = .white
                cell.addSubview(label)
                cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
            }
             if  indexPath.row == 6 {
                let mScreenSize = UIScreen.main.bounds
                let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
                let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
                mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
                cell.addSubview(mAddSeparator)
                
                let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
                cell.addSubview(bgImage!)
                
                let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
                label.textAlignment = .left
                label.text = "Pet Store" // arrMenuItemList[indexPath.row]
                label.font = UIFont.init(name: "OpenSans-Light", size: 20)
                label.textColor = .white
                cell.addSubview(label)
                cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
            }
             if  indexPath.row == 7 {
                let mScreenSize = UIScreen.main.bounds
                let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
                let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
                mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
                cell.addSubview(mAddSeparator)
                
                let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
                cell.addSubview(bgImage!)
                
                let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
                label.textAlignment = .left
                label.text = "My Orders" // arrMenuItemList[indexPath.row]
                label.font = UIFont.init(name: "OpenSans-Light", size: 20)
                label.textColor = .white
                cell.addSubview(label)
                cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
            }
             if  indexPath.row == 8 {
                let mScreenSize = UIScreen.main.bounds
                let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
                let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
                mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
                cell.addSubview(mAddSeparator)
                
                let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
                cell.addSubview(bgImage!)
                
                let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
                label.textAlignment = .left
                label.text = "Appointment" // arrMenuItemList[indexPath.row]
                label.font = UIFont.init(name: "OpenSans-Light", size: 20)
                label.textColor = .white
                cell.addSubview(label)
                cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
            }
             if  indexPath.row == 9 {
                let mScreenSize = UIScreen.main.bounds
                let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
                let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
                mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
                cell.addSubview(mAddSeparator)
                
                let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
                cell.addSubview(bgImage!)
                
                let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
                label.textAlignment = .left
                label.text = "My Booking" // arrMenuItemList[indexPath.row]
                label.font = UIFont.init(name: "OpenSans-Light", size: 20)
                label.textColor = .white
                cell.addSubview(label)
                cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
            }
             if  indexPath.row == 10 {
                let mScreenSize = UIScreen.main.bounds
                let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
                let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
                mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
                cell.addSubview(mAddSeparator)
                
                let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
                cell.addSubview(bgImage!)
                
                let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
                label.textAlignment = .left
                label.text = "Change Password" // arrMenuItemList[indexPath.row]
                label.font = UIFont.init(name: "OpenSans-Light", size: 20)
                label.textColor = .white
                cell.addSubview(label)
                cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
            }
             if  indexPath.row == 11 {
                let mScreenSize = UIScreen.main.bounds
                let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
                let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
                mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
                cell.addSubview(mAddSeparator)
                
                let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
                cell.addSubview(bgImage!)
                
                let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
                label.textAlignment = .left
                label.text = "Help" // arrMenuItemList[indexPath.row]
                label.font = UIFont.init(name: "OpenSans-Light", size: 20)
                label.textColor = .white
                cell.addSubview(label)
                cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
            }
         if  indexPath.row == 12 {
            let mScreenSize = UIScreen.main.bounds
            let mSeparatorHeight = CGFloat(0.5) // Change height of speatator as you want
            let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
            mAddSeparator.backgroundColor = UIColor.white // Change backgroundColor of separator
            cell.addSubview(mAddSeparator)
            
            let image : UIImage = UIImage(named:arrMenuItemImage[indexPath.row])!
            bgImage = UIImageView(image: image)
            bgImage!.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
            cell.addSubview(bgImage!)
            
            let label = UILabel(frame: CGRect(x: 60, y: 15, width: 302, height: 24))
            label.textAlignment = .left
            label.text = "Logout" // arrMenuItemList[indexPath.row]
            label.font = UIFont.init(name: "OpenSans-Light", size: 20)
            label.textColor = .white
            cell.addSubview(label)
            cell.backgroundColor = UIColor.init(red: 8.0/255.0, green: 35.0/255.0, blue: 105.0/255.0, alpha: 1)
        }
        //
       */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if String(arrMenuItemList[indexPath.row]) == "Dashboard" {
            pushPageNumber(strMyPageNumber: "1")
        }
        if String(arrMenuItemList[indexPath.row]) == "Edit Profile" {
            pushPageNumber(strMyPageNumber: "2")
        }
        if String(arrMenuItemList[indexPath.row]) == "Free Stuff" {
            pushPageNumber(strMyPageNumber: "4")
        }
        if String(arrMenuItemList[indexPath.row]) == "Post Free Stuff" {
            pushPageNumber(strMyPageNumber: "5")
        }
        if String(arrMenuItemList[indexPath.row]) == "Request Services" {
            pushPageNumber(strMyPageNumber: "6")
        }
        if String(arrMenuItemList[indexPath.row]) == "Pet Store" {
            pushPageNumber(strMyPageNumber: "7")
        }
        if String(arrMenuItemList[indexPath.row]) == "Items Purchased" {
            pushPageNumber(strMyPageNumber: "8")
        }
        if String(arrMenuItemList[indexPath.row]) == "Manage Appointments" {
            pushPageNumber(strMyPageNumber: "11")
        }
        if String(arrMenuItemList[indexPath.row]) == "My Bookings" {
            pushPageNumber(strMyPageNumber: "12")
        }
        if String(arrMenuItemList[indexPath.row]) == "Change Password" {
            pushPageNumber(strMyPageNumber: "9")
        }
        if String(arrMenuItemList[indexPath.row]) == "Help" {
            pushPageNumber(strMyPageNumber: "10")
        }
        if String(arrMenuItemList[indexPath.row]) == "Logout" {
            pushPageNumber(strMyPageNumber: "13")
        }
        if String(arrMenuItemList[indexPath.row]) == "Sign out" {
            pushPageNumber(strMyPageNumber: "13")
        }
        if String(arrMenuItemList[indexPath.row]) == "Sell items" {
            pushPageNumber(strMyPageNumber: "14")
        }
        if String(arrMenuItemList[indexPath.row]) == "My Cart" {
            pushPageNumber(strMyPageNumber: "15")
        }
        if String(arrMenuItemList[indexPath.row]) == "Chat" {
            pushPageNumber(strMyPageNumber: "16")
        }
        if String(arrMenuItemList[indexPath.row]) == "Missed Call" {
            pushPageNumber(strMyPageNumber: "17")
        }
        
        if String(arrMenuItemList[indexPath.row]) == "Wallet" {
            pushPageNumber(strMyPageNumber: "18")
        }
        
        if String(arrMenuItemList[indexPath.row]) == "Orders Received" {
            pushPageNumber(strMyPageNumber: "19")
        }
        
        if String(arrMenuItemList[indexPath.row]) == "Reviews Received" {
            pushPageNumber(strMyPageNumber: "20")
        }
        
        if String(arrMenuItemList[indexPath.row]) == "Delete Account" {
            pushPageNumber(strMyPageNumber: "21")
        }
        
        
    }
    
    @objc func pushPageNumber(strMyPageNumber:String) {
       
        if strMyPageNumber == "21" {
            
            let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account ?",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Yes, delete", style: .default, handler: { _ in
                //Cancel Action
                self.delete_generateOTP()
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
                //Cancel Action
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "all_reviews_id") as! all_reviews
//            let navController = UINavigationController(rootViewController: obj)
//            navController.setViewControllers([obj], animated:true)
//            self.revealViewController().setFront(navController, animated: true)
//            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        }
        
        if strMyPageNumber == "20" {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "all_reviews_id") as! all_reviews
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        }
        
        if strMyPageNumber == "19" {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "order_received_id") as! order_received
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        }
        
        if strMyPageNumber == "18" {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "cashout_id") as! cashout
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        }
        
        if strMyPageNumber == "1" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DashboardId") as! Dashboard
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "2" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileId") as! EditProfile
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "4" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyPostId") as! MyPost
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "5" {
            
            let defaults = UserDefaults.standard
            defaults.set("SubmitPostMenuBar", forKey: "keySideBarMenuSubmitPost")
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SubmitPostId") as! SubmitPost
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "6" {
            
            let defaults = UserDefaults.standard
            defaults.set("RequestServiceMenuBar", forKey: "keySideBarMenuRequestPost")
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "RequestServiceId") as! RequestService
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "7" {
            
            let defaults = UserDefaults.standard
            defaults.set("PetStoreMenuBar", forKey: "keySideBarMenuPetStore")
            
            defaults.setValue("", forKey: "keyReadTermsAndCondition")
            defaults.setValue(nil, forKey: "keyReadTermsAndCondition")
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowsePetStoreId") as! BrowsePetStore
            let navController = UINavigationController(rootViewController: obj)
            // obj.strFromSideBarPetStore = "sideBarMenuForMyProductCart"
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
            /*let defaults = UserDefaults.standard
            defaults.set("PetStoreMenuBar", forKey: "keySideBarMenuPetStore")
        
             if let name = defaults.string(forKey: "keyReadTermsAndCondition") {
                 print(name)
                 if name == "Yes" {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowsePetStoreId") as! BrowsePetStore
                    let navController = UINavigationController(rootViewController: obj)
                    navController.setViewControllers([obj], animated:true)
                    self.revealViewController().setFront(navController, animated: true)
                    self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                 }
                 else
                 {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "PetStoreTermsAndConditionsId") as! PetStoreTermsAndConditions
                    let navController = UINavigationController(rootViewController: obj)
                    navController.setViewControllers([obj], animated:true)
                    self.revealViewController().setFront(navController, animated: true)
                    self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                 }
         }*/
        }
        if strMyPageNumber == "8" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersId") as! MyOrders
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "9" {
            
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordId") as! ChangePassword
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "10" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "HelpId") as! Help
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "11" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentId") as! Appointment
            obj.strBookingOrAppointment = "appointmentIs"
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        if strMyPageNumber == "12" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingId") as! MyBooking
            // obj.strBookingOrAppointment = "bookingIs"
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        
        if strMyPageNumber == "13" {
            
            let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to Signout ?",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Yes, Logout", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
                
                
                self.logout_WB()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.destructive, handler: { _ in
                //Cancel Action
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        if strMyPageNumber == "14" {
            
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DogFoodId") as! DogFood
             obj.strFromSideBar = "sideBarMenuForMyProduct"
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        
        if strMyPageNumber == "15" {
            
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AddToCartId") as! AddToCart
             obj.strFromSideBarCart = "sideBarMenuForMyProductCart"
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        
        
        if strMyPageNumber == "16" {
            
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DialogsId") as! Dialogs
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        
        if strMyPageNumber == "17" {
            
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "CallLogsId") as! CallLogs
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        
    }
    
}

extension MenuControllerVC: UITableViewDelegate {
    
}
