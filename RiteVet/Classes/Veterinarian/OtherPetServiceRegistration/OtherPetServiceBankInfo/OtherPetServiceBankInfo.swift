//
//  OtherPetServiceBankInfo.swift
//  RiteVet
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CRNotifications

class OtherPetServiceBankInfo: UIViewController ,UITextFieldDelegate {

    var getDictOtherPetServiceFromVeryFirstPage:Dictionary<AnyHashable, Any>!
    var getDictOtherPetServiceFromVerySecondPage:Dictionary<AnyHashable, Any>!
    var getDictOtherPetServiceFromVeryThirdPage:Dictionary<AnyHashable, Any>!
    
    let cellReuseIdentifier = "otherPetServiceBankInfoTableCell"
    
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
        
        /*
         var getDictOtherPetServiceFromVeryFirstPage:Dictionary<AnyHashable, Any>!
         var getDictOtherPetServiceFromVerySecondPage:Dictionary<AnyHashable, Any>!
         var getDictOtherPetServiceFromVeryThirdPage:Dictionary<AnyHashable, Any>!
         */
        //print(getDictOtherPetServiceFromVeryFirstPage as Any)
        //print(getDictOtherPetServiceFromVerySecondPage as Any)
        //print(getDictOtherPetServiceFromVeryThirdPage as Any)
        
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
    
    // MARK:- OTHER PET SERVICE (WEBSERVICE)
    @objc func otherPetServiceWB()
        /*
         action: petparentregistration
         userId:
         UTYPE:
         TypeOfService:
         otherService:
         typeOfPets:
         otherPet:
         VFirstName:
         VLastName:
         VLicenseNo:
         VState:
         VBusinessName:
         BusinessLicenseNo:
         VTaxID:
         VBusinessAddress:
         VBSuite:
         Vcity:
         stateId:
         VZipcode:
         VPhone:
         VEmail:
         YearInBusiness:
         typeOfBusiness:
         typeOfPetSetting:
         //typeOfPetSettingOther:
         ACName:
         BankName:
         AccountNo:
         RoutingNo:
         paypalAccount:
         PaypalEmail:
         latitude:
         longitude:
         */
    {
        
        //indicator.startAnimating()
        //self.disableService()
        
        //print(getDictOtherPetServiceFromVeryFirstPage as Any)
        //print(getDictOtherPetServiceFromVerySecondPage as Any)
        //print(getDictOtherPetServiceFromVeryThirdPage as Any)
        
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! OtherPetServiceBankInfoTableCell
        
        Utils.RiteVetIndicatorShow()
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"                :   "petparentregistration",
                "userId"                :   String(myString),
                "UTYPE"                 :   "3",

                // first page
                "TypeOfService"          :   (getDictOtherPetServiceFromVeryFirstPage["typeofservice"] as! String),
                "otherService"           :   (getDictOtherPetServiceFromVeryFirstPage["typeofServiceComment"] as! String),//
                "typeOfPets"             :   (getDictOtherPetServiceFromVeryFirstPage["typeofpet"] as! String),
                "otherPet"               :   "",
                
                // second page
                "VFirstName" :(getDictOtherPetServiceFromVerySecondPage["firstname"] as! String),
                "VLastName":(getDictOtherPetServiceFromVerySecondPage["lastname"] as! String),
                "VLicenseNo":(getDictOtherPetServiceFromVerySecondPage["licensenumber"] as! String),
                "VState":(getDictOtherPetServiceFromVerySecondPage["state"] as! String),
                "VBusinessName":(getDictOtherPetServiceFromVerySecondPage["businessname"] as! String),
                "BusinessLicenseNo":(getDictOtherPetServiceFromVerySecondPage["businesslicensenumber"] as! String),
                "VTaxID":(getDictOtherPetServiceFromVerySecondPage["ientax"] as! String),
                
                // third
                "VBusinessAddress":(getDictOtherPetServiceFromVeryThirdPage["streetaddress"] as! String),
                "VBSuite":(getDictOtherPetServiceFromVeryThirdPage["suit"] as! String),
                "Vcity":(getDictOtherPetServiceFromVeryThirdPage["city"] as! String),
                "stateId":(getDictOtherPetServiceFromVeryThirdPage["state"] as! String),
                "VZipcode":(getDictOtherPetServiceFromVeryThirdPage["zipcode"] as! String),
                "VPhone":(getDictOtherPetServiceFromVeryThirdPage["phone"] as! String),
                "VEmail":(getDictOtherPetServiceFromVeryThirdPage["email"] as! String),
                "YearInBusiness":(getDictOtherPetServiceFromVeryThirdPage["yearinbusiness"] as! String),
                "typeOfBusiness":(getDictOtherPetServiceFromVeryThirdPage["typeofyourbusiness"] as! String),
                "typeOfPetSetting":(getDictOtherPetServiceFromVeryThirdPage["typeofpetsetting"] as! String),
                
                // fourth
                "ACName":String(cell.txtYourName.text!),
                "BankName":String(cell.txtSelectBank.text!),
                "AccountNo":String(cell.txtBankAccountNumber.text!),
                "RoutingNo":String(cell.txtRoutingCode.text!),
                "paypalAccount":String(cell.txtAccountType.text!),
                "PaypalEmail":String(cell.txtEmailAddress.text!),
                "latitude":String("lat"),
                "longitude":String("long"),
                
               
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
                            
                            var strSuccessAlert : String!
                            strSuccessAlert = JSON["msg"]as Any as? String
                            
                            if strSuccess == "success" //true
                            {
                                //self.enableService()
                                
                                //self.indicator.stopAnimating()
                                Utils.RiteVetIndicatorHide()
                                CRNotifications.showNotification(type: CRNotifications.success, title: "Hurray!", message:strSuccessAlert!, dismissDelay: 1.5, completion:{})
                                
                                //self.pushToDashboard()
                                
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
        self.navigationController?.pushViewController(push!, animated: true)
                            }
                            else
                            {
                                //self.indicator.stopAnimating()
                                Utils.RiteVetIndicatorHide()
                                //self.enableService()
                            }
                            
                        }

                        case .failure(_):
                            print("Error message:\(String(describing: response.error))")
                            //self.indicator.stopAnimating()
                            Utils.RiteVetIndicatorHide()
                            //self.enableService()
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

extension OtherPetServiceBankInfo: UITableViewDataSource
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
        let cell:OtherPetServiceBankInfoTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! OtherPetServiceBankInfoTableCell
        
        cell.backgroundColor = .clear
        
        cell.lblTitle.text = "This information is needed to deposit your share of the company profit at the end of each year. If you are a virtual veterinarian your earning will be deposited to this account."
        
        /****** TEXT FIELDS *********/
        Utils.textFieldDR(text: cell.txtYourName, placeHolder: "Your Name", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSelectBank, placeHolder: "Select Bank", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtBankAccountNumber, placeHolder: "Bank Account Number", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSwitchNumberForAccounts, placeHolder: "Switch number for accounts outside the US", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtRoutingCode, placeHolder: "Routing Code", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtAccountType, placeHolder: "Account Type", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtEmailAddress, placeHolder: "Email address", cornerRadius: 20, color: .white)
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
        
        return cell
    }
    
    @objc func finishClickMethod() {
        self.otherPetServiceWB()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
}

extension OtherPetServiceBankInfo: UITableViewDelegate
{
    
}
