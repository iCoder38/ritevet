//
//  booking_details.swift
//  RiteVet
//
//  Created by Dishant Rajput on 26/05/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import FirebaseFirestoreInternal

class appointment_details: UIViewController {

    var str_from_booking:String!
    
    var str_get_booking_id:String!
    
    var dictBookingDetails:NSDictionary!
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 45
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderColor = NAVIGATION_BACKGROUND_COLOR.cgColor
            imgProfile.layer.borderWidth = 3.0
        }
    }
    
    @IBOutlet weak var lbl_Name:UILabel!
    @IBOutlet weak var lbl_address:UILabel!
    @IBOutlet weak var lbl_email:UILabel!
    
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Details"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // tbleView.delegate = self
            // tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    var str_vendor_name:String!
    var str_vendor_id:String!
    var str_vendor_image:String!
    var str_vender_device_token:String!
    var str_vendor_device_name:String!
    
    var str_caller_name:String!
    var str_caller_id:String!
    var str_caller_image:String!
    var str_caller_device_token:String!
    var str_caller_device_name:String!
    
    var str_enable_calling:String! = "0"
    
    var str_time_save:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbleView.separatorColor = .clear
        
        self.btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.tintColor = .white
        
        
        
        print("============================")
        print(self.dictBookingDetails as Any)
        print("============================")
        
        print(utcToLocal(dateStr: self.dictBookingDetails["current_time_zone"] as! String))
        
        
        /*
         UTYPE = 2;
         bookingDate = "2023-12-18T00:00:00+0530";
         bookingID = 387;
         contactNumber = 9898765432;
         created = "Dec 18th, 2023, 1:54 pm";
         device = iOS;
         deviceToken = "";
         firebaseId = "";
         slotTime = "17:30-18:00";
         status = 2;
         totalAmount = 70;
         transactionId = "tok_1OOc8BIccD3egFe4PNHKULB2";
         typeofbusinessId = 3;
         typeofbusinessName = "Virtual Veterinarian (Video Chat)";
         userAddress = "C Block, Ramprastha";
         userEmail = "purnimaevs@gmail.com";
         userID = 196;
         userImage = "";
         userName = "VetAA1 pandey";
         vendorID = 54;
         
         // appointments
         UTYPE = 2;
         bookingDate = "2023-12-18T00:00:00+0530";
         bookingID = 386;
         contactNumber = 989099765439;
         created = "Dec 18th, 2023, 1:46 pm";
         device = iOS;
         deviceToken = "";
         firebaseId = "";
         slotTime = "13:30-14:00";
         status = 2;
         totalAmount = 15;
         transactionId = "tok_1OOc07IccD3egFe44vPwgtpJ";
         typeofbusinessId = 3;
         typeofbusinessName = "Virtual Veterinarian (Video Chat)";
         userAddress = "c 34, ramprasta";
         userEmail = "pn1@mailinator.com";
         userID = 196;
         userImage = "https://ritevet.com/img/uploads/users/1701949449_0dc57b8d66c12736c666f157a3afa3ff.jpg";
         userName = parent1;
         vendorID = 193;
         */
    }

    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.appointment()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func appointment() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"        :  "bookingdetail",
                "userId"        :  myString,
                "bookingId"     :  "\(self.dictBookingDetails["bookingID"]!)",
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
                    
                    if strSuccess == "Success" {
                        Utils.RiteVetIndicatorHide()
                        
                        self.dictBookingDetails = (JSON["data"] as! NSDictionary)
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        
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
    
    
    /*[action] => bookingcomplete
        [bookingId] => 34
        [userId] => 54
        [status] => 2*/
    
    @objc func pending_click_method() {
        
        let alert = UIAlertController(title: "Alert : Completed", message: "Are you sure the appointment has been completed?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes, completed", style: .default, handler: { action in
            
            self.mark_as_delivered()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func mark_as_delivered() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "bookingcomplete",
                "userId"    : myString,
                "bookingId" : String(self.str_get_booking_id),
                "status"    : "2"
                
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
                    
                    if strSuccess == "Success" {
                        Utils.RiteVetIndicatorHide()
                        
                        let alert = UIAlertController(title: "Alert", message: JSON["msg"] as? String, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
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
    
    
    @objc func cancel_click_method() {
        
        let alert = UIAlertController(title: "Alert : Cancel", message: "Are you sure you want to cancel ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes, cancel", style: .destructive, handler: { action in
            
            self.cancel_this_product()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func cancel_this_product() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)

            parameters = [
                "action"    : "bookingcomplete",
                "userId"    : myString,
                "bookingId" : String(self.str_get_booking_id),
                "status"    : "3"
                
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
                    
                    if strSuccess == "Success" {
                        Utils.RiteVetIndicatorHide()
                        
                        let alert = UIAlertController(title: "Alert", message: JSON["msg"] as? String, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
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
    
    @objc func delivered_click_method() {
        
        //
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "send_review_id") as? send_review
         
        push!.dict_send_review_details = self.dictBookingDetails
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}

extension appointment_details: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:appointment_details_table_cell = tableView.dequeueReusableCell(withIdentifier: "appointment_details_table_cell") as! appointment_details_table_cell
        
        cell.backgroundColor = .clear
        
        if (self.str_from_booking == "yes") {
            
            self.lbl_Name.text = (self.dictBookingDetails["vendorName"] as! String)
            self.lbl_email.text = (self.dictBookingDetails["vendorEmail"] as! String)
            self.lbl_address.text = (self.dictBookingDetails["vendorAddress"] as! String)
            self.imgProfile.sd_setImage(with: URL(string: (self.dictBookingDetails["vendorImage"] as! String)), placeholderImage: UIImage(named: "logo-500"))
            
            // cell.btn_next.addTarget(self, action: #selector(delivered_click_method), for: .touchUpInside)
            
        } else {
            
            self.lbl_Name.text = (self.dictBookingDetails["userName"] as! String)
            self.lbl_email.text = (self.dictBookingDetails["userEmail"] as! String)
            self.lbl_address.text = (self.dictBookingDetails["userAddress"] as! String)
            self.imgProfile.sd_setImage(with: URL(string: (self.dictBookingDetails["userImage"] as! String)), placeholderImage: UIImage(named: "logo-500"))
            
        }
        
        
        if let array = self.dictBookingDetails["serviceArray"] as? [String] {
//            print(array)
            
            let productIDString = array.joined(separator: ",")
//            print(productIDString)
            
            var myString = productIDString
            myString = myString.replacingOccurrences(of: ",", with: ",\n")
            
            cell.lbl_services.text = String(myString)
        }
        
        let server_booking_date = String((self.dictBookingDetails["bookingDate"] as! String).prefix(10))
        cell.lbl_appointment_date.text = String(server_booking_date)
        
        cell.lbl_appointment_time.text = (self.dictBookingDetails["slotTime"] as! String)
        cell.lbl_type_of_services.text = (self.dictBookingDetails["typeofbusinessName"] as! String)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            if (String(myString) == "\(self.dictBookingDetails["userID"]!)") {
                
                // PATIENT SIDE
                print("BOOKER ID")
                
                /*
                 "keyword_1" = IST; patient zone
                 "keyword_2" = "GMT-5"; // doctor zone
                 "keyword_3" = "2024-03-01"; // booking date
                 */
                print(self.dictBookingDetails as Any)
                print(self.dictBookingDetails["keyword_1"] as! String)
                print(self.dictBookingDetails["keyword_2"] as! String)
                print(self.dictBookingDetails["keyword_3"] as! String)
                
                let current_time_patient = Date.getTimeForTimeZone()
                print(current_time_patient as Any)
                
                // compare patient date with doctor
                let timeFormatterGet = DateFormatter()
                timeFormatterGet.dateFormat = "yyyy-MM-dd hh:mm a"
                // timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
                timeFormatterGet.timeZone = TimeZone(abbreviation: self.dictBookingDetails["keyword_1"] as! String)
                
                let timeFormatterPrint = DateFormatter()
                timeFormatterPrint.dateFormat = "yyyy-MM-dd hh:mm a"
                timeFormatterPrint.timeZone = TimeZone(abbreviation: self.dictBookingDetails["keyword_2"] as! String)
                
                var str_what_we_get_date:String! = self.dictBookingDetails["keyword_3"] as! String+" "+String(current_time_patient)
                print(str_what_we_get_date as Any)
                
                if let date = timeFormatterGet.date(from: String(str_what_we_get_date) ) {
                    print(timeFormatterPrint.string(from: date))
                    str_what_we_get_date = "\(timeFormatterPrint.string(from: date))"
                } else {
                    print("There was an error decoding the string")
                }
                
                print(str_what_we_get_date as Any)
                
                // separate doctor's date
                let separate_doctors_date = str_what_we_get_date.components(separatedBy: " ")

                let doctor_date = separate_doctors_date[0]
                print(doctor_date as Any)
                
                // patient current booking date
                let patient_current_date = Date.getCurrentDateReal()
                print(patient_current_date as Any)
                
                if (doctor_date == patient_current_date) {
                    print("DOCTOR'S DATE AND BOOKER DATES ARE SAME")
                    
                    // activate cancel button
                    cell.btn_cancel.addTarget(self, action: #selector(cancel_click_method), for: .touchUpInside)
                    
                    if "\(self.dictBookingDetails["status"]!)" == "1" {
                        
                        cell.btn_next.setTitle("Pending", for: .normal)
                        cell.btn_next.backgroundColor = .systemOrange
                        
                        if (self.str_from_booking != "yes") {
                            cell.btn_next.addTarget(self, action: #selector(pending_click_method), for: .touchUpInside)
                        }
                        
                        
                    } else if "\(self.dictBookingDetails["status"]!)" == "2" {
                        
                        cell.btn_next.setTitle("Completed", for: .normal)
                        cell.btn_next.backgroundColor = .systemGreen
                        cell.btn_cancel.isHidden = true
                        cell.btn_next.isUserInteractionEnabled = false
                        
                        if (self.str_from_booking == "yes") {

                            if "\(self.dictBookingDetails["reviewByYou"]!)" == "0" {
                                
                                cell.btn_next.isUserInteractionEnabled = true
                                cell.btn_next.backgroundColor = .systemYellow
                                cell.btn_next.setTitle("Send Review", for: .normal)
                                cell.btn_next.addTarget(self, action: #selector(delivered_click_method), for: .touchUpInside)
                                
                            } else {
                                
                                cell.btn_next.setTitle("Completed", for: .normal)
                                cell.btn_next.isUserInteractionEnabled = false
                                
                            }
                            
                        }
                        
                    }  else if "\(self.dictBookingDetails["status"]!)" == "3" {
                        
                        cell.btn_next.setTitle("Cancelled", for: .normal)
                        cell.btn_next.backgroundColor = .systemRed
                        cell.btn_cancel.isHidden = true
                    }
                    
                    if "\(self.dictBookingDetails["typeofbusinessId"]!)" == "2" {
                     
                        cell.btn_video.isHidden = true
                        
                    } else if "\(self.dictBookingDetails["typeofbusinessId"]!)" == "3" {
                        
                        cell.btn_video.isHidden = false
                        
                    }
                    
                    
                    
                    // you have to check time now from doctor's time to patient's time
                    //
                    
                    var str_separate_appointment_slot_time = (self.dictBookingDetails["slotTime"] as! String)
                    
                    let str_separate_appointment_slot_time_space = str_separate_appointment_slot_time.components(separatedBy: "-")
                    print(str_separate_appointment_slot_time_space as Any)
                    
                    let doctor_slot_time_one = str_separate_appointment_slot_time_space[0]
                    let doctor_slot_time_two = str_separate_appointment_slot_time_space[1]
                    
                    print(doctor_slot_time_one as Any)
                    print(doctor_slot_time_two as Any)
                    
                    print(Date.get24TimeForTimeZone())
                    
                    // compare doctor's time with patient's time slot
                    let timeFormatterGet2 = DateFormatter()
                    timeFormatterGet2.dateFormat = "yyyy-MM-dd hh:mm a"
                    // timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
                    timeFormatterGet2.timeZone = TimeZone(abbreviation: self.dictBookingDetails["keyword_1"] as! String)
                    
                    let timeFormatterPrint2 = DateFormatter()
                    timeFormatterPrint2.dateFormat = "yyyy-MM-dd hh:mm a"
                    timeFormatterPrint2.timeZone = TimeZone(abbreviation: self.dictBookingDetails["keyword_2"] as! String)
                    
                    var str_what_we_get_date:String! = self.dictBookingDetails["keyword_3"] as! String+" "+String(current_time_patient)
                    print(str_what_we_get_date as Any)
                    
                    if let date = timeFormatterGet.date(from: String(str_what_we_get_date)) {
                        print(timeFormatterPrint.string(from: date))
                        str_what_we_get_date = "\(timeFormatterPrint.string(from: date))"
                    } else {
                        print("There was an error decoding the string")
                    }
                    
                    
                    
                    
                } else {
                    print("DOCTOR'S DATE AND BOOKER DATES ARE DIFFERENT")
                }
                
                
                
                print("stop breakpoint")
                // current date
                /*let dateformatter2 = DateFormatter()
                dateformatter2.dateFormat = "yyyy-MM-dd"
                let current_date = dateformatter2.string(from: Date())
                print("Date Selected \(current_date)")
                
                
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let today_current_date = formatter.date(from: "\(current_date)")
                let booking_date = formatter.date(from: String(server_booking_date))

                // print(today_current_date)
                // print(booking_date)
                
                
                // same
                if today_current_date?.compare(booking_date!) == .orderedSame {
                    print("Both dates are same")
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let current_date = dateFormatter.string(from: date)
                    print("current time --> ",current_date)
                    
                    let prefix_time = String((self.dictBookingDetails["slotTime"] as! String).prefix(05))
                    print("server time --> ",prefix_time)
                    
                    let prefix_one = String(current_date.prefix(02))
                    let prefix_two = String(prefix_time.prefix(02))
                    print(prefix_one)
                    print(prefix_two)
                    
                    let double_c_t = Double(prefix_one)
                    let double_s_t = Double(prefix_two)
                    
                    // print(double_c_t)
                    // print(double_s_t)
                    
                    let deduct_time = double_s_t! - double_c_t!
                    print(deduct_time," hours left")
                    
                    cell.btn_cancel.isHidden = false
                    
                    if deduct_time == 0.0 || deduct_time == 1.0 || deduct_time == 2.0  {
                        print(" HIDE CANCEL BUTTON : ")
                        
                        cell.btn_cancel.isHidden = true
                    }
                    
                    var str_check = String("\(deduct_time.toString())".prefix(01))
                    // print(str_check)
                    
                    if (str_check) == "-" {
                        cell.btn_cancel.isHidden = true
                    }
                    
                }
                
                // "Today's Date is greater then second date"
                if (today_current_date?.compare(booking_date!)) == .orderedDescending {
                    print("Today's date is greater then Booking date")
                    
                    cell.btn_cancel.isHidden = true
                    
                }
                
                // "Today's Date is lower then second date"
                if (today_current_date?.compare(booking_date!)) == .orderedAscending {
                    print("Today's date is lower then Booking date")
                    
                    cell.btn_cancel.isHidden = false
                    
                }
                
                // activate cancel button
                cell.btn_cancel.addTarget(self, action: #selector(cancel_click_method), for: .touchUpInside)
                
                
                if "\(self.dictBookingDetails["status"]!)" == "1" {
                    
                    cell.btn_next.setTitle("Pending", for: .normal)
                    cell.btn_next.backgroundColor = .systemOrange
                    
                    if (self.str_from_booking != "yes") {
                        cell.btn_next.addTarget(self, action: #selector(pending_click_method), for: .touchUpInside)
                    }
                    
                    
                } else if "\(self.dictBookingDetails["status"]!)" == "2" {
                    
                    cell.btn_next.setTitle("Completed", for: .normal)
                    cell.btn_next.backgroundColor = .systemGreen
                    cell.btn_cancel.isHidden = true
                    cell.btn_next.isUserInteractionEnabled = false
                    
                    if (self.str_from_booking == "yes") {

                        if "\(self.dictBookingDetails["reviewByYou"]!)" == "0" {
                            
                            cell.btn_next.isUserInteractionEnabled = true
                            cell.btn_next.backgroundColor = .systemYellow
                            cell.btn_next.setTitle("Send Review", for: .normal)
                            cell.btn_next.addTarget(self, action: #selector(delivered_click_method), for: .touchUpInside)
                            
                        } else {
                            
                            cell.btn_next.setTitle("Completed", for: .normal)
                            cell.btn_next.isUserInteractionEnabled = false
                            
                        }
                        
                    }
                    
                }  else if "\(self.dictBookingDetails["status"]!)" == "3" {
                    
                    cell.btn_next.setTitle("Cancelled", for: .normal)
                    cell.btn_next.backgroundColor = .systemRed
                    cell.btn_cancel.isHidden = true
                }
                
                if "\(self.dictBookingDetails["typeofbusinessId"]!)" == "2" {
                 
                    cell.btn_video.isHidden = true
                    
                } else if "\(self.dictBookingDetails["typeofbusinessId"]!)" == "3" {
                    
                    cell.btn_video.isHidden = false
                    
                }
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let current_time = dateFormatter.string(from: date)
                print("current time -->",current_time)
                
                
                let f = DateFormatter()
                f.dateFormat = "HH:mm"
                
                
                 // 7:59
                // let f2 = DateFormatter()
                // f2.dateFormat = "HH:mm"
                
                let fullName    = (self.dictBookingDetails["slotTime"] as! String)
                let fullNameArr = fullName.components(separatedBy: "-")

                let name    = fullNameArr[0]
                let time_one = String(name) // 7
                
                
                let surname = fullNameArr[1]
                // time 2
                let time_two = String(surname)
                
                print(time_one as Any)
                print(time_two as Any)
                
                // current time
                f.date(from: current_time)
                
                // time start
                f.date(from: time_one)
                
                // time end
                f.date(from: time_two)
                
                self.str_time_save = (self.dictBookingDetails["slotTime"] as! String)
                
                if (f.date(from: current_time)! > f.date(from: time_one)!) {
                    print("CURRENT TIME IS GREATER THEN TIME ONE")
                    self.str_enable_calling = "0"
                    // time 2
                    // this time should be lower then time 2
                    if (f.date(from: current_time)! > f.date(from: time_two)!) {
                        print("CURRENT TIME IS GREATER THEN TIME TWO")
                        self.str_enable_calling = "0"
                        
                        // print("USER HAVE SOME MORE TIME TO CALL")
                    } else if (f.date(from: current_time)! < f.date(from: time_two)!) {
                        print("ENABLE CALLING TIME")
                        self.str_enable_calling = "1"
                    }
                    
                } else  if (f.date(from: current_time)! < f.date(from: time_one)!) {
                    print("TIME ONE IS GREATER THEN CURRENT TIME")
                    print("DISBALED CALLING OPTIONS")
                    self.str_enable_calling = "0"
                } else {
                    print("DIFFERENT DATA")
                    self.str_enable_calling = "0"
                }*/
                
            } else {
                
                
                
                // DOCTOR SIDE
                print("============================")
                print(self.dictBookingDetails as Any)
                print("============================")
                let get_booking_date_from_patient = String((self.dictBookingDetails["bookingDate"] as! String).prefix(10))
                print(get_booking_date_from_patient as Any)
                
                
                // check doctor' location current date is equal to patient's date
                let doctor_current_location_date = Date.getCurrentDateReal()
                print(doctor_current_location_date as Any)
                
                if String(get_booking_date_from_patient) == String(doctor_current_location_date) {
                    print("DOCTOR AND PATIENT DATE ARE SAME")
                } else {
                    print("DOCTOR AND PATIENT DATE ARE DIFFERENT")
                }
                
                
                
                
                
                
                
                
                // check patient's date and doctor's date is same or not
                /*let timeFormatterGet = DateFormatter()
                timeFormatterGet.dateFormat = "yyyy-MM-dd"
                timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
                
                let timeFormatterPrint = DateFormatter()
                timeFormatterPrint.dateFormat = "yyyy-MM-dd"
                timeFormatterPrint.timeZone = TimeZone(abbreviation: (self.dictBookingDetails["current_time_zone"] as! String))
                
                // doctor's current location date
                
                if let date = timeFormatterGet.date(from: doctor_current_location_date) {
                    print(timeFormatterPrint.string(from: date))
                    
                    
                    if String(doctor_current_location_date) == "\(date)" {
                        print("BOTH DATES ARE SAME")
                    } else {
                        print("BOTH DATES ARE DIFFERENT")
                        
                        
                        
                    }
                    
                } else {
                   print("There was an error decoding the string")
                }*/
                
                cell.btn_video.isHidden = false
                
                
                if "\(self.dictBookingDetails["status"]!)" == "1" {
                    
                    cell.btn_next.setTitle("Pending", for: .normal)
                    cell.btn_next.backgroundColor = .systemOrange
                    
                    if (self.str_from_booking != "yes") {
                        cell.btn_next.addTarget(self, action: #selector(pending_click_method), for: .touchUpInside)
                    }
                    
                    
                } else if "\(self.dictBookingDetails["status"]!)" == "2" {
                    
                    cell.btn_next.setTitle("Completed", for: .normal)
                    cell.btn_next.backgroundColor = .systemGreen
                    cell.btn_cancel.isHidden = true
                    cell.btn_next.isUserInteractionEnabled = false
                    
                    if (self.str_from_booking == "yes") {

                        if "\(self.dictBookingDetails["reviewByYou"]!)" == "0" {
                            
                            cell.btn_next.isUserInteractionEnabled = true
                            cell.btn_next.backgroundColor = .systemYellow
                            cell.btn_next.setTitle("Send Review", for: .normal)
                            cell.btn_next.addTarget(self, action: #selector(delivered_click_method), for: .touchUpInside)
                            
                        } else {
                            
                            cell.btn_next.setTitle("Completed", for: .normal)
                            cell.btn_next.isUserInteractionEnabled = false
                            
                        }
                        
                    }
                    
                }  else if "\(self.dictBookingDetails["status"]!)" == "3" {
                    
                    cell.btn_next.setTitle("Cancelled", for: .normal)
                    cell.btn_next.backgroundColor = .systemRed
                    cell.btn_cancel.isHidden = true
                }
                
            }
                
            
        }
        
        
        
        
        
        
        
        
        
        cell.btn_chat.addTarget(self, action: #selector(one_to_one_chat_click_method), for: .touchUpInside)
        cell.btn_audio.addTarget(self, action: #selector(audio_call_click_method), for: .touchUpInside)
        cell.btn_video.addTarget(self, action: #selector(video_chat_click_method), for: .touchUpInside)
        
        return cell
    }
    
    @objc func check_booking_date_and_doctor_current_location_date() {
        print("============================")
        print(self.dictBookingDetails as Any)
        print("============================")
        
        /*
         UTYPE = 2;
         "added_time" = "2024-02-29 14:09:00";
         bookingDate = "2024-02-29T00:00:00+0530";
         bookingID = 488;
         contactNumber = 9865888080;
         created = "Feb 29th, 2024, 2:09 pm";
         "current_time_zone" = IST;
         device = iOS;
         deviceToken = "";
         firebaseId = "";
         slotTime = "20:00-20:30";
         status = 1;
         totalAmount = 70;
         transactionId = "tok_1Op590KjKY5Kxs7IeTS75GG1";
         typeofbusinessId = 3;
         typeofbusinessName = "Virtual Veterinarian (Video Chat)";
         userAddress = "c block surya";
         userEmail = "doc@mailinator.com";
         userID = 713;
         userImage = "";
         userName = "doc new";
         vendorID = 665;
         */
        
        // let current_user_
        let timeFormatterGet = DateFormatter()
        timeFormatterGet.dateFormat = "yyyy-MM-dd"
        // timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
        timeFormatterGet.timeZone = TimeZone(abbreviation: "IST")
        
        let timeFormatterPrint = DateFormatter()
        timeFormatterPrint.dateFormat = "yyyy-MM-dd"
        timeFormatterPrint.timeZone = TimeZone(abbreviation: "NZST")
        
        // timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(TimeZone.current.abbreviation()!)\(TimeZone.current.currentTimezoneOffset())") // if you want to specify timezone for output, otherwise leave this line blank and it will default to devices timezone

        if let date = timeFormatterGet.date(from: "2024-01-31 5:00 PM") {
            print(timeFormatterPrint.string(from: date)) // "6:30 PM" if device in EST
        } else {
           print("There was an error decoding the string")
        }
    }
    
    
    
    @objc func one_to_one_chat_click_method() {
             
        if (self.str_enable_calling == "0") {
            
            let alert = UIAlertController(title: "Alert", message: "You can only chat between "+String(self.str_time_save)+" time slot.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            if (self.str_from_booking == "yes") {
                
                print(self.dictBookingDetails as Any)
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
                push!.receiverData = self.dictBookingDetails as NSDictionary?
                push!.fromDialog = "no"
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                // from appointment
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
                push!.receiverData = self.dictBookingDetails as NSDictionary?
                push!.fromDialog = "no"
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }

    }
    
    
    @objc func audio_call_click_method() {
        
        if (self.str_enable_calling == "0") {
            
            let alert = UIAlertController(title: "Alert", message: "You can only call between "+String(self.str_time_save)+" time slot.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.store_data_in_db_before_call(str_type: "audio")
         }
        
        // self.send_notification_to_doctor(str_get_type: "audiocall")
        
    }
    
    @objc func video_chat_click_method() {
       if (self.str_enable_calling == "0") {
            
            let alert = UIAlertController(title: "Alert", message: "You can only call between "+String(self.str_time_save)+" time slot.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.store_data_in_db_before_call(str_type: "video")
            // self.send_notification_to_doctor(str_get_type: "videocall")
         }
        
    }
    
    @objc func store_data_in_db_before_call(str_type:String) {
        print("Call button pressed")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            if (str_type == "audio") {
                
                let uuid = UUID().uuidString
                print(uuid)
                
                Firestore.firestore().collection(audio_call_collection_path).addDocument(data: [
                    
                    
                    "audio_call_id" : String(uuid),//"\(self.dictBookingDetails["bookingID"]!)",
                    "type"          : "audiocall",
                    "call_status"   : "calling",
                    
                ]){
                    (error) in
                    
                    if error != nil {
                        print("=====================================================================")
                        print("=====================================================================")
                        print("ERROR : \(error!)")
                        print("=====================================================================")
                        print("=====================================================================")
                    } else {
                        print("=====================================================================")
                        print("=====================================================================")
                        print("FIREBASE : DATA STORE SUCCESSFULLY. NOW SEND NOTIFICATION TO RECEIVER")
                        print("=====================================================================")
                        print("=====================================================================")
                        
                        // get data now
                        self.manage_data_before_send_notification(get_type: String(str_type), getCallId: String(uuid))
                    }
                }
                
            } else {
                
                let uuid = UUID().uuidString
                print(uuid)
                
                Firestore.firestore().collection(video_call_collection_path).addDocument(data: [
                    
                    
                    "video_call_id" : String(uuid),//"\(self.dictBookingDetails["bookingID"]!)",
                    "type"          : "videocall",
                    "call_status"   : "calling",
                    
                ]){
                    (error) in
                    
                    if error != nil {
                        print("=====================================================================")
                        print("=====================================================================")
                        print("ERROR : \(error!)")
                        print("=====================================================================")
                        print("=====================================================================")
                    } else {
                        print("=====================================================================")
                        print("=====================================================================")
                        print("FIREBASE : DATA STORE SUCCESSFULLY. NOW SEND NOTIFICATION TO RECEIVER")
                        print("=====================================================================")
                        print("=====================================================================")
                        
                        // get data now
                        self.manage_data_before_send_notification(get_type: String(str_type), getCallId: String(uuid))
                        
                    }
                }
                
            }
            
        }
        
    }
    
    func manage_data_before_send_notification(get_type:String,getCallId:String) {
        
        print("============================")
        print(self.dictBookingDetails as Any)
        print("============================")
        
        /*
         UTYPE = 2;
         bookingDate = "2024-01-08T00:00:00+0530";
         bookingID = 429;
         created = "Jan 8th, 2024, 5:33 pm";
         reviewByYou = 0;
         serviceArray =     (
             "General / Internal Medicine",
             Dental
         );
         slotTime = "18:30-19:00";
         status = 1;
         totalAmount = 20;
         transactionId = "tok_1OWHXlIccD3egFe4e62nIy4h";
         typeofbusinessId = 2;
         typeofbusinessName = "Mobile Clinic / Mobile Veterinarian";
         userAddress = "sector 10 Noida";
         userEmail = "parent@mailinator.com";
         userID = 273;
         userImage = "https://ritevet.com/img/uploads/users/1704712987PLUDIN_1703589341967.png";
         userName = "Pparent new";
         userNumber = 9852421884;
         userdevice = iOS;
         userdeviceToken = "ecqQOjjqkEjfjjORhKxl6D:APA91bGIYKKo6oxPpC8eJ-Rnf2coZWMVRd-rz7INSLMxuD4c0SOrtvbPoJdFETfNTmJMEy42LfxHBdzTC15WRL7QS3wG30uPi-6DPqFHVyDBxLz17Nl5QULao1umDSE_ejLEv5D5pPoB";
         userfirebaseId = "";
         vendorAddress = "New weat";
         vendorEmail = "advet@mailinator.com";
         vendorID = 272;
         vendorImage = "";
         vendorName = "Advet new";
         vendorNumber = 5466766767;
         vendordevice = iOS;
         vendordeviceToken = "e4XnHFi20kNNgG_3d7zy9z:APA91bGsiU8ei0kE9V95CVkdXzSNcTXyGCLu3_CAPApnPNbSGDlr5qJOmgsu-NDmdvYnJ-Ik3sD7A3YDPX9lQntmpMQsHFCyrO1YKGsIldlo7oS9iJcnhAHhzi6VKPIy6LgFz6b52vH_";
         vendorfirebaseId = "";
         */
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString as Any)
            if (String(myString)) == "\(self.dictBookingDetails["userID"]!)" {
                // parse vendor detaiils here ( receiver )
                self.str_vendor_name = (self.dictBookingDetails["vendorName"] as! String)
                self.str_vendor_id = "\(self.dictBookingDetails["vendorID"]!)"
                self.str_vendor_image = (self.dictBookingDetails["vendorImage"] as! String)
                self.str_vender_device_token = (self.dictBookingDetails["vendordeviceToken"] as! String)
                self.str_vendor_device_name = (self.dictBookingDetails["vendordevice"] as! String)
                 
                 // caller
                self.str_caller_name = (self.dictBookingDetails["userName"] as! String)
                self.str_caller_id = "\(self.dictBookingDetails["userID"]!)"
                self.str_caller_image = (self.dictBookingDetails["userImage"] as! String)
                self.str_caller_device_token = (self.dictBookingDetails["userdeviceToken"] as! String)
                self.str_caller_device_name = (self.dictBookingDetails["userdevice"] as! String)
                
            } else {
                // parse vendor detaiils here ( receiver )
                self.str_vendor_name = (self.dictBookingDetails["userName"] as! String)
                self.str_vendor_id = "\(self.dictBookingDetails["userID"]!)"
                self.str_vendor_image = (self.dictBookingDetails["userImage"] as! String)
                self.str_vender_device_token = (self.dictBookingDetails["userdeviceToken"] as! String)
                self.str_vendor_device_name = (self.dictBookingDetails["userdevice"] as! String)
                 
                 // caller
                self.str_caller_name = (self.dictBookingDetails["vendorName"] as! String)
                self.str_caller_id = "\(self.dictBookingDetails["vendorID"]!)"
                self.str_caller_image = (self.dictBookingDetails["vendorImage"] as! String)
                self.str_caller_device_token = (self.dictBookingDetails["vendordeviceToken"] as! String)
                self.str_caller_device_name = (self.dictBookingDetails["vendordevice"] as! String)
                
                
            }
            
            
        }
        
        
        
        
        if (get_type == "audio") {
            // send notification
            self.send_notification_for_audio_call( caller_name:String(str_caller_name),
                                                   caller_id:String(str_caller_id),
                                                   caller_image:String(str_caller_image),
                                                   caller_device_token:String(str_caller_device_token),
                                                   receiver_userId: String(str_vendor_id),
                                                   receiver_name: String(str_vendor_name),
                                                   receiver_device_name: String(str_vendor_device_name),
                                                   receiver_device_image:String(str_vendor_image),
                                                   receiver_device_token: String(str_vender_device_token),
                                                   audio_call_id: String(getCallId),
                                                   caller_device_name: String(str_caller_device_name))
        } else {
            // send notification
            self.send_notification_for_video_call( caller_name:String(str_caller_name),
                                                   caller_id:String(str_caller_id),
                                                   caller_image:String(str_caller_image),
                                                   caller_device_token:String(str_caller_device_token),
                                                   receiver_userId: String(str_vendor_id),
                                                   receiver_name: String(str_vendor_name),
                                                   receiver_device_name: String(str_vendor_device_name),
                                                   receiver_device_image:String(str_vendor_image),
                                                   receiver_device_token: String(str_vender_device_token),
                                                   video_call_id: String(getCallId),
                                                   caller_device_name: String(str_caller_device_name))
        }
        
        
        
    }
    
    func send_notification_for_audio_call(caller_name:String,
                                          caller_id:String,
                                          caller_image:String,
                                          caller_device_token:String,
                                          
                                          receiver_userId:String,
                                          receiver_name:String,
                                          receiver_device_name:String,
                                          receiver_device_image:String,
                                          receiver_device_token:String,
                                          audio_call_id:String,
                                          caller_device_name:String) {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            parameters = [
                "action"        : "sendnotification",
                "Token"        : String(receiver_device_token), // receiver's token
                
                "message"       : String(caller_name)+" is calling", // custom message
                "device"        : String(receiver_device_name), // receiver's device
                
                // receiver's custom data
                "receiver_name"     : String(receiver_name),
                "receiver_id"       : String(receiver_userId),
                "receiver_image"    : String(receiver_device_image),
                
                // sender's custom data
                "sender_id"             : String(myString),
                "sender_name"           : String(caller_name),
                "sender_device"         : String(caller_device_name),
                "sender_device_token"   : String(caller_device_token),
                "sender_image"          : String(caller_image),
                
                //
                "channel" : String(audio_call_id),
                
                //
                "type"          : "audiocall",
            ]
            
            print("parameters-------\(String(describing: parameters))")
            // "135+133"
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                [self]
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
                            
                            /*var dict: Dictionary<AnyHashable, Any>
                             dict = JSON["data"] as! Dictionary<AnyHashable, Any>*/
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "audio_outgoing_call_id") as? audio_outgoing_call
                            
                            push!.str_receiver_name = String(self.str_vendor_name)
                            push!.channel_id_for_audio_call = String(audio_call_id)
                            
                            self.navigationController?.pushViewController(push!, animated: true)
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
    
    
    func send_notification_for_video_call(caller_name:String,
                                          caller_id:String,
                                          caller_image:String,
                                          caller_device_token:String,
                                          
                                          receiver_userId:String,
                                          receiver_name:String,
                                          receiver_device_name:String,
                                          receiver_device_image:String,
                                          receiver_device_token:String,
                                          video_call_id:String,
                                          caller_device_name:String) {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                print(myString)
                
                Utils.RiteVetIndicatorShow()
                
                let urlString = BASE_URL_KREASE
                
                var parameters:Dictionary<AnyHashable, Any>!
                 
                parameters = [
                    "action"        : "sendnotification",
                    "Token"        : String(receiver_device_token), // receiver's token
                    
                    "message"       : String(caller_name)+" is calling", // custom message
                    "device"        : String(receiver_device_name), // receiver's device
                    
                    // receiver's custom data
                    "receiver_name"     : String(receiver_name),
                    "receiver_id"       : String(receiver_userId),
                    "receiver_image"    : String(receiver_device_image),
                    
                    // sender's custom data
                    "sender_id"             : String(myString),
                    "sender_name"           : String(caller_name),
                    "sender_device"         : String(caller_device_name),
                    "sender_device_token"   : String(caller_device_token),
                    "sender_image"          : String(caller_image),
                    //
                    "notification": [
                             "sound": "default",
                        ],
                    "priority": "high",
                    //
                    "channel" : String(video_call_id),
                    
                    //
                    "type"          : "videocall",
                ]
                
                print("parameters-------\(String(describing: parameters))")
                // "135+133"
                AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                    [self]
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
                                
                                /*var dict: Dictionary<AnyHashable, Any>
                                 dict = JSON["data"] as! Dictionary<AnyHashable, Any>*/
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "outgoing_video_call_id") as? outgoing_video_call
                                
                                print(video_call_id as Any)
                                
                                push!.str_store_channel_name = String(video_call_id)
                                push!.str_receiver_token_for_missed_call_notification = String(receiver_device_token)
                                
                                push!.str_sender_id = String(myString)
                                push!.str_sender_name = String(caller_name)
                                push!.str_sender_token = String(caller_device_token)
                                
                                push!.str_receiver_id = String(receiver_userId)
                                push!.str_receiver_name = String(self.str_vendor_name)
                                push!.str_receiver_token = String(receiver_device_token)
                                
                                push!.self.str_save_data_in_missed_call = "0"
                                
                                self.navigationController?.pushViewController(push!, animated: true)
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
    
    
    
    
    
    @objc func send_notification_to_doctor(str_get_type:String) {
        
        print(self.dictBookingDetails as Any)
        
        UserDefaults.standard.set("", forKey: "key_instant_calling")
        UserDefaults.standard.set(nil, forKey: "key_instant_calling")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            parameters = [
                "action"        : "sendnotification",
                "message"       : (person["fullName"] as! String)+" calling",
                "type"          : String(str_get_type),
                "userId"        : String(myString),
                "todevice"      : "\(self.dictBookingDetails["userdevice"] as! String)",
                "device"        : "iOS",
                "channel"       : "\(self.dictBookingDetails["userID"]!)+\(self.dictBookingDetails["vendorID"]!)",
                "name"          : (person["fullName"] as! String),
                "image"         : "\(self.dictBookingDetails["userImage"] as! String)",
                "Token"         : "\(self.dictBookingDetails["vendordeviceToken"] as! String)",
                "deviceToken"   : (person["deviceToken"] as! String),
                "receverName"   : "\(self.dictBookingDetails["vendorName"] as! String)",
                "mobileNumber"  : ""
            ]
            
            print("parameters-------\(String(describing: parameters))")
            // "135+133"
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                [self]
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
                            
                            if str_get_type == "audiocall" {
                                
                                /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"RoomViewControllerId") as? RoomViewController
                                
                                push!.roomName = "\(dict["userId"]!)+\(String(myString))"
                                push!.setSteps = "2"
                                push!.strIamCallingTo = "\(self.dict["VFirstName"] as! String)"
                                
                                push!.callerName = "\(self.dict["VFirstName"] as! String)"
                                push!.callerImage = "\(self.dict["ownPicture"] as! String)"
                                
                                let x22 : Int = (self.dict["userId"] as! Int)
                                let myString22 = String(x22)
                                
                                push!.receiver_id_for_missed_call = myString22
                                push!.receiver_name_for_missed_call = "\(self.dict["VFirstName"] as! String)"
                                push!.receiver_image_for_missed_call = "\(self.dict["ownPicture"] as! String)"
                                push!.receiver_token_for_missed_call = "\(self.dict["device"] as! String)"
                                
                                self.navigationController?.pushViewController(push!, animated:true)*/
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"RoomViewControllerId") as? RoomViewController
                                
                                push!.roomName = "\(self.dictBookingDetails["userID"]!)+\(self.dictBookingDetails["vendorID"]!)"
                                push!.setSteps = "2"
                                push!.strIamCallingTo = "\(self.dictBookingDetails["userName"] as! String)"
                                
                                push!.callerName = "\(self.dictBookingDetails["userName"] as! String)"
                                push!.callerImage = "\(self.dictBookingDetails["userImage"] as! String)"
                                
                                let x22 : Int = (self.dictBookingDetails["userID"] as! Int)
                                let myString22 = String(x22)
                                
                                push!.receiver_id_for_missed_call = myString22
                                push!.receiver_name_for_missed_call = "\(self.dictBookingDetails["userName"] as! String)"
                                push!.receiver_image_for_missed_call = "\(self.dictBookingDetails["userImage"] as! String)"
                                push!.receiver_token_for_missed_call = "\(self.dictBookingDetails["userdevice"] as! String)"
                                
                                print(self.dictBookingDetails as Any)
                                push!.dictGetFullDetails = self.dictBookingDetails
                                
                                push!.str_show_user_id = "\(self.dictBookingDetails["userName"] as! String)"
                                push!.str_show_vendor_id = "\(self.dictBookingDetails["userName"] as! String)"
                                
                                self.navigationController?.pushViewController(push!, animated:true)
                                
                            } else {
                                
                                /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoChatViewControllerId") as? VideoChatViewController
                                
                                push!.roomName = "\(dict["userId"]!)+\(String(myString))"
                                push!.setSteps = "2"
                                push!.strIamCallingTo = "\(self.dict["VFirstName"] as! String)"
                                
                                push!.callerName = "\(self.dict["VFirstName"] as! String)"
                                push!.callerImage = "\(self.dict["ownPicture"] as! String)"
                                
                                self.navigationController?.pushViewController(push!, animated:true)*/
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoChatViewControllerId") as? VideoChatViewController
                                
                                push!.roomName = "\(self.dictBookingDetails["userID"]!)+\(self.dictBookingDetails["vendorID"]!)"
                                push!.setSteps = "2"
                                push!.strIamCallingTo = "\(self.dictBookingDetails["userName"] as! String)"
                                
                                push!.callerName = "\(self.dictBookingDetails["userName"] as! String)"
                                push!.callerImage = "\(self.dictBookingDetails["userImage"] as! String)"
                                
                                self.navigationController?.pushViewController(push!, animated:true)
                                
                            }
                            
                            
                            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
//        let item = arrListOfAppointment[indexPath.row] as? [String:Any]
//
//        let livingArea2 = item!["typeofbusinessId"] as? Int ?? 0
//
//        if livingArea2 == 3 {
//            let livingArea2 = item!["vendorID"] as? Int ?? 0
//
//            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoCallId") as? VideoCall
//            push!.vendorId = String(livingArea2)
//            self.navigationController?.pushViewController(push!, animated: true)
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
}


class appointment_details_table_cell: UITableViewCell {

    @IBOutlet weak var btn_chat:UIButton! {
        didSet {
            btn_chat.setImage(UIImage(systemName: "message.fill"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_audio:UIButton! {
        didSet {
            btn_audio.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        }
    }
    
    
    @IBOutlet weak var lbl_type_of_services:UILabel! {
        didSet {
            lbl_type_of_services.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_appointment_date:UILabel! {
        didSet {
            lbl_appointment_date.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_appointment_time:UILabel! {
        didSet {
            lbl_appointment_time.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_services:UILabel! {
        didSet {
            lbl_services.textColor = .black
        }
    }
     
    @IBOutlet weak var btn_video:UIButton! {
        didSet {
            btn_video.isHidden = true
        }
    }
    
    @IBOutlet weak var btn_next:UIButton! {
        didSet {
            btn_next.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btn_next.layer.cornerRadius = 20
            btn_next.clipsToBounds = true
            btn_next.setTitle("Next", for: .normal)
            btn_next.setTitleColor(.white, for: .normal)
            
            btn_next.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_next.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_next.layer.shadowOpacity = 1.0
            btn_next.layer.shadowRadius = 15.0
            btn_next.layer.masksToBounds = false
            btn_next.layer.cornerRadius = 15
            btn_next.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_cancel:UIButton! {
        didSet {
            btn_cancel.isHidden = false
            btn_cancel.setTitle("Cancel", for: .normal)
            btn_cancel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_cancel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_cancel.layer.shadowOpacity = 1.0
            btn_cancel.layer.shadowRadius = 14.0
            btn_cancel.layer.masksToBounds = false
            btn_cancel.layer.cornerRadius = 14
            btn_cancel.backgroundColor = .systemRed
            btn_cancel.setTitleColor(.white, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
