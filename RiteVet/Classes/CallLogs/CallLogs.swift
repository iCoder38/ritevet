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
            lblNavigationTitle.text = "Missed Call"
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
       
            Firestore.firestore().collection(missed_call_collection_path)
                // .whereField("audio_call_id", isEqualTo: String(self.channel_id_for_audio_call))
                .whereField("users_ids", arrayContainsAny: ["665"])
                .addSnapshotListener() { documentSnapshot, error in
                    if error != nil {
                        print("Error to get user lists")
                        
                        return
                    }
                    
                    if let snapshot = documentSnapshot {
                        
                        for document in snapshot.documents {
                            
                            let data = document.data()
                            print(data as Any)
                            
                            self.arr_mut_missed_call_Data.add(data)
                            self.tbleView.isHidden = false
                            
                            if self.arr_mut_missed_call_Data.count != 0 {
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                            }
                            
                            
                        }
                        
                    } else {
                        print("no, data found")
                    }
                    
                }
        
        /*
        let ref = Database.database().reference()
        ref.child(missed_call_collection_path)
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
        */
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
        
        let item = self.arr_mut_missed_call_Data[indexPath.row] as? [String:Any]
         print(item as Any)
        /*
         ["sender_name": doc new, "sender_device": iOS, "sender_device_token": ew5E2o29gU3mmbCheOKnkt:APA91bEElcmturrTqkgagGqluW4fOSXcDe1VPkpR3XMfbE0bg8gm3k39NPkA6utPz-g1Ypoi3LFfBnVQB9fQWeQUn_ZJS6ZqidLvrQbPuyqZokWqsaKV1fY_wlDumYUy7Ek5kYtRqB0y, "type": video, "channel": AECED945-0981-491E-93D8-EEB16FB838FE, "call_status": missed, "time": 05:06, "receiver_device_token": dzoHIng1jUK1ir70IR_Dsz:APA91bFdFAC6MpVycc6llWPp68Ywal968BWe3geFfx4aXeUrKN0PACakHUwq0a393BHzUZ_ZTZSM9efVQ64byZn4pgdF6C5EEubL2W9cvI90OXSi5A-ZJXypRxPiiS2vFVo9KfbpfA8T, "receiver_name": DD new, "sender_id": 665, "date": 2024-02-26, "users_ids": <__NSArrayM 0x282ce8480>(
         665,
         713
         )
         */
        
        /*if item!["time_stamp"] is String {
            print("Yes, it's a String")
            
            let result = String((item!["time_stamp"] as! String).prefix(19))
            
            cell.lbl_time.isHidden = false
            cell.lbl_time.text = "\(result)"
            
        } else if item!["time_stamp"] is Int {
            print("It is Integer")
            cell.lbl_time.isHidden = true
        } else {
            //some other check
            print("It is Decimal")
            cell.lbl_time.isHidden = false
            
            let doublee = Double("\(item!["time_stamp"]!)")
            let date = NSDate(timeIntervalSince1970: doublee!)
            let result = "\(date)".prefix(19)
            cell.lbl_time.text = "\(result)"
            
        }*/
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            if (item!["sender_id"] as! String) == myString {
                
                cell.lbl_title.text = (item!["receiver_name"] as! String)
                
            } else {
                
                cell.lbl_title.text = (item!["sender_name"] as! String)
                
            }
            // type
            if (item!["type"] as! String) == "audio" {
                
                cell.btn_title.setImage(UIImage(systemName: "phone.fill.arrow.down.left"), for: .normal)
                
            } else {
                //
                if (item!["sender_id"] as! String) == myString {
                    
                    cell.btn_title.setImage(UIImage(systemName: "arrow.up.right.video"), for: .normal)
                    cell.btn_title.tintColor = .green
                    
                } else {
                    cell.btn_title.setImage(UIImage(systemName: "video.slash.fill"), for: .normal)
                    cell.btn_title.tintColor = .red
                }
                
                //cell.btn_title.setImage(UIImage(systemName: ""), for: .normal)
                
            }
        }
        
        cell.lbl_time.text = (item!["time"] as! String)
        cell.lbl_time.isHidden = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
            
        let item = self.arr_mut_missed_call_Data[indexPath.row] as? [String:Any]
        print(item as Any)
        var query: Query!
        
        query = Firestore.firestore().collection(missed_call_collection_path).whereField("video_call_id", isEqualTo: (item!["video_call_id"] as! String))
        
        query.getDocuments { (snapshot, error) in
            //
            if error != nil {
                print("=====================================================================")
                print("=====================================================================")
                print("ERROR : \(error!)")
                print("=====================================================================")
                print("=====================================================================")
            } else {
                print("=====================================================================")
                print("=====================================================================")
                print("FIREBASE : DATA GET SUCCESSFULLY FOR AUDIO CALL FROM FIREBASE")
                print("=====================================================================")
                print("=====================================================================")
                
                print(snapshot as Any)
                if let documents = snapshot?.documents {
                    self.send_notification(receiver_token: (documents[0]["receiver_device_token"] as! String),
                                           str_receiver_name: (documents[0]["receiver_name"] as! String),
                                           str_receiver_id: (documents[0]["receiver_id"] as! String),
                                           str_receiver_image: "",
                                           sender_id: (documents[0]["sender_id"] as! String),
                                           str_sender_name: (documents[0]["sender_name"] as! String),
                                           str_sender_device: (documents[0]["sender_device"] as! String),
                                           str_sender_device_token: (documents[0]["sender_device_token"] as! String),
                                           str_sender_image: "",
                                           channel: (documents[0]["video_call_id"] as! String))
                }
                /*if let documents = snapshot?.documents {
                    
                    Firestore.firestore().collection(audio_call_collection_path)
                    
                    // .whereField("audio_call_id", isEqualTo: documents[0]["audio_call_id"] as! String)
                        .document(documents[0].documentID)
                    
                        .updateData(["call_status": "receiver_declined"])
                    
                    print("=====================================================================")
                    print("=====================================================================")
                    print("FIREBASE : DATA UPDATED SUCCESSFULLY ( call_status )")
                    print("=====================================================================")
                    print("=====================================================================")
                    
                }*/
                
            }
        }
        
        /*let uuid = UUID().uuidString
        print(uuid)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            if (item!["sender_id"] as! String) == myString {
                self.send_notification(receiver_token: (item!["receiver_device_token"] as! String),
                                       str_receiver_name: (item!["receiver_name"] as! String),
                                       str_receiver_id: (item!["receiver_id"] as! String),
                                       str_receiver_image: "",
                                       sender_id: (item!["sender_id"] as! String),
                                       str_sender_name: (item!["sender_name"] as! String),
                                       str_sender_device: (item!["sender_device"] as! String),
                                       str_sender_device_token: (item!["sender_device_token"] as! String),
                                       str_sender_image: "",
                                       channel: String(uuid))
            } else {
                
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
                        self.send_notification(receiver_token: (item!["sender_device_token"] as! String),
                                               str_receiver_name: (item!["sender_name"] as! String),
                                               str_receiver_id: (item!["sender_id"] as! String),
                                               str_receiver_image: "",
                                               sender_id: (item!["receiver_id"] as! String),
                                               str_sender_name: (item!["receiver_name"] as! String),
                                               str_sender_device: "iOS",
                                               str_sender_device_token: (item!["receiver_device_token"] as! String),
                                               str_sender_image: "",
                                               channel: String(uuid))
                        
                    }
                }
                
                
                
            }
        }*/
        
    }
    
    @objc func send_notification(receiver_token:String,str_receiver_name:String,
                                 str_receiver_id:String,str_receiver_image:String,
                                 sender_id:String,str_sender_name:String,str_sender_device:String,
                                 str_sender_device_token:String,str_sender_image:String,
                                 channel:String) {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
             
            parameters = [
                "action"        : "sendnotification",
                "Token"        : String(receiver_token), // receiver's token
                
                "message"       : String(str_sender_name)+" is calling", // custom message
                "device"        : String("iOS"), // receiver's device
                
                // receiver's custom data
                "receiver_name"     : String(str_receiver_name),
                "receiver_id"       : String(str_receiver_id),
                "receiver_image"    : String(str_receiver_image),
                
                // sender's custom data
                "sender_id"             : String(myString),
                "sender_name"           : String(str_sender_name),
                "sender_device"         : String("iOS"),
                "sender_device_token"   : String(str_sender_device_token),
                // "sender_image"          : String(caller_image),
                "channel" : String(channel),
                
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
                             
                            push!.str_store_channel_name = String(channel)
                            push!.str_receiver_token_for_missed_call_notification = String(receiver_token)
                            
                            push!.str_sender_id = String(myString)
                            push!.str_sender_name = String(str_sender_name)
                            push!.str_sender_token = String(str_sender_device_token)
                            
                            push!.str_receiver_id = String(str_receiver_id)
                            push!.str_receiver_name = String(str_receiver_name)
                            push!.str_receiver_token = String(receiver_token)
                            
                            push!.self.str_save_data_in_missed_call = "1"
                            
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
            
            if (item!["sender_id"] as! String) == myString {
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

