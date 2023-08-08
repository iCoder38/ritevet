//
//  booking_details.swift
//  RiteVet
//
//  Created by Dishant Rajput on 26/05/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbleView.separatorColor = .clear
        
        self.btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.tintColor = .white
        
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
                "bookingId"     :  String(self.str_get_booking_id),
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
                        
                        //                            var ar : NSArray!
                        //                            ar = (JSON["historyList"] as! Array<Any>) as NSArray
                        //                            self.arrListOfAppointment = (ar as! Array<Any>)
                        
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
        
        
        // current date
        let dateformatter2 = DateFormatter()
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
            print("current time-->",current_date)
            
            let prefix_time = String((self.dictBookingDetails["slotTime"] as! String).prefix(05))
            print("server time-->",prefix_time)
            
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
        
        cell.btn_chat.addTarget(self, action: #selector(one_to_one_chat_click_method), for: .touchUpInside)
        cell.btn_audio.addTarget(self, action: #selector(audio_call_click_method), for: .touchUpInside)
        cell.btn_video.addTarget(self, action: #selector(video_chat_click_method), for: .touchUpInside)
        
        return cell
    }
    
    @objc func one_to_one_chat_click_method() {
             
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
        push!.receiverData = self.dictBookingDetails as NSDictionary?
        push!.fromDialog = "no"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func audio_call_click_method() {
        
        // print(self.dictBookingDetails as Any)
        /*
         UTYPE = 2;
         bookingDate = "2023-08-31T00:00:00+0530";
         bookingID = 236;
         created = "Aug 3rd, 2023, 1:24 pm";
         reviewByYou = 0;
         serviceArray =     (
         "General / Internal Medicine",
         Dental,
         Imaging,
         Boarding
         );
         slotTime = "10:40-11:10";
         status = 1;
         totalAmount = 70;
         transactionId = "tok_1NawMTKjKY5Kxs7I8QbbZGrx";
         typeofbusinessId = 3;
         typeofbusinessName = "Virtual Veterinarian (Video Chat)";
         userAddress = "park street 205 D";
         userEmail = "kaya@mailinator.com";
         userID = 123;
         userImage = "https://ritevet.com/img/uploads/users/1691043532add_id_prrof.png";
         userName = "Kaya pan";
         userNumber = 9632356235;
         userdevice = iOS;
         userdeviceToken = "fKSF_tCJTUWws2Y0IIWMmu:APA91bG8A-6loQ9m4caVNutfUwxtsGds1vShEFIXrN928C7R6A6YPytjqenpZSmffCvJRAQjfYEfmsOb9nEGZ1fmtTJgE1VCwdbilrlZjk55aDlXOn3PlyeIcDzSjWr-iRSUgj5PhQih";
         userfirebaseId = "";
         vendorAddress = "C Block, Ramprastha";
         vendorEmail = "purnima.pandey@evirtualservices.com";
         vendorID = 48;
         vendorImage = "";
         vendorName = "Purnima Pandey";
         vendorNumber = 9898765432;
         vendordevice = iOS;
         vendordeviceToken = "f5dizwL4_EZigrARymKJIz:APA91bHF8JPWscULfC7jMlyBNaKmSyKZiY9HnHHNsiqob2zDleJ63d1R3DB9h4UCh_yN2_o-MxUd0zTBleBtvkHpCokac5hAcTg_w582Kfq6wnfKTHD4gNxmBrYHpbHb0-6E_Qu-PhWg";
         vendorfirebaseId = "";
         */
        
        self.send_notification_to_doctor(str_get_type: "audiocall")
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"RoomViewControllerId") as? RoomViewController
            
            push!.roomName = "\(self.dictBookingDetails["userID"]!)+\(String(myString))"
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
            
            self.navigationController?.pushViewController(push!, animated:true)
        }*/
    }
    
    @objc func video_chat_click_method() {
        
        self.send_notification_to_doctor(str_get_type: "videocall")
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoChatViewControllerId") as? VideoChatViewController
            
            push!.roomName = "\(self.dictBookingDetails["userID"]!)+\(String(myString))"
            push!.setSteps = "2"
            push!.strIamCallingTo = "\(self.dictBookingDetails["userName"] as! String)"
            
            push!.callerName = "\(self.dictBookingDetails["userName"] as! String)"
            push!.callerImage = "\(self.dictBookingDetails["userImage"] as! String)"
            
            self.navigationController?.pushViewController(push!, animated:true)
        }*/
    }
    
    
    @objc func send_notification_to_doctor(str_get_type:String) {
        
        UserDefaults.standard.set("", forKey: "key_instant_calling")
        UserDefaults.standard.set(nil, forKey: "key_instant_calling")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print()
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
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
                "channel"       : "\(self.dictBookingDetails["userID"]!)+\(String(myString))",
                "name"          : (person["fullName"] as! String),
                "image"         : "\(self.dictBookingDetails["userImage"] as! String)",
                "Token"         : "\(self.dictBookingDetails["userdeviceToken"] as! String)",
                "deviceToken"   : (person["deviceToken"] as! String),
                "mobileNumber"  : ""
            ]
            
            print("parameters-------\(String(describing: parameters))")
            
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
                                
                                push!.roomName = "\(self.dictBookingDetails["userID"]!)+\(String(myString))"
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
                                
                                push!.roomName = "\(self.dictBookingDetails["userID"]!)+\(String(myString))"
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
