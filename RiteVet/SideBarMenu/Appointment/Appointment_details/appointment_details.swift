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
        
        let alert = UIAlertController(title: "Alert : Delivered", message: "Delivered this product ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes, delivered", style: .default, handler: { action in
            
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
            
            cell.lbl_services.text = productIDString
        }
        
        cell.lbl_appointment_date.text = (self.dictBookingDetails["bookingDate"] as! String)
        cell.lbl_appointment_time.text = (self.dictBookingDetails["slotTime"] as! String)
        cell.lbl_type_of_services.text = (self.dictBookingDetails["typeofbusinessName"] as! String)
        
        if "\(self.dictBookingDetails["status"]!)" == "1" {
            
            cell.btn_next.setTitle("Pending", for: .normal)
            cell.btn_next.backgroundColor = .systemOrange
            
            if (self.str_from_booking != "yes") {
                cell.btn_next.addTarget(self, action: #selector(pending_click_method), for: .touchUpInside)
            }
            
            
        } else if "\(self.dictBookingDetails["status"]!)" == "2" {
            
            cell.btn_next.setTitle("Completed", for: .normal)
            cell.btn_next.backgroundColor = .systemGreen
            
        }
        
        if "\(self.dictBookingDetails["typeofbusinessId"]!)" == "2" {
         
            cell.btn_video.isHidden = true
            
        } else if "\(self.dictBookingDetails["typeofbusinessId"]!)" == "3" {
            
            cell.btn_video.isHidden = false
            
        }
        
        return cell
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
