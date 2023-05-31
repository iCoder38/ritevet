//
//  BrowsePetStore.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BrowsePetStore: UIViewController {

    let cellReuseIdentifier = "browsePetStoreTableCell"
    
    var arrSubscription = [
    "1","2"
    ]
    
    var arrBrowsePetStore:Array<Any>!
    
    @IBOutlet weak var btnAdd:UIButton!
    
    @IBOutlet weak var btnAdd2:UIButton!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "BROWSE PET STORE"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            //tbleView.delegate = self
            //tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblStaticOne:UILabel! {
        didSet {
            // 255 202 69
            lblStaticOne.backgroundColor = UIColor.init(red: 255.0/255.0, green: 202.0/255.0, blue: 69.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var lblStaticTwo:UILabel! {
        didSet {
            lblStaticTwo.backgroundColor = UIColor.init(red: 255.0/255.0, green: 202.0/255.0, blue: 69.0/255.0, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        btnAdd.addTarget(self, action: #selector(addClickMethod), for: .touchUpInside)
        btnAdd2.addTarget(self, action: #selector(addClickMethod), for: .touchUpInside)
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenuPetStore") {
            print(name)
            if name == "PetStoreMenuBar" {
             // menu
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                self.sideBarMenu()
            }
            else
            {
                btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
            }
        }
        else
        {
            btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        }
        
        self.category()
    }
    @objc func sideBarMenu() {
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "keySideBarMenuPetStore")
        defaults.set(nil, forKey: "keySideBarMenuPetStore")
        
            if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
                revealViewController().rearViewRevealWidth = 300
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewProductId") as? AddNewProduct
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func category() {
           Utils.RiteVetIndicatorShow()
           
               let urlString = BASE_URL_KREASE
               
               var parameters:Dictionary<AnyHashable, Any>!
           
                   parameters = [
                       "action"        :   "category"
                   ]
              
                
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
                               
                               if strSuccess == "success" //true
                               {
                                // arrBrowsePetStore
                                
                                self.tbleView!.dataSource = self
                                self.tbleView!.delegate = self
                                
                                var ar : NSArray!
                                ar = (JSON["response"] as! Array<Any>) as NSArray
                                self.arrBrowsePetStore = (ar as! Array<Any>)
                                
                                self.tbleView!.reloadData()
                                
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
}


extension BrowsePetStore: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrBrowsePetStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:BrowsePetStoreTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! BrowsePetStoreTableCell
        
        cell.backgroundColor = .clear
        
        let item = arrBrowsePetStore[indexPath.row] as? [String:Any]
        
        cell.lblTitle.text = (item!["name"] as! String)
        
        let livingArea = item?["totalProduct"] as? Int ?? 0
        if livingArea == 0 {
            let stringValue = String(livingArea)
            cell.lblCount.text = "("+stringValue+")"
        }
        else
        {
            let stringValue = String(livingArea)
            cell.lblCount.text = "("+stringValue+")"
        }
        
        cell.lblCount.textColor = UIColor.init(red: 255.0/255.0, green: 173.0/255.0, blue: 68.0/255.0, alpha: 1)
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = arrBrowsePetStore[indexPath.row] as? [String:Any]
        //print(item as Any)
        
        // arrBrowseGetPetDetails
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BrowsePetStoreSubCategoryId") as? BrowsePetStoreSubCategory
        push!.dictGetPetDetails = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
}

extension BrowsePetStore: UITableViewDelegate
{
    
}

