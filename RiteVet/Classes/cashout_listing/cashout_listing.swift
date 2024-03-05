//
//  cashout_listing.swift
//  RiteVet
//
//  Created by Dishant Rajput on 31/05/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView

class cashout_listing: UIViewController {
    
    var str_product_wallet:String!
    var str_veterian_wallet:String!
    
    var str_user_select:String! = ""
    
    var str_type:String!
    
    var arr_cashout_listing:Array<Any>!
    //    var arr_cashout_listing:NSMutableArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Cashout Requests"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_cashout:UIButton! {
        didSet {
            btn_cashout.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btn_cashout.layer.cornerRadius = 20
            btn_cashout.clipsToBounds = true
            btn_cashout.setTitle("Cashout", for: .normal)
            btn_cashout.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            //            tbleView.delegate = self
            //            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(self.str_product_wallet)
        // print(self.str_veterian_wallet)
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btn_cashout.addTarget(self, action: #selector(cashout_click_method), for: .touchUpInside)
        
        /*  let originalDate = Date()
        let offsetInSeconds = 3600  // 1 hour
        if let modifiedDate = changeDateByOffset(originalDate: originalDate, offsetInSeconds: offsetInSeconds) {
            print("Original Date: \(originalDate)")
            print("Modified Date: \(modifiedDate)")
        } else {
            print("Error changing date.")
        }*/
        
        
        
        
        // import Foundation

        let formatter = DateFormatter()
        formatter.dateFormat = "ZZZZZ"

        // Assuming originalTime is in UTC
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let originalTime = formatter.date(from: "+05:30")!

        // Specify the original time zone
        let originalTimeZone = TimeZone(identifier: "IST")!

        // Specify the target time zone (local time zone)
        let targetTimeZone = TimeZone.current

        // Convert originalTime to target time zone
        let convertedTime = originalTime.addingTimeInterval(TimeInterval(originalTimeZone.secondsFromGMT(for: originalTime) - targetTimeZone.secondsFromGMT()))

        // Format the converted time
        formatter.timeZone = targetTimeZone
        let formattedConvertedTime = formatter.string(from: convertedTime)

        print("Formatted converted time: \(formattedConvertedTime)")

        
        // import Foundation

       

        // Example: Get the current time for UTC+5 offset
        let currentTime = getCurrentTimeFromUTCOffset(offset: -5)
        print("Current time with UTC+5 offset: \(currentTime)")

        
    }
    
    func get_Date_time_from_UTC_time(string : String) -> String {
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        dateformattor.timeZone = NSTimeZone.local
        let dt = string
        let dt1 = dateformattor.date(from: dt as String)
        dateformattor.dateFormat = "yyyy-MM-dd HH:mm"
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone?
        return dateformattor.string(from: dt1!)
      }
    
    func getCurrentTimeFromUTCOffset(offset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Get the current date
        var currentDate = Date()
        
        // Get the time interval for the offset
        let offsetTimeInterval = TimeInterval(offset * 60 * 60)
        
        // Adjust the current date based on the offset
        currentDate = currentDate.addingTimeInterval(offsetTimeInterval)
        
        // Convert the adjusted date to a string
        let dateString = dateFormatter.string(from: currentDate)
        
        return dateString
    }
      
    @objc func cashout_click_method() {
        self.pet_parent_WB()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.veterianrianRegistration()
        
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
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "cashoutlist",
                "userId"    : String(myString),
                "type"      : String(self.str_type),
                "pageNo"    : "",
                
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
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        if ar.count == 0 {
                            let alert = UIAlertController(title: "Alert", message: "No cashout request yet.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                
                                // self.navigationController?.popViewController(animated: true)
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            
                            self.arr_cashout_listing = (ar as! Array<Any>)
                            
                            // print(self.arr_cashout_listing.count)
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                        }
                        
                        Utils.RiteVetIndicatorHide()
                        
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
    
    @objc func pet_parent_WB() {
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
                "UTYPE"     : "1"
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
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>

                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "1"
                            // Utils.RiteVetIndicatorHide()
                            self.what_type_of_reg(str_value: "1")
                        } else {
                            self.check_vet_reg()
                        }
                        
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
    
    @objc func check_vet_reg() {
        // indicator.startAnimating()
        // Utils.RiteVetIndicatorShow()
           
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
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>

                        // self.str_pet_data = (dict["VFirstName"] as! String)
                        
                        
                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "2"
                            // Utils.RiteVetIndicatorHide()
                            self.what_type_of_reg(str_value: "2")
                            
                        } else {
                            self.check_vet_reg_other()
                        }
                        
                        
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
    
    @objc func check_vet_reg_other() {
        
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "returnprofile",
                "userId"    : String(myString),
                "UTYPE"     : "3"
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
                        
                         var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                          
                        if "\(dict["userInfoId"]!)" != "" {
                            
                            self.str_user_select = "3"
                            // Utils.RiteVetIndicatorHide()
                            self.what_type_of_reg(str_value: "3")
                        } else {
                            
                            Utils.RiteVetIndicatorHide()
                            self.what_type_of_reg(str_value: "0")
                            
                        }
                        
                        
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
    
    @objc func what_type_of_reg(str_value:String) {
        print(str_value)
        
        if (str_value == "0") {
            Utils.RiteVetIndicatorHide()
            let alertController = UIAlertController(title: "Alert", message: "You have to register first to access this feature", preferredStyle: .actionSheet)
                           
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.get_vet(type: str_value)
        }
        
    }
    
    @objc func get_vet(type:String) {
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "profile",
                "userId"    : String(myString),
                // "UTYPE"     : String(type)
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
                        
                         var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                          
                        if (dict["accountNo"] as! String == "") {
                            
                            let alertController = UIAlertController(title: "Alert", message: "Your bank account details are empty. Please complete that process from your registration portal.", preferredStyle: .actionSheet)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                        } else {
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cashout_pay_id") as? cashout_pay
                            
                            push!.str_type_2 = String(self.str_type)
                            push!.str_product_wallet = String(self.str_product_wallet)
                            push!.str_veterian_wallet = String(self.str_veterian_wallet)
                            
                            self.navigationController?.pushViewController(push!, animated: true)
                        }
                        
                        
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
    
    
    
    
}


extension cashout_listing: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_cashout_listing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:cashout_listing_table_cell = tableView.dequeueReusableCell(withIdentifier: "cashout_listing_table_cell") as! cashout_listing_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_cashout_listing[indexPath.row] as? [String:Any]
        print(item as Any)
        // "created": 2024-03-04 20:22:00,
        
        var dict: Dictionary<AnyHashable, Any>
        dict = item!["timezone"] as! Dictionary<AnyHashable, Any>
        cell.lbl_date.text = Utils.convert_server_date_time_from_UTC(string: (item!["created"] as! String),
                                                                    tz: "\(dict["UTC_GMT"]!)")
        
        
        
        cell.lbl_amount.text = "Amount : $\(item!["Request_Amount"]!)"
        
        if "\(item!["Approve_Amount"]!)" == "0" {
            
            cell.lbl_status.text = "Pending"
            cell.lbl_status.textColor = .white
            cell.view_status.backgroundColor = .systemRed
            
        } else {
            
            cell.lbl_status.text = "Paid"
            cell.lbl_status.textColor = .black
            cell.view_status.backgroundColor = .systemGreen
            
        }
        
//        cell.btn_withdraw_product_wallet.addTarget(self, action: #selector(withdraw_click_method), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
//        let item = self.arr_cashout_listing[indexPath.row] as? [String:Any]
//
//        if "\(item!["Approve_Amount"]!)" == "0" {
//
//
//
//        }
        
        
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
 
class cashout_listing_table_cell: UITableViewCell {

    @IBOutlet weak var view_status:UIView! {
        didSet {
            view_status.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_status.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_status.layer.shadowOpacity = 1.0
            view_status.layer.shadowRadius = 15.0
            view_status.layer.masksToBounds = false
            view_status.layer.cornerRadius = 15
            view_status.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_date:UILabel!
    @IBOutlet weak var lbl_amount:UILabel!
    @IBOutlet weak var lbl_status:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
