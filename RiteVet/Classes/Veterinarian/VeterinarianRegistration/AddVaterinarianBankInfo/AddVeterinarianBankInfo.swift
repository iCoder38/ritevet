//
//  AddVeterinarianBankInfo.swift
//  RiteVet
//
//  Created by Apple  on 28/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView
import CRNotifications

class AddVeterinarianBankInfo: UIViewController,UITextFieldDelegate {

    let cellReuseIdentifier = "addVaterinarianTableCell"
    
    var totalCellInTableView = [
                            "1",
                            ]
    
    
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ADD BANK INFO (OPTIONAL)"
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
        
        /*if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any] {
            
            let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! AddVaterinarianTableCell
            
            
            //cell.txtAccountNumber.text = (person["ACName"] as! String)
            
            
        }*/
        
        self.welcome6()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func welcome6() {
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
                   
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON { [self]
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
                        
                        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! AddVaterinarianTableCell
                        
                        cell.txtYourName.text = (dict["ACName"] as! String)
                        cell.txtSelectBank.text = (dict["BankName"] as! String)
                        cell.txtBankAccountNumber.text = (dict["AccountNo"] as! String)
                        cell.txtSwitchNumberForAccounts.text = (dict["swiftNumber"] as! String)
                        
                        cell.txtRoutingCode.text = (dict["RoutingNo"] as! String)
                        cell.txtAccountType.text = (dict["accountType"] as! String)
                        
                        cell.txtEmailAddress.text = (dict["PaypalEmail"] as! String)
                        cell.txtAccountNumber.text = (dict["paypalAccount"] as! String)
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
    
    @objc func addVeterinarianBankInfoWebService() {
        
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             ACName:
             BankName:
             AccountNo:
             RoutingNo:
             accountType:
             paypalAccount:
             PaypalEmail:"
             */
            
            let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! AddVaterinarianTableCell
            
                   parameters = [
                       "action"          :   "petparentregistration",
                       "userId"          :   String(myString),
                       "UTYPE"           :   "2",
                       
                       "ACName"           :   String(cell.txtYourName.text!),
                       "BankName"          :  String(cell.txtSelectBank.text!),
                    "AccountNo" : String(cell.txtBankAccountNumber.text!),
                       "RoutingNo"         :   String(cell.txtRoutingCode.text!),
                       "accountType"       :   String(cell.txtAccountType.text!),
                       "paypalAccount"     :   String(cell.txtAccountNumber.text!),
                       "PaypalEmail"       :   String(cell.txtEmailAddress.text!),
                   ]
        }
                
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
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                                   
                                
                                   
                                   
                                   
                                   
                                   
                                   if let myString = defaults.string(forKey: "key_first_time_vet_reg") {
                                       let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionId")
                                       self.navigationController?.pushViewController(push, animated: true)
                                   } else {
                                       defaults.setValue("first_time_ved_reg", forKey: "key_first_time_vet_reg")
                                       let alert = UIAlertController(title: "Ritevet", message: "Thank you for registering as a veterinarian, our management staff will review your submitted information and documents, once they complete the review process you will receive an email informing you that your registration process is complete and you can start using the App. You may also receive a phone call from one of our management staff to verify some of your submitted information. This process will take from 2 to14 days. Please feel free to email us at mailto:ritevet@ritevet.com or call us Monday-Sunday at 321-682-9800Monday - Sunday from 7:00 pm -10:00 pm US Eastern Standard Time. Please leave a message if you called us in different time or if we did not answer your call, we will get back to you within 48 hours", preferredStyle: UIAlertController.Style.alert)
                                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                                           
                                           let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionId")
                                           self.navigationController?.pushViewController(push, animated: true)
                                           
                                       }))
                                       
                                       self.present(alert, animated: true, completion: nil)
                                       
                                   }
                                       
                                
                                
                                   
                                   
                                   
                                   
                                
                                
                                
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

extension AddVeterinarianBankInfo: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return totalCellInTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:AddVaterinarianTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AddVaterinarianTableCell
        
        cell.backgroundColor = .clear
        
        cell.lblTitle.text = "Your income from the video chat(s) and/or your mobile service(s) will be deposited into this bank account."
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: cell.txtYourName, placeHolder: "Your Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSelectBank, placeHolder: "Bank Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtBankAccountNumber, placeHolder: "Bank Account Number", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSwitchNumberForAccounts, placeHolder: "Switch number for Account outside the US", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtRoutingCode, placeHolder: "Routing Code", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtAccountType, placeHolder: "Account Type", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtEmailAddress, placeHolder: "Registered Email", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtAccountNumber, placeHolder: "Account Number", cornerRadius: 20, color: .white)
        
        cell.txtYourName.delegate = self
        cell.txtSelectBank.delegate = self
        cell.txtBankAccountNumber.delegate = self
        cell.txtSwitchNumberForAccounts.delegate = self
        cell.txtRoutingCode.delegate = self
        cell.txtAccountType.delegate = self
        cell.txtEmailAddress.delegate = self
        cell.txtAccountNumber.delegate = self
        
        /****** FINISH BUTTON *********/
        Utils.buttonDR(button: cell.btnFinish, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        cell.btnFinish.addTarget(self, action: #selector(finishClickMethod), for: .touchUpInside)
        /****** SKIP BUTTON *********/
        Utils.buttonDR(button: cell.btnSkip, text: "SKIP", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        cell.btnSkip.addTarget(self, action: #selector(skipClickMethod), for: .touchUpInside)
        
        
        
        return cell
    }
    
    @objc func skipClickMethod() {
        
        let defaults = UserDefaults.standard
        
        if let myString = defaults.string(forKey: "key_first_time_vet_reg") {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionId")
            self.navigationController?.pushViewController(push, animated: true)
        } else {
            defaults.setValue("first_time_ved_reg", forKey: "key_first_time_vet_reg")
            let alert = UIAlertController(title: "Ritevet", message: "Thank you for registering as a veterinarian, our management staff will review your submitted information and documents, once they complete the review process you will receive an email informing you that your registration process is complete and you can start using the App. You may also receive a phone call from one of our management staff to verify some of your submitted information. This process will take from 2 to14 days. Please feel free to email us at mailto:ritevet@ritevet.com or call us Monday-Sunday at 321-682-9800Monday - Sunday from 7:00 pm -10:00 pm US Eastern Standard Time. Please leave a message if you called us in different time or if we did not answer your call, we will get back to you within 48 hours", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionId")
                self.navigationController?.pushViewController(push, animated: true)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @objc func finishClickMethod() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! AddVaterinarianTableCell
        
        if cell.txtYourName.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field Should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtSelectBank.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field Should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtBankAccountNumber.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field Should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtSwitchNumberForAccounts.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field Should not be empty.", dismissDelay: 1.5, completion:{})
        }
        else {
            self.addVeterinarianBankInfoWebService()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1200
    }
}

extension AddVeterinarianBankInfo: UITableViewDelegate {
    
}
