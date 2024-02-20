//
//  RoomViewController.swift
//  OpenVoiceCall
//
//  Created by GongYuhua on 16/8/22.
//  Copyright © 2016年 Agora. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Alamofire
import AVFoundation
// import RxSwift
import Firebase

protocol RoomVCDelegate: class {
    func roomVCNeedClose(_ roomVC: RoomViewController)
}

class RoomViewController: UIViewController {
    
    var secondsRemaining = 20
    var call_cut_timer:Timer!
    
    // let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
    
    var saveUID:String!
    
    var receiver_id_for_missed_call:String!
    var receiver_name_for_missed_call:String!
    var receiver_image_for_missed_call:String!
    var receiver_token_for_missed_call:String!
    
    var getAllFriendsList:NSMutableArray! = []
    var strStatus = String()
    
    var getAllFriendsName:NSMutableArray! = []
    var getAllFriendsId:NSMutableArray! = []
    var getAllFriendsDeviceToken:NSMutableArray! = []
    
    // MARK:- SELECT GENDER -
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    
    var str_show_user_id:String!
    var str_show_vendor_id:String!
    
    
    // NEW DATA SETUP
    @IBOutlet weak var roomNameLabel: UILabel!
    /*@IBOutlet weak var logTableView: UITableView! {
        didSet {
            // logTableView.dataSource = self
            logTableView.tableFooterView = UIView.init(frame: .zero)
        }
    }*/
    
    
    @IBOutlet weak var fullIncomingCallView:UIView! {
        didSet {
            fullIncomingCallView.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnIncomingCallDecline:UIButton! {
        didSet {
            btnIncomingCallDecline.backgroundColor = .systemRed
            btnIncomingCallDecline.setTitle("Decline", for: .normal)
            btnIncomingCallDecline.setTitleColor(.white, for: .normal)
            btnIncomingCallDecline.clipsToBounds = true
            btnIncomingCallDecline.layer.shadowColor = UIColor.black.cgColor
            btnIncomingCallDecline.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnIncomingCallDecline.layer.shadowOpacity = 1.0
            btnIncomingCallDecline.layer.shadowRadius = 2.0
            btnIncomingCallDecline.layer.masksToBounds = false
            btnIncomingCallDecline.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var btnIncomingCallAccept:UIButton! {
        didSet {
            btnIncomingCallAccept.backgroundColor = .systemGreen
            btnIncomingCallAccept.setTitle("Accept", for: .normal)
            btnIncomingCallAccept.setTitleColor(.white, for: .normal)
            btnIncomingCallAccept.clipsToBounds = true
            btnIncomingCallAccept.layer.shadowColor = UIColor.black.cgColor
            btnIncomingCallAccept.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnIncomingCallAccept.layer.shadowOpacity = 1.0
            btnIncomingCallAccept.layer.shadowRadius = 2.0
            btnIncomingCallAccept.layer.masksToBounds = false
            btnIncomingCallAccept.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var imgProfilePicture:UIImageView! {
        didSet {
            imgProfilePicture.layer.borderColor = UIColor.lightGray.cgColor
            imgProfilePicture.layer.borderWidth = 1
            imgProfilePicture.layer.cornerRadius = 70
            imgProfilePicture.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblCallerName:UILabel! {
        didSet {
            lblCallerName.textColor = .black
        }
    }
    
    @IBOutlet weak var muteAudioButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    
    var roomName: String!
    weak var delegate: RoomVCDelegate?
    
    
    @IBOutlet weak var btnAddFriend:UIButton! {
        didSet {
            btnAddFriend.tintColor = .black
        }
    }
    
    // create a reference for the Agora RTC engine
    fileprivate var agoraKit: AgoraRtcEngineKit!
    fileprivate var logs = [String]()
    
    var userRole: AgoraClientRole = .broadcaster
    
    // create a property for the Audio Muted state
    fileprivate var audioMuted = false {
        didSet {
            // update the audio button graphic whenever the audioMuted (bool) changes
            muteAudioButton?.setImage(UIImage(named: audioMuted ? "btn_mute_blue" : "btn_mute"), for: .normal)
            // use the audioMuted (bool) to mute/unmute the local audio stream
            agoraKit.muteLocalAudioStream(audioMuted)
        }
    }
    // create a property for the Speaker Mode state
    fileprivate var speakerEnabled = true {
        didSet {
            // update the speaker button graphics whenever the speakerEnabled (bool) changes
            speakerButton?.setImage(UIImage(named: speakerEnabled ? "btn_speaker_blue" : "btn_speaker"), for: .normal)
            speakerButton?.setImage(UIImage(named: speakerEnabled ? "btn_speaker" : "btn_speaker_blue"), for: .highlighted)
            // use the speakerEnabled (bool) to enable/disable speakerPhone
            agoraKit.setEnableSpeakerphone(speakerEnabled)
        }
    }
    
    @IBOutlet weak var lblWhoJoined:UILabel!
    
    // modified
    var loginUserNameIs:String! = ""
    var arrSaveMultipleJoinedUsers:NSMutableArray = []
    
    var currentPageNumber:Int = 1
    var totalPage: Int = 0
    var arrJSON  = [AnyObject]()
    
    var fetchNewArray: [[String:Any]] = [[:]]
    
    @IBOutlet weak var btnENDCALL:UIButton! {
        didSet {
            btnENDCALL.backgroundColor = .systemRed
            btnENDCALL.layer.cornerRadius = 8
            btnENDCALL.clipsToBounds = true
            btnENDCALL.setTitle(" End Call", for: .normal)
            btnENDCALL.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var lblMuteOrUmmute:UILabel!
    
    
    var setSteps:String!
    var callerName:String!
    var callerImage:String!
    var dictOfNotificationPopup:NSDictionary!
    
    
    var strIamCallingTo:String!
    
    var totalHour = Int()
    var totalMinut = Int()
    var totalSecond = Int()
    var timer:Timer?
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var lblCounter:UILabel! {
        didSet {
            lblCounter.textColor = .black
            lblCounter.isHidden = true
        }
    }
    
    
    @IBOutlet weak var receiverImageIs:UIImageView! {
        didSet {
            receiverImageIs.layer.borderColor = UIColor.lightGray.cgColor
            receiverImageIs.layer.borderWidth = 1
            receiverImageIs.layer.cornerRadius = 70
            receiverImageIs.clipsToBounds = true
        }
    }
    
    var dictGetFullDetails:NSDictionary!
    
    override func viewDidLoad()     {
        super.viewDidLoad()
       
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        print(self.dictGetFullDetails as Any)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            self.loginUserNameIs = (person["fullName"] as! String)
            
            // self.logTableView.separatorColor = .clear
            
            roomNameLabel.text = "\(roomName!)"
            

            let clickSound = URL(fileURLWithPath: Bundle.main.path(forResource: "inOrOut", ofType: "mp3")!)            
            
            self.start_timer_for_call_cut()
            
            // self.fullIncomingCallView.isHidden = true
            if "\(setSteps!)" == "1" { // call is incoming
                
                print("\(roomName!)")
                
                agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
                agoraKit.delegate = self
                
                print("\(setSteps!)")
                print("\(callerName!)")
                print("Image========>\(callerImage!)")
                
                self.lblCallerName.text = "\(callerName!)"
                self.fullIncomingCallView.isHidden = false
                imgProfilePicture.sd_setImage(with: URL(string: "\(callerImage!)"), placeholderImage: UIImage(named: "logo-500")) // my profile image
                
                self.receiverImageIs.isHidden = true
                self.receiverImageIs.sd_setImage(with: URL(string: "\(callerImage!)"), placeholderImage: UIImage(named: "logo-500"))
                
                do {
                    
                    audioPlayer = try AVAudioPlayer(contentsOf: clickSound)
                    audioPlayer.play()
                    
                } catch {
                    
                }
                
            } else if "\(setSteps!)" == "2" { // who start the call
                
                print("\(roomName!)")
                
//                agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
//                agoraKit.delegate = self
                
                self.roomNameLabel.text = "\(callerName!)"
                
                self.fullIncomingCallView.isHidden = true
                self.receiverImageIs.isHidden = false
                self.receiverImageIs.sd_setImage(with: URL(string: "\(callerImage!)"), placeholderImage: UIImage(named: "logo-500"))
                self.loadAgoraKit()
                
                /*do {
                    
                    audioPlayer = try AVAudioPlayer(contentsOf: clickSound)
                    audioPlayer.play()
                    
                } catch {
                    
                }*/
                
                // self.lblCallerName.text = "\(callerName!)"
                // self.imgProfilePicture.dowloadFromServer(link:"\(callerImage!)", contentMode: .scaleToFill)
                
            }
            
            self.btnIncomingCallAccept.addTarget(self, action: #selector(incomingAcceptClickMethod), for: .touchUpInside)
            self.btnIncomingCallDecline.addTarget(self, action: #selector(incomingDeclineClickMethod), for: .touchUpInside)
            
            // logTableView.rowHeight = UITableView.automaticDimension
            // logTableView.estimatedRowHeight = 50
            // loadAgoraKit()
        }
    }
    
    @objc func view_did_load() async {
        await self.loadAgoraKit()
    }
    
    @objc func incomingAcceptClickMethod()     {
        audioPlayer.stop()
        if "\(setSteps!)" == "1" { // call is incoming and you decline
            
            self.fullIncomingCallView.isHidden = true
            self.receiverImageIs.isHidden = false
              self.loadAgoraKit()
            
            self.roomNameLabel.text = "\(callerName!)"
             
            self.call_cut_timer.invalidate()
            
        } else {
            
        }
        
    }
    
    @objc func incomingDeclineClickMethod() {
        audioPlayer.stop()
        
        if "\(setSteps!)" == "1" { // call is incoming and you decline
            agoraKit.leaveChannel(nil)
            delegate?.roomVCNeedClose(self)
            
            self.call_cut_timer.invalidate()
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DashboardId")
            self.navigationController?.pushViewController(push, animated: true)
            
        } else {
            
            self.call_cut_timer.invalidate()
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }

    @objc func countdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int

        /*if totalSecond == 0 {
            timer?.invalidate()
        }*/
        totalSecond = totalSecond + 1
        hours = totalSecond / 3600
        minutes = (totalSecond % 3600) / 60
        seconds = (totalSecond % 3600) % 60
        // timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        print(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
        
        self.lblCounter.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @IBAction func doMuteAudioPressed(_ sender: UIButton) {
        audioMuted = !audioMuted
    }
    
    @IBAction func doSpeakerPressed(_ sender: UIButton) {
        speakerEnabled = !speakerEnabled
    }
    
    @IBAction func doClosePressed(_ sender: UIButton) {
        leaveChannel()
    }
    
    
    
}

private extension RoomViewController {
    func append(log string: String) {
        guard !string.isEmpty else {
            return
        }
        
        logs.append(string)
       
    }
    
    func updateLogTable(withDeleted deleted: String?) {
        
        /*guard let tableView = logTableView else {
            return
        }
        
        let insertIndexPath = IndexPath(row: logs.count - 1, section: 0)
        
        tableView.beginUpdates()
        if deleted != nil {
            tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        tableView.insertRows(at: [insertIndexPath], with: .none)
        tableView.endUpdates()
        
        tableView.scrollToRow(at: insertIndexPath, at: .bottom, animated: false)*/
    }
    
}

//MARK: - table view -
 extension RoomViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSaveMultipleJoinedUsers.count  // logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath) as! LogCell
        
        let item = self.arrSaveMultipleJoinedUsers[indexPath.row] as! [String:Any]
        cell.logLabel.text = (item["name"] as! String)
         
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        print("clicked")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let item = self.arrSaveMultipleJoinedUsers[indexPath.row] as! [String:Any]
        
         if (item["status"] as! String) == "yes" {
            return 60
        } else {
            return 0
        }
        
    }
    
    
 }

extension RoomViewController: UITableViewDelegate {
   
}

//MARK: - agora engine -
private extension RoomViewController {
    
    func loadAgoraKit()   {
        
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        self.agoraKit.delegate = self
        
        let option = AgoraRtcChannelMediaOptions()
        
        option.clientRoleType = .broadcaster
        option.channelProfile = .communication
        
        let result = agoraKit.joinChannel(
            byToken: "", channelId: String(roomName), uid: 0, mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in }
        )
        
        if (result == 0) {
            print("Successfully joined the channel as \(self.userRole)")
        }
        
    }
    
    @objc func start_timer_for_call_cut() {
        self.call_cut_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    @objc func countDown() {
        
        if secondsRemaining > 0 {
            print("\(secondsRemaining)")
            secondsRemaining -= 1
            
        } else {
            
            self.call_cut_timer.invalidate()
            
            self.save_missed_call_data_to_firebase_Server()
            
            self.leaveChannel()
            
        }
        
    }
    
    @objc func save_missed_call_data_to_firebase_Server() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let someDate = Date()
            let myTimeStamp = someDate.timeIntervalSince1970
            
            let ref = Database.database().reference()
            ref.child("missed_calls")
                .childByAutoId()
            
                .updateChildValues(
                    
                    [
                        "callType"         : String("Audio"),
                        "caller_id"        : String(myString),
                        "caller_image"     : String(self.callerImage),
                        "caller_name"      : String(self.loginUserNameIs),
                        "caller_token"     : (person["deviceToken"] as! String),
                        "receiver_id"      : String(self.receiver_id_for_missed_call),
                        "receiver_image"   : String(self.receiver_image_for_missed_call),
                        "receiver_name"    : String(self.receiver_name_for_missed_call),
                        "receiver_token_id": String(self.receiver_token_for_missed_call),
                        "room_id"          : "\(roomName!)",
                        "time_stamp"       : myTimeStamp,
                        "type"             : "type",
                    ]
                    
                )
            
        }
        
    }
    
    
    func leaveChannel() {
        // leaving the Agora channel
        agoraKit.leaveChannel(nil)
        delegate?.roomVCNeedClose(self)
        
        self.timer?.invalidate()
        
        if "\(setSteps!)" == "1" {
            //
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DashboardId")
            self.navigationController?.pushViewController(push, animated: true)
            
        } else {
            
            let alertController = UIAlertController(title: "Call end", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
                self.navigationController?.popViewController(animated: true)
                
            }
             
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion:nil)
            
            
        }
        
        /*if "\(setSteps!)" == "1" {
            
             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatFriendsListingVC")
             self.navigationController?.pushViewController(push, animated: true)
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }*/
        
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatListingVC")
        // self.navigationController?.pushViewController(push, animated: true)
        
    }
    
}

//MARK: Agora Delegate
extension RoomViewController: AgoraRtcEngineDelegate {
    
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Interrupted")
    }
   
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Lost")
    }
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        append(log: "Occur error: \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        
        if userInfo.userAccount == nil {
            
        } else {
            
            print(userInfo.uid as Any)
            print(userInfo.userAccount as Any)
            
            let myDictionary: [String:String] = [
            
                "id"        : String(userInfo.uid),
                "name"      : String(userInfo.userAccount!),
                "status"    : "yes"
            ]
            
            /*var res = [[String: String]]()
            res.append(myDictionary)*/
            
            self.arrSaveMultipleJoinedUsers.add(myDictionary)
            
            // print(self.arrSaveMultipleJoinedUsers as Any)
            
            if self.arrSaveMultipleJoinedUsers.count >= 1 {
                
                self.roomNameLabel.text = "On Call with"
                self.lblCounter.isHidden = true
                // self.startTimer()
                
            } else {
                
                self.timer?.invalidate()
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
                self.navigationController?.pushViewController(push, animated: true)
                
            }
            
            // self.logTableView.delegate = self
            // self.logTableView.dataSource = self
            // self.logTableView.reloadData()
            
        }
        
    }
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        append(log: "Did joined channel: \(channel), with uid: \(uid), elapsed: \(elapsed)")
        
        print("i am 8 plus")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        append(log: "Did joined of uid: \(uid)")
        
        audioPlayer.stop()
    }
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        append(log: "Did offline of uid: \(uid), reason: \(reason.rawValue)")
        
        for indexx in 0..<self.arrSaveMultipleJoinedUsers.count {
            
            let item = self.arrSaveMultipleJoinedUsers[indexx] as! [String:Any]
            
            if (item["id"] as! String) == "\(uid)" {
                
                print(indexx as Any)
                
                self.arrSaveMultipleJoinedUsers.removeObject(at: indexx)
                
                let myDictionary: [String:String] = [
                
                    "id"        : (item["id"] as! String),
                    "name"      : (item["name"] as! String),
                    "status"    : "no"
                ]
                
                
                /*var res = [[String: String]]()
                res.append(myDictionary)*/
                
                self.arrSaveMultipleJoinedUsers.insert(myDictionary, at: indexx)
                
                print(self.arrSaveMultipleJoinedUsers.count as Any)
                
                if self.arrSaveMultipleJoinedUsers.count == 0 {
                    
                    self.timer?.invalidate()
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
                    self.navigationController?.pushViewController(push, animated: true)
                    
                } else {
                    
                    // self.roomNameLabel.text = "On Call with"
                    // self.lblCounter.isHidden = false
                    // self.startTimer()
                }
                
                
                // self.logTableView.reloadData()
                
                
            } else {
                
            }
            
        }
        
        // print("TOTAL USER IN THIS CHAT IS ==== >",self.arrSaveMultipleJoinedUsers.count as Any)
        
        if self.arrSaveMultipleJoinedUsers.count == 0 {
            self.leaveChannel()
            
            
            
        } else if self.arrSaveMultipleJoinedUsers.count == 1 {
            self.leaveChannel()
            
            
        } else {
            
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioQualityOfUid uid: UInt, quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
        append(log: "Audio Quality of uid: \(uid), quality: \(quality.rawValue), delay: \(delay), lost: \(lost)")
    }
  
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute api: String, error: Int) {
        append(log: "Did api call execute: \(api), error: \(error)")
    }
}


