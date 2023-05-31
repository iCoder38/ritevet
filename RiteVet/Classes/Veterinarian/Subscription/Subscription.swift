//
//  Subscription.swift
//  RiteVet
//
//  Created by Apple  on 27/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView

class Subscription: UIViewController {

    let cellReuseIdentifier = "subscriptionTableCell"
    
    var arrSubscription = [
        "Free Trial",
        "Subscription",
        // "12 months $89.95 ( you save $29.45 )",
        // "1 month free ( enter coupon code )"
        ]
    
    var dictSaveAllDataVeterinarian:NSDictionary!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SUBSCRIPTION"
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
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // self.veterianrianRegistration()
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
    
    
    @objc func veterianrianRegistration() {
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        /*
         action:returnprofile
         userId;
         UTYPE:
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
           
                   parameters = [
                       "action"         :   "returnprofile",
                       "userId"         :   String(myString),
                       "UTYPE"          :   "2"
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
                               //print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               if strSuccess == "success" //true
                               {
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                   //print(dict as Any)
                                self.dictSaveAllDataVeterinarian = dict as NSDictionary
                                
                                
                                
                                
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "saveVeterinarianRegistration")

                                
                                
                                
                                
                                
                                
                                
                                
                                Utils.RiteVetIndicatorHide()
                               }
                               else
                               {
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
    
}

extension Subscription: UITableViewDataSource
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
        let cell:SubscriptionTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SubscriptionTableCell
        
        cell.backgroundColor = .clear
        
        cell.btnSubscription.backgroundColor = .white//BUTTON_BACKGROUND_COLOR_BLUE
        cell.btnSubscription.layer.cornerRadius = 4
        cell.btnSubscription.clipsToBounds = true
        cell.btnSubscription.setTitleColor(.black, for: .normal)
        cell.btnSubscription.tag = indexPath.row
        
        if indexPath.row == 0 {
            cell.btnSubscription.setTitle("      Free Trial", for: .normal)
        }
        else if indexPath.row == 1 {
            cell.btnSubscription.setTitle("      Subscription", for: .normal)
        }
        
        cell.btnSubscription.addTarget(self, action: #selector(subscriptionClickMethod), for: .touchUpInside)
        
        return cell
    }
    
    @objc func subscriptionClickMethod(_ sender:UIButton) {
        if sender.tag == 0 {
            self.freeTrialActionSheet()
            /*
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VeterinarianRegistrationId") as? VeterinarianRegistration
            self.navigationController?.pushViewController(push!, animated: true)
            */
        }
        else if sender.tag == 1 {
            self.subscriptionActionSheet()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
        }
        else if indexPath.row == 1 {
            self.subscriptionActionSheet()
        }
    }
    
    @objc func freeTrialActionSheet() {
        let alert = UIAlertController(title: "Free Trial", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "1 Month free", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.pushToVeterinarianRegistration()
        }))
        alert.addAction(UIAlertAction(title: "3 Months - Enter Coupon Code", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.openEnterCouponPopup()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func openEnterCouponPopup() {
        let alertController = UIAlertController(title: "Enter coupon code", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "enter coupon code"
        }
        let saveAction = UIAlertAction(title: "Enter", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            // let secondTextField = alertController.textFields![1] as UITextField
            print(firstTextField.text!)
            self.pushToVeterinarianRegistration()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func subscriptionActionSheet() {
        let alert = UIAlertController(title: "Subscription", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "1 month $9.95", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.pushToVeterinarianRegistration()
        }))
        /*alert.addAction(UIAlertAction(title: "3 months $25.85", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.pushToVeterinarianRegistration()
        }))
        alert.addAction(UIAlertAction(title: "12 months $99.99 (You save $19.40)", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.pushToVeterinarianRegistration()
        }))*/
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func pushToVeterinarianRegistration() {
        let alert = UIAlertController(title: "Success", message: "Successfully Subscribed.",preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
            self.navigationController?.pushViewController(push, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension Subscription: UITableViewDelegate {
    
}
