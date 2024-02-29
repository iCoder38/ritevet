//
//  MyBooking.swift
//  RiteVet
//
//  Created by Apple on 12/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyBooking: UIViewController {
    
    var str_get:String! = ""
    
    let cellReuseIdentifier = "myBookingTableCell"
    
    var arrListOfAppointment:Array<Any>!
    
    var strBookingOrAppointment:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MY BOOKING"
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
        // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        self.sideBarMenu()
        
        
    }
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     navigationController?.setNavigationBarHidden(true, animated: animated)
        
        /*if strBookingOrAppointment == "bookingIs" {
            lblNavigationTitle.text = "MY BOOKING"
            booking()
        }
        else  if strBookingOrAppointment == "appointmentIs" {
            lblNavigationTitle.text = "APPOINTMENT"
            appointment()
        }*/
        
        self.booking()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func appointment(){
    
         Utils.RiteVetIndicatorShow()
        
         let urlString = BASE_URL_KREASE
     
     var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
               {
                   let x : Int = (person["userId"] as! Int)
                   let myString = String(x)
               
                parameters = [
                    "action"       :   "bookinglist2",
                    "userId"       :   myString, // login id
                    "pageNo"       :   "0",
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
                               // print(JSON)
                             
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            if strSuccess == "Success" //true
                            {
                             Utils.RiteVetIndicatorHide()
                                
                            var ar : NSArray!
                            ar = (JSON["historyList"] as! Array<Any>) as NSArray
                            self.arrListOfAppointment = (ar as! Array<Any>)
                                
                             self.tbleView.delegate = self
                             self.tbleView.dataSource = self
                             self.tbleView.reloadData()
                             
                            }
                            else
                            {
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
    
    @objc func booking() {
        
        Utils.RiteVetIndicatorShow()
            
        let urlString = BASE_URL_KREASE
         
        var parameters:Dictionary<AnyHashable, Any>!
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                   
                parameters = [
                    "action"       :   "bookinglist2",
                    "userId"       :   myString,
                    "pageNo"   :   "0",
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
                                    
                        var ar : NSArray!
                        ar = (JSON["historyList"] as! Array<Any>) as NSArray
                        self.arrListOfAppointment = (ar as! Array<Any>)
                                    
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
    
}


extension MyBooking: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrListOfAppointment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MyBookingTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyBookingTableCell
        
        cell.backgroundColor = .clear
        
        /*
         Optional(["status": 1,
         "vendorID": 98,
         "userImage": "",
         "contactNumber": 4354123456,
         "bookingID": 45,
         "UTYPE": 2,
         "totalAmount": 0,
         "created": Feb 19th, 2021, 12:29 pm,
         "userAddress": C - 56, B block,
         "serviceArray": ,
         "firebaseId": ,
         "userID": 181,
         "typeofbusinessId": 3,
         "deviceToken": ,
         "slotTime": 10:00-11:00,
         "userEmail": evs@gmail.com,
         "device": ,
         "transactionId": ,
         "userName": purnima pandey,
         "bookingDate": 2021-02-28T00:00:00+0530])
         */
        
        // vendor id : 87,185
        let item = arrListOfAppointment[indexPath.row] as? [String:Any]
         print(item as Any)
        
         // image
        cell.imgProfile.sd_setImage(with: URL(string: (item!["userImage"] as! String)), placeholderImage: UIImage(named: "logo-500"))
        
         // title
        cell.lblTitle.text = (item!["userName"] as! String)
        
        
        // cell.lblDate.textColor = NAVIGATION_BACKGROUND_COLOR
        
        // phone
        cell.lblPhoneNumber.text = (item!["contactNumber"] as! String)
        cell.lblPhoneNumber.textColor = NAVIGATION_BACKGROUND_COLOR
        
        
        cell.lblFunction.text = (item!["typeofbusinessName"] as! String)
        
        /*let livingArea2 = item!["typeofbusinessId"] as? Int ?? 0
        
        if livingArea2 == 1 {
            cell.lblFunction.text = "Near By Clinic "
            cell.btnVideo.isHidden = true
        } else if livingArea2 == 2 {
            cell.lblFunction.text = "Come To Home "
            cell.btnVideo.isHidden = true
        } else if livingArea2 == 3 {
            cell.lblFunction.text = "Video Chat "
            cell.btnVideo.isHidden = false
        } else if livingArea2 == 4 {
            cell.lblFunction.text = "Come To Home "
            cell.btnVideo.isHidden = true
        } else if livingArea2 == 5 {
            cell.lblFunction.text = "Come To Home "
            cell.btnVideo.isHidden = true
        } else {
            cell.lblFunction.text = "Come To Home "
            cell.btnVideo.isHidden = true
        }*/
        
        // cell.btnVideo.isHidden = true
        if (item!["added_time"] as! String) != "" {
            // divide time
            let fullName    = (item!["added_time"] as! String)
            let fullNameArr = fullName.components(separatedBy: " ")

            let normal_date    = fullNameArr[0]
            let surname = fullNameArr[1]
            
            // print(normal_date as Any)
            // print(surname as Any)
            
            // divide sub time
            let divide_time = surname.components(separatedBy: ":")
            let time_hour    = divide_time[0]
            let time_minute = divide_time[1]
            
            // print(time_hour as Any)
            // print(time_minute as Any)
            
            let joiin_and_create_new_time = time_hour+":"+time_minute
            // print(joiin_and_create_new_time as Any)
            
            let dateAsString = String(joiin_and_create_new_time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            // print(Date12)
            
            // print(date24 as Any)
            let commenter_time_zone = (item!["current_time_zone"] as! String)
            let commenter_watcher_time_zone = "\(TimeZone.current.abbreviation()!)"
            // print(commenter_time_zone)
            // print(commenter_watcher_time_zone)
            
            let timeFormatterGet = DateFormatter()
            timeFormatterGet.dateFormat = "yyyy-MM-dd h:mm a"
            // timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
            timeFormatterGet.timeZone = TimeZone(abbreviation: "\(commenter_time_zone)")
            
            let timeFormatterPrint = DateFormatter()
            timeFormatterPrint.dateFormat = "yyyy-MM-dd h:mm a"
            timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(commenter_watcher_time_zone)")
            
            // timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(TimeZone.current.abbreviation()!)\(TimeZone.current.currentTimezoneOffset())") // if you want to specify timezone for output, otherwise leave this line blank and it will default to devices timezone

            let join_date_and_time_together = String(normal_date)+" "+String(Date12)
            // print(join_date_and_time_together)
            
            
            if let date = timeFormatterGet.date(from: "\(join_date_and_time_together)") {
                print(timeFormatterPrint.string(from: date))
                self.str_get = timeFormatterPrint.string(from: date)
            } else {
               print("There was an error decoding the string")
            }
            
             
            // date
            cell.lblDateAndTime.text = String(self.str_get)
        } else {
            // date
            cell.lblDateAndTime.text = ""
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = arrListOfAppointment[indexPath.row] as? [String:Any]
        print(item as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "appointment_details_id") as? appointment_details
        
        push!.str_from_booking = "yes"
        push!.str_get_booking_id = "\(item!["bookingID"]!)"
        push!.dictBookingDetails = (item! as NSDictionary)
        // push!.vendorId = String(livingArea2)
        self.navigationController?.pushViewController(push!, animated: true)
        
        
        
        /*let item = arrListOfAppointment[indexPath.row] as? [String:Any]
        print(item as Any)
        
        let livingArea2 = item!["typeofbusinessId"] as? Int ?? 0
        
        if livingArea2 == 2 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "booking_details_id") as? booking_details
            push!.str_get_booking_id = "\(item!["bookingID"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        else if livingArea2 == 3 {
            let livingArea2 = item!["vendorID"] as? Int ?? 0
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoCallId") as? VideoCall
            push!.vendorId = String(livingArea2)
            self.navigationController?.pushViewController(push!, animated: true)
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
}

extension MyBooking: UITableViewDelegate
{
    
}
