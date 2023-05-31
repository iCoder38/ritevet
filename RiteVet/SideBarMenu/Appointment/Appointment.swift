//
//  Appointment.swift
//  RiteVet
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Appointment: UIViewController {

    let cellReuseIdentifier = "appointmentTableCell"
    
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
            lblNavigationTitle.text = "MY APPOINTMENTS"
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
            lblNavigationTitle.text = "APPOINTMENT"*/
        self.appointment()
        // }
        
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
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
               
            parameters = [
                "action"       :   "bookinglist",
                "userId"       :   myString
//                    "pageNo"       :   "",
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
    
    @objc func booking() {
        
        Utils.RiteVetIndicatorShow()
            
        let urlString = BASE_URL_KREASE
         
        var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                   
            parameters = [
                "action"       :   "bookinglist",
                "userId"       :   myString // login id
    //                    "pageNo"       :   "",
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
                                print(JSON)
                                 
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
    
}


extension Appointment: UITableViewDataSource
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
        let cell:AppointmentTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AppointmentTableCell
        
        cell.backgroundColor = .clear
        
        /*
         UTYPE = 2;
         bookingDate = "2020-01-28T00:00:00+0530";
         bookingID = 217;
         contactNumber = 0931323334;
         created = "Jan 8th, 2020, 1:03 pm";
         device = "";
         deviceToken = "";
         firebaseId = "";
         serviceArray = "";
         slotTime = "07:30-08:30";
         status = 1;
         totalAmount = 0;
         transactionId = "";
         typeofbusinessId = 1;
         userAddress = "Sector- 18, B- block";
         userEmail = "purnima.pandey@evirtualservices.com";
         userID = 105;
         userImage = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/users/15771699764t.jpg";
         userName = "Vet New";
         vendorID = 95;
         */
        
        let item = arrListOfAppointment[indexPath.row] as? [String:Any]
        // print(item as Any)
        
         // image
         cell.imgProfile.sd_setImage(with: URL(string: (item!["userImage"] as! String)), placeholderImage: UIImage(named: "logo-500"))
        
         // title
         cell.lblTitle.text = (item!["userName"] as! String)
        
        // date
         cell.lblDateAndTime.text = (item!["created"] as! String)
        // cell.lblDate.textColor = NAVIGATION_BACKGROUND_COLOR
        
        // phone
        cell.lblPhoneNumber.text = (item!["contactNumber"] as! String)
        cell.lblPhoneNumber.textColor = NAVIGATION_BACKGROUND_COLOR
        
        let livingArea2 = item!["typeofbusinessId"] as? Int ?? 0
        
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = arrListOfAppointment[indexPath.row] as? [String:Any]
        
        let livingArea2 = item!["typeofbusinessId"] as? Int ?? 0
        
        if livingArea2 == 3 {
            let livingArea2 = item!["vendorID"] as? Int ?? 0
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoCallId") as? VideoCall
            push!.vendorId = String(livingArea2)
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension Appointment: UITableViewDelegate
{
    
}
