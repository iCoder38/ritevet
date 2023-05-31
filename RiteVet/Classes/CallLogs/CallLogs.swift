//
//  CallLogs.swift
//  RiteVet
//
//  Created by apple on 14/01/22.
//  Copyright © 2022 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseDatabase

class CallLogs: UIViewController {

    var arr_mut_missed_call_Data : NSMutableArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Call Logs"
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

        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        self.sideBarMenu()
        
        self.tbleView.separatorColor = .clear
        
        self.get_missed_calls_data()
    }
    
    @objc func get_missed_calls_data() {
        // Utils.RiteVetIndicatorShow()
        
        
        let ref = Database.database().reference()
        ref.child("missed_calls")
            // .queryOrdered(byChild: "TimeStamp")
            
            .observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    print("true rooms exist")
                    
                    self.arr_mut_missed_call_Data.removeAllObjects()
                    
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let placeDict = snap.value as! [String: Any]
                        print(placeDict as Any)
                        
                        // self.chatMessages.add(placeDict)
                        
                        DispatchQueue.main.async {
                            
                            self.arr_mut_missed_call_Data.add(placeDict)
                            // print(self.arrListOfAllGroupList as Any)
                            
                            self.tbleView.isHidden = false
                            
                            if self.arr_mut_missed_call_Data.count == 0 {
                                self.tbleView.isHidden = true
                            }
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                            
                        }
                        
                        Utils.RiteVetIndicatorHide()
                        // print(self.chatMessages.reversed() as Any)
                    }
                    
                } else {
                    print("room not exist")
                    Utils.RiteVetIndicatorHide()
                    // self.categoryListingWB()
                }
            })
        // print(self.chatMessages.reversed() as Any)
        
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
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension CallLogs: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_missed_call_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CallLogsTableCell = tableView.dequeueReusableCell(withIdentifier: "callLogsTableCell") as! CallLogsTableCell
        
        cell.backgroundColor = .clear
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let item = self.arr_mut_missed_call_Data.reversed()[indexPath.row] as? [String:Any]
        print(item as Any)
    
        /*
         
         ["caller_name": Lee, "receiver_name": kiwi one, "receiver_id": 3, "caller_image": , "type": No Answer, "room_id": 3+4, "time_stamp": 2022-01-12 22:21:03.709, "callType": Audio, "caller_token": chBdJBa86kw:APA91bHcLMoQcdtRwJWtfmxM_l8XQKAbYHWkl08nfa4d6Tn5zIjHkyJNEQ1uy_9JqO6SCBAcF_htjpCNaCwPR7YTyJJ7IugCPWVKyrFCXs7bxeth76ERaFgpbHkctmJFc-Z-aSiEl0Ge, "receiver_image": http://demo2.evirtualservices.co/ritevet/site/img/uploads/users/16288397010dc57b8d66c12736c666f157a3afa3ff.jpg, "receiver_token_id": e7EbN6R0RUq_lniKPhHzOE:APA91bGpJte3wOr4sHzlqbbfQq7hHOqB0LenUUw_Zi8N4m8lcowH5tTs3WPYalzUAOmMOwkPV8mTwueUuh_y0YcONe7kVv_pyp68spN5iRaf3VMWdvIPDwwlghA7ZE4ASFUmsuN9MCys, "caller_id": 4])
         
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            if (item!["caller_id"] as! String) == myString {
                
                cell.lbl_title.text = (item!["receiver_name"] as! String)
                
            } else {
                
                cell.lbl_title.text = (item!["caller_name"] as! String)
                
            }
            
        }
        
        if (item!["callType"] as! String) == "Audio" {
            
            cell.btn_title.setImage(UIImage(systemName: "phone.fill.arrow.down.left"), for: .normal)
            
        } else {
            
            cell.btn_title.setImage(UIImage(systemName: "video.slash.fill"), for: .normal)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
            
        let item = self.arr_mut_missed_call_Data.reversed()[indexPath.row] as? [String:Any]
        
        if (item!["callType"] as! String) == "Audio" {
            
            self.send_notification_and_call(dict_call_Data:item! as NSDictionary,
                                            strChannelName: (item!["room_id"] as! String),
                                            strType: "audiocall",
                                            strBody: "Incoming Audio call")
            
        }
        
        
    }
    
    @objc func send_notification_and_call(dict_call_Data:NSDictionary,strChannelName:String,strType:String,strBody:String) {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            parameters = [
                "action"        : "sendnotification",
                "message"       : String(strBody),
                "type"          : String(strType),
                "userId"        : String(myString),
                "todevice"      : (dict_call_Data["receiver_token_id"] as! String),
                "device"        : "iOS",
                "channel"       : String(strChannelName),
                "name"          : (person["fullName"] as! String),
                "image"         : (dict_call_Data["receiver_image"] as! String),
                "Token"         : (dict_call_Data["receiver_token_id"] as! String),
                "deviceToken"   : (person["deviceToken"] as! String),
                "mobileNumber"  : ""
                
            ]
            
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
                            
                            if strType == "audiocall" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"RoomViewControllerId") as? RoomViewController
                                push!.roomName = String(strChannelName)
                                push!.setSteps = "2"
                                push!.strIamCallingTo = (dict_call_Data["receiver_name"] as! String)
                                
                                push!.callerName = (dict_call_Data["receiver_name"] as! String)
                                push!.callerImage = (dict_call_Data["receiver_image"] as! String)
                                
                                push!.receiver_id_for_missed_call = (dict_call_Data["receiver_id"] as! String)
                                push!.receiver_name_for_missed_call = (dict_call_Data["receiver_name"] as! String)
                                push!.receiver_image_for_missed_call = (dict_call_Data["receiver_image"] as! String)
                                push!.receiver_token_for_missed_call = (dict_call_Data["receiver_token_id"] as! String)
                                
                                self.navigationController?.pushViewController(push!, animated:true)
                                
                            } else {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoChatViewControllerId") as? VideoChatViewController
                                push!.roomName = String(strChannelName)
                                push!.setSteps = "2"
                                push!.strIamCallingTo = (dict_call_Data["receiver_name"] as! String)
                                
                                push!.callerName = (dict_call_Data["receiver_name"] as! String)
                                push!.callerImage = (dict_call_Data["receiver_image"] as! String)
                                
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // return 88
        
        let item = self.arr_mut_missed_call_Data.reversed()[indexPath.row] as? [String:Any]
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            if (item!["caller_id"] as! String) == myString {
                return 88
            } else if (item!["receiver_id"] as! String) == myString {
                return 88
            } else {
                return 0
                
            }
            
        } else {
            return 0
        }
        
        
    }
    
}

