//
//  RequestService.swift
//  RiteVet
//
//  Created by Apple  on 02/12/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RequestService: UIViewController {

    let cellReuseIdentifier = "requestServiceTableCell"
    
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
            lblNavigationTitle.text = "REQUEST SERVICES"
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
            else
            {
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        }
        else
        {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        self.requestServiceWB()
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

extension RequestService: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrSubscription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:RequestServiceTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RequestServiceTableCell
        
        cell.backgroundColor = .clear
        
        if indexPath.row == 0 {
            cell.btnRequestService.tag = 0
            cell.btnRequestService.setImage(UIImage(named: "rvs1.2"), for: .normal)
            cell.btnRequestService.addTarget(self, action: #selector(pushToRequestClickMethod), for: .touchUpInside)
        }
        else
        if indexPath.row == 1 {
            cell.btnRequestService.tag = 1
            cell.btnRequestService.setImage(UIImage(named: "rvs1.1"), for: .normal)
            cell.btnRequestService.addTarget(self, action: #selector(pushToRequestClickMethod), for: .touchUpInside)
        }
        
        
        
        return cell
    }
    
    @objc func pushToRequestClickMethod (_ sender:UIButton) {
        
        if sender.tag == 0 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestVeterianaryServiceId") as? RequestVeterianaryService
            push!.getBusinessType = "2"
            self.navigationController?.pushViewController(push!, animated: true)
        }
            
        if sender.tag == 1 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestVeterianaryServiceId") as? RequestVeterianaryService
                push!.getBusinessType = "3"
                self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestVeterianaryServiceId") as? RequestVeterianaryService
            push!.getBusinessType = "2"
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
        if indexPath.row == 1 {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RequestVeterianaryServiceId") as? RequestVeterianaryService
            push!.getBusinessType = "3"
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension RequestService: UITableViewDelegate
{
    
}
