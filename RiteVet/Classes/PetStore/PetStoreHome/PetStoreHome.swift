//
//  PetStoreHome.swift
//  RiteVet
//
//  Created by Apple on 06/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PetStoreHome: UIViewController {

    let cellReuseIdentifier = "petStoreTableCell"
    
    var arrSubscription = [
    "1","2"
    ]
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "PET STORE"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
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
        
        // let defaults = UserDefaults.standard
        //defaults.set("RequestServiceMenuBar", forKey: "keySideBarMenuRequestPost")
        
        // btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenuRequestPost") {
            print(name)
            if name == "RequestServiceMenuBar" {
             // menu
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                self.sideBarMenu()
            }
            else {
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        }
        else {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        self.tbleView.separatorColor = .clear
        // self.requestServiceWB()
    }
    
    @objc func sideBarMenu() {
           
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "keySideBarMenuRequestPost")
        defaults.set(nil, forKey: "keySideBarMenuRequestPost")
           
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
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     action: typeofservice
     UTYPE:
     */
    
    @objc func requestServiceWB() {
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //self.disableService()
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"        :   "typeofbusiness"
            //"UTYPE"        :   "4"
        ]
        
        
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
                    
                    if strSuccess == "success" {
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        //print(ar as Any)
                        
                        //var arServices : NSArray!
                        var itemCountarServices:Int!
                        var newString1arServices = ""
                        var ssarServices:String!
                        
                        itemCountarServices = ar.count-1
                        
                        for i in 0 ... itemCountarServices {
                            let itemarServices = ar[i] as? [String:Any]
                            ssarServices = (itemarServices!["name"] as! String)
                            newString1arServices += "\(ssarServices!)+"
                        }
                        
                        //print(newString1arServices as Any)
                        //self.strSaveFullValueOfServiceInOneString = newString1arServices
                        
                        let defaults = UserDefaults.standard
                        defaults.set((newString1arServices), forKey: "keyRequestServiceDropDown")
                        
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

extension PetStoreHome: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:PetStoreTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PetStoreTableCell
        
        cell.backgroundColor = .clear
        
        if indexPath.row == 0 {
            cell.btnRequestService.tag = 0
            cell.btnRequestService.setImage(UIImage(named: "9"), for: .normal)
            cell.btnRequestService.addTarget(self, action: #selector(pushToRequestClickMethod), for: .touchUpInside)
        }
        else
        if indexPath.row == 1 {
            cell.btnRequestService.tag = 1
            cell.btnRequestService.setImage(UIImage(named: "8"), for: .normal)
            cell.btnRequestService.addTarget(self, action: #selector(pushToRequestClickMethod), for: .touchUpInside)
        }
        
        
        
        return cell
    }
    
    @objc func pushToRequestClickMethod (_ sender:UIButton) {
        
        if sender.tag == 0 {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                // print(person as Any)
                
                

                
                
                if (person["profile_ID_image"] as! String) == "" {
                    //
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "pet_store_id_proof_id") as? pet_store_id_proof
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                } else {
//
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewProductId") as? AddNewProduct
                    self.navigationController?.pushViewController(push!, animated: true)
//
                }
                
                
            }
            
            
        }
            
        if sender.tag == 1 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BrowsePetStoreId") as? BrowsePetStore
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewProductId") as? AddNewProduct
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if indexPath.row == 1 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BrowsePetStoreId") as? BrowsePetStore
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension PetStoreHome: UITableViewDelegate {
    
}
