//
//  cashout_pay.swift
//  RiteVet
//
//  Created by Dishant Rajput on 31/05/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView

class cashout_pay: UIViewController {

    var str_product_wallet:String!
    var str_veterian_wallet:String!
    var str_type_2:String!
    
//    var dict_get_cashout_Records:NSDictionary!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Cashout"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_submit_request:UIButton! {
        didSet {
            btn_submit_request.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btn_submit_request.layer.cornerRadius = 20
            btn_submit_request.clipsToBounds = true
            btn_submit_request.setTitle("Submit Request", for: .normal)
            btn_submit_request.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var lbl_earning:UILabel! {
        didSet {
            lbl_earning.text = "$99.99"
        }
    }
    
    @IBOutlet weak var txt_cashout:UITextField! {
        didSet {
            Utils.textFieldDR(text: txt_cashout, placeHolder: "$00.00", cornerRadius: 20, color: .white)
            txt_cashout.keyboardType = .numberPad
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(self.dict_get_cashout_Records as Any)
        // print(self.str_product_wallet as Any)
        // print(self.str_veterian_wallet as Any)
        
        if String(self.str_type_2) == "2" {
            
            self.lbl_earning.text = "$"+String(self.str_veterian_wallet)
            
        } else {
            
            self.lbl_earning.text = "$"+String(self.str_product_wallet)
            
        }
        
        
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
     
        
        self.btn_submit_request.addTarget(self, action: #selector(veterianrianRegistration), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func veterianrianRegistration() {
        
        
        if String(self.str_type_2) == "2" {
          
            let spentBudgetInt = Int(self.txt_cashout.text!) ?? 0
            let spentBudgetInt2 = Int(self.str_veterian_wallet!) ?? 0
            
            print(spentBudgetInt as Any)
            print(spentBudgetInt2 as Any)
            
            if (spentBudgetInt > spentBudgetInt2) {
            // if (self.txt_cashout.text! > String(self.str_veterian_wallet)) {
               
                let alertController = UIAlertController(title: "Alert", message: "Requested Amount should be less than Wallet Amount.", preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                
            } else {
                Utils.RiteVetIndicatorShow()
                
                let urlString = BASE_URL_KREASE
                
                var parameters:Dictionary<AnyHashable, Any>!
                
                /*
                 [action] => requestservicedetails
                 [userInformationId] => 18
                 [date] => 2023-05-31
                 [time] => 16:52
                 */
                
                let date = Date()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                let dateString = df.string(from: date)
                print(dateString)
                
                let date_2 = Date()
                let df_2 = DateFormatter()
                df_2.dateFormat = "hh:mm"
                let dateString_2 = df_2.string(from: date_2)
                print(dateString_2)
                
                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                    let x : Int = (person["userId"] as! Int)
                    let myString = String(x)
                    
                    parameters = [
                        "action"    : "cashoutrequest",
                        "userId"    : String(myString),
                        "Request_Amount"    : String(self.txt_cashout.text!),
                        "type"    : String(self.str_type_2),
                        
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
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                            else {
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
            
        } else {
            
            let spentBudgetInt = Int(self.txt_cashout.text!) ?? 0
            let spentBudgetInt2 = Int(self.str_product_wallet!) ?? 0
            
            print(spentBudgetInt as Any)
            print(spentBudgetInt2 as Any)
            
            if (spentBudgetInt > spentBudgetInt2) {
                let alertController = UIAlertController(title: "Alert", message: "Requested Amount should be less than Wallet Amount.", preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                Utils.RiteVetIndicatorShow()
                
                let urlString = BASE_URL_KREASE
                
                var parameters:Dictionary<AnyHashable, Any>!
                
                /*
                 [action] => requestservicedetails
                 [userInformationId] => 18
                 [date] => 2023-05-31
                 [time] => 16:52
                 */
                
                let date = Date()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                let dateString = df.string(from: date)
                print(dateString)
                
                let date_2 = Date()
                let df_2 = DateFormatter()
                df_2.dateFormat = "hh:mm"
                let dateString_2 = df_2.string(from: date_2)
                print(dateString_2)
                
                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                    let x : Int = (person["userId"] as! Int)
                    let myString = String(x)
                    
                    parameters = [
                        "action"    : "cashoutrequest",
                        "userId"    : String(myString),
                        "Request_Amount"    : String(self.txt_cashout.text!),
                        "type"    : String(self.str_type_2),
                        
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
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                            else {
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
        
    }
    
}
