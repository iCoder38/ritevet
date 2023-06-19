//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class MenuControllerVC: UIViewController {

    let cellReuseIdentifier = "menuControllerVCTableCell"
    
    var bgImage: UIImageView?
    
    var arrMenuItemList = ["Dashboard",
                           "Edit Profile",
                           "My Posts",
                           "Submit New Post",
                           "Request Services",
                           "Pet Store",
                           "My Products",
                           "Missed Call",
                           "Chat",
                           "My Reviews",
                           "My Orders",
                           "Order Received",
                           "My Cart",
                           "Appointments",
                           "My Bookings",
                           "Wallet",
                           "Change Password",
                           "Help",
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
        if String(arrMenuItemList[indexPath.row]) == "My Posts" {
            pushPageNumber(strMyPageNumber: "4")
        }
        if String(arrMenuItemList[indexPath.row]) == "Submit New Post" {
            pushPageNumber(strMyPageNumber: "5")
        }
        if String(arrMenuItemList[indexPath.row]) == "Request Services" {
            pushPageNumber(strMyPageNumber: "6")
        }
        if String(arrMenuItemList[indexPath.row]) == "Pet Store" {
            pushPageNumber(strMyPageNumber: "7")
        }
        if String(arrMenuItemList[indexPath.row]) == "My Orders" {
            pushPageNumber(strMyPageNumber: "8")
        }
        if String(arrMenuItemList[indexPath.row]) == "Appointments" {
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
        if String(arrMenuItemList[indexPath.row]) == "My Products" {
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
        
        if String(arrMenuItemList[indexPath.row]) == "Order Received" {
            pushPageNumber(strMyPageNumber: "19")
        }
        
        if String(arrMenuItemList[indexPath.row]) == "My Reviews" {
            pushPageNumber(strMyPageNumber: "20")
        }
        
        
    }
    
    @objc func pushPageNumber(strMyPageNumber:String) {
       
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
                let defaults = UserDefaults.standard
                defaults.setValue("", forKey: "keyLoginFullData")
                defaults.setValue(nil, forKey: "keyLoginFullData")
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "LoginId") as! Login
                // obj.strBookingOrAppointment = "bookingIs"
                let navController = UINavigationController(rootViewController: obj)
                navController.setViewControllers([obj], animated:true)
                self.revealViewController().setFront(navController, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
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
