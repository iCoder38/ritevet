//
//  outgoing_video_call.swift
//  RiteVet
//
//  Created by Dishant Rajput on 15/02/24.
//  Copyright © 2024 Apple . All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestoreInternal
import Alamofire

// for audio call
import AgoraRtcKit
import SwiftUI

class outgoing_video_call: UIViewController  {
    
    var str_document_id:String!
    
    var str_save_data_in_missed_call:String!
    
    var secondsRemaining = 6
    var call_cut_timer:Timer!
    
    // weak var logVC: LogViewController?
    var agoraKit: AgoraRtcEngineKit!
    var localVideo: AgoraRtcVideoCanvas?
    var remoteVideo: AgoraRtcVideoCanvas?
    
    
    var str_store_channel_name:String!
    
    
    var str_sender_id:String!
    var str_sender_name:String!
    var str_sender_token:String!
    
    var str_receiver_id:String!
    var str_receiver_name:String!
    var str_receiver_token:String!
    
    var str_receiver_token_for_missed_call_notification:String!
    
    var audioPlayer = AVAudioPlayer()
    
    var decline_status_from_caller:String! = "call_missed"
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var localContainer: UIView! {
        didSet {
            localContainer.layer.cornerRadius = 12.0
            localContainer.clipsToBounds = true
        }
    }
    @IBOutlet weak var remoteContainer: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIView!
    @IBOutlet weak var micButton: UIButton! {
        didSet {
            // micButton?.setImage(UIImage(named: audioMuted ? "btn_mute_blue" : "btn_mute"), for: .normal)
        }
    }
    
    var isRemoteVideoRender: Bool = true {
        didSet {
            if let it = localVideo, let view = it.view {
                if view.superview == localContainer {
                    remoteVideoMutedIndicator.isHidden = isRemoteVideoRender
                    remoteContainer.isHidden = !isRemoteVideoRender
                } else if view.superview == remoteContainer {
                    localVideoMutedIndicator.isHidden = isRemoteVideoRender
                }
            }
        }
    }
    
    var isLocalVideoRender: Bool = false {
        didSet {
            if let it = localVideo, let view = it.view {
                if view.superview == localContainer {
                    localVideoMutedIndicator.isHidden = isLocalVideoRender
                } else if view.superview == remoteContainer {
                    remoteVideoMutedIndicator.isHidden = isLocalVideoRender
                }
            }
        }
    }
    
    var isStartCalling: Bool = true {
        didSet {
            if isStartCalling {
                micButton.isSelected = false
            }
            micButton.isHidden = !isStartCalling
            cameraButton.isHidden = !isStartCalling
        }
    }
    
    @IBOutlet weak var view_decline:UIView! {
        didSet {
            view_decline.isHidden = true
             
        }
    }
   
    @IBOutlet weak var btn_decline:UIButton!  {
        didSet {
            btn_decline.layer.cornerRadius = 40
            btn_decline.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_receiver_name:UILabel!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_decline.isHidden = false
        self.btn_decline.addTarget(self, action: #selector(direct_decline_button), for: .touchUpInside)
        
        self.lbl_receiver_name.text = String(self.str_receiver_name)
        
        print(self.str_receiver_name as Any)
        
        // start timer
        self.call_cut_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(call_cut_count_down), userInfo: nil, repeats: true)
        
        // setup agora
        self.enable_and_init_video_camera()
        
    }
    
    @objc func direct_decline_button() {
        self.decline_status_from_caller = "caller_declined"
        self.leave_channel()
    }
    // MARK: - TIMER COUNTDOWN -
    @objc func call_cut_count_down() {
        
        if secondsRemaining > 0 {
            print("\(secondsRemaining)")
            secondsRemaining -= 1
            
        } else {
            
            self.leave_channel()
            
            print("===================")
            print("TIMER : INVALIDATE.")
            print("===================")
            self.call_cut_timer.invalidate()
             
            if (self.str_save_data_in_missed_call != "1"){
                self.missed_call()
            }
            
            self.call_error_popup(text: "Call not answered")
            
        }
        
    }
    
    @objc func missed_call() {
        var query: Query!
        
        query = Firestore.firestore().collection(video_call_collection_path).whereField("video_call_id", isEqualTo: String(self.str_store_channel_name))
        
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
                
                print(snapshot?.documents as Any)
                
                if (self.str_save_data_in_missed_call != "0") {
                    
                    self.call_cut_timer.invalidate()
                    self.audioPlayer.stop()
                    
                    let alert = UIAlertController(title: "Call ended", message: nil, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                        self.push_to_dashboard()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    if let documents = snapshot?.documents {
                        
                        self.str_document_id = "\(documents[0].documentID)"
                        Firestore.firestore().collection(video_call_collection_path)
                        
                        // .whereField("audio_call_id", isEqualTo: documents[0]["audio_call_id"] as! String)
                            .document(documents[0].documentID)
                        
                            .updateData(["call_status": "call_missed"])
                        
                        print("=====================================================================")
                        print("=====================================================================")
                        print("FIREBASE : CALL MISSED ( call_status )")
                        print("=====================================================================")
                        print("=====================================================================")
                        
                    }
                }
               
            }
        }
//        Firestore.firestore().collection(video_call_collection_path)
//        
//        // .whereField("audio_call_id", isEqualTo: documents[0]["audio_call_id"] as! String)
//            .document(self.str_document_id)
//        
//            .updateData(["call_status": "call_missed"])
//        
//        print("=====================================================================")
//        print("=====================================================================")
//        print("FIREBASE : DATA UPDATED SUCCESSFULLY ( call_status )")
//        print("=====================================================================")
//        print("=====================================================================")
        /*
         var :String!
         var :String!
         var :String!
         */
        Firestore.firestore().collection(missed_call_collection_path).addDocument(data: [
            
            "video_call_id" : String(self.str_store_channel_name),
            "type"          : "video",
            "call_status"   : "missed",
            //
            //
            "sender_id"             : String(self.str_sender_id),
            "sender_name"           : String(self.str_sender_name),
            "sender_device"         : String("iOS"),
            "sender_device_token"   : String(self.str_sender_token),
            //
            // receiver's custom data
            "receiver_name"         : String(str_receiver_name),
            "receiver_id"           : String(str_receiver_id),
            "receiver_device_token" : String(str_receiver_token),
            //
            "date"                  : Date.getCurrentDateReal(),
            "time"                  : Date.getCurrentDate(),
            //
            //
            "time_stamp"            : Date.currentTimeStamp,
            //
            "users_ids": [
                String(self.str_sender_id),
                String(self.str_receiver_id)
            ]
            //
        ]){ [self]
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
                print("FIREBASE : MISSED CALL DATA STORE SUCCESSFULLY. NOW SEND NOTIFICATION TO RECEIVER")
                print("=====================================================================")
                print("=====================================================================")
                
                self.missed_call_notification_to_receiver(caller_name: String(self.str_sender_name))
            }
        }
        
    }
    
    @objc func missed_call_notification_to_receiver(caller_name:String) {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            parameters = [
                "action"        : "sendnotification",
                "Token"        : String(self.str_receiver_token_for_missed_call_notification), // receiver's token
                
                "message"       : "Missed call from "+String(caller_name),
                "device"        : String("iOS"), // receiver's device
                
                
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
                            
                            /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "audio_outgoing_call_id") as? audio_outgoing_call
                            
                            push!.str_receiver_name = String(self.str_vendor_name)
                            push!.channel_id_for_audio_call = String(audio_call_id)
                            
                            self.navigationController?.pushViewController(push!, animated: true)*/
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
    //MARK: - AGORA INIT : INIT AGORA THEN ENABLE VIDEO SYSTEM THEN ENABLE LOCAL CAMERA VIEW -
    @objc func enable_and_init_video_camera() {
        // init AgoraRtcEngineKit
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        self.agoraKit.delegate = self
        
        let clickSound = URL(fileURLWithPath: Bundle.main.path(forResource: "inOrOut", ofType: "mp3")!)
        do {
            
            print("===============")
            print("SPEAKER IS TRUE")
            print("===============")
            
            self.audioPlayer = try AVAudioPlayer(contentsOf: clickSound)
            self.audioPlayer.play()
            self.agoraKit.setEnableSpeakerphone(true)
            
            self.audioPlayer.volume = 0.01
            
        } catch {
            
        }
        
        // enable video
        self.agoraKit.enableVideo()
        
        // low frame
        /*agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative, mirrorMode: .auto))*/
        
        
        // high frame
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension2540x1440,
                                                                             frameRate: .fps60,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative, mirrorMode: .auto))
        
        
        
        
        // set data fb
        // self.set_up_firebase_before_set_up()
        
        
        // open local view camera
        self.setupLocalVideo()
    }
    
    // MARK: - LOCAL VIDEO SETUP -
    func setupLocalVideo() {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: localContainer.frame.size))
        localVideo = AgoraRtcVideoCanvas()
        localVideo!.view = view
        localVideo!.renderMode = .hidden
        localVideo!.uid = 0
        localContainer.addSubview(localVideo!.view!)
        agoraKit.setupLocalVideo(localVideo)
        agoraKit.startPreview()
        
        // send data to firebase after call
        self.set_up_firebase_before_set_up()
        
    }
    
    @objc func set_up_firebase_before_set_up() {
        
        self.join_channel(channel_name: String(self.str_store_channel_name))
        
    }
    
    // MARK: - CHECK CALL STATUS EVERYTIME -
    @objc func check_call_status(get_video_call_id:String) {
        
        
        Firestore.firestore().collection(video_call_collection_path)
            .whereField("video_call_id", isEqualTo: String(get_video_call_id))
        
        
            .addSnapshotListener() { documentSnapshot, error in
                if error != nil {
                    print("Error to get user lists")
                    
                    return
                }
                
                if let snapshot = documentSnapshot {
                    
                    for document in snapshot.documents {
                        
                        let data = document.data()
                        print(data as Any)
                        
                        // when receiver declined call
                        if (data["call_status"] as! String) == "receiver_declined" {
                            //
                            // self.view_accept_decline.isHidden = true
                            // self.call_cut_timer.invalidate()
                            // self.audioPlayer.stop()
                            self.leave_channel()
                            self.call_error_popup(text: "Call declined")
                        } else  if (data["call_status"] as! String) == "caller_declined" {
                            //
                            // self.view_accept_decline.isHidden = true
                            // self.call_cut_timer.invalidate()
                            // self.audioPlayer.stop()
                            self.leave_channel()
                            self.call_error_popup(text: "Call declined")
                        }
                        
                    }
                    
                } else {
                    print("no, data found")
                }
                
            }
    }
    
    
    @objc func join_channel(channel_name:String) {
        
        print(channel_name as Any)
        
        // Set audio route to speaker
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        self.agoraKit.delegate = self
        
        let option = AgoraRtcChannelMediaOptions()
        
        option.clientRoleType = .broadcaster
        option.channelProfile = .communication
        
        let result = agoraKit.joinChannel(
            byToken: "", channelId: String(channel_name), uid: 0, mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in }
        )
        
        if (result == 0) {
            print("Successfully joined the channel as ")
            
            // firebase check call status every time
            self.check_call_status(get_video_call_id: String(channel_name))
            
        }
        
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        /*agoraKit.joinChannel(byToken: nil, channelId: "\(channel_name)", info: nil, uid: 0) { [unowned self] (channel, uid, elapsed) -> Void in
            // Did join channel "demoChannel1"
            self.isLocalVideoRender = true
            print("===========================")
            print("SUCCESSFULLY JOINED CHANNEL")
            print("===========================")
            // self.logVC?.log(type: .info, content: "did join channel")
        }*/
        isStartCalling = true
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    // MARK: - LEAVE -
    @objc func leave_channel() {
        self.audioPlayer.stop()
        agoraKit.leaveChannel(nil)
        
        //
        isRemoteVideoRender = false
        isLocalVideoRender = false
        isStartCalling = false
        UIApplication.shared.isIdleTimerDisabled = false
        //
        
        // leaveChannel()
        removeFromParent(localVideo)
        localVideo = nil
        removeFromParent(remoteVideo)
        remoteVideo = nil
        
        self.update_data_in_fb()
        // self.call_error_popup(text: "Call ended")
    }
    
    @objc func update_data_in_fb() {
        
        print("===============================================")
        print("FIRESTORE : CALLER DECLINED THE CALL.")
        print("===============================================")
        
        var query: Query!
        
        query = Firestore.firestore().collection(video_call_collection_path).whereField("video_call_id", isEqualTo: String(self.str_store_channel_name))
        
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
                
                print(snapshot?.documents as Any)
                
                if (self.str_save_data_in_missed_call != "0") {
                    
                    self.call_cut_timer.invalidate()
                    self.audioPlayer.stop()
                    
                    let alert = UIAlertController(title: "Call ended", message: nil, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                        self.push_to_dashboard()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    if let documents = snapshot?.documents {
                        
                        self.str_document_id = "\(documents[0].documentID)"
                        Firestore.firestore().collection(video_call_collection_path)
                        
                        // .whereField("audio_call_id", isEqualTo: documents[0]["audio_call_id"] as! String)
                            .document(documents[0].documentID)
                        
                            .updateData(["call_status": String(self.decline_status_from_caller)])
                        
                        print("=====================================================================")
                        print("=====================================================================")
                        print("FIREBASE : DATA UPDATED SUCCESSFULLY ( call_status )")
                        print("=====================================================================")
                        print("=====================================================================")
                        
                    }
                }
               
            }
        }
        
        print("==================")
        print("TIMER : INVALIDATE.")
        print("==================")
        // self.call_cut_timer.invalidate()
        
        // self.audioPlayer.stop()
        
        let alert = UIAlertController(title: "Call ended", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.push_to_dashboard()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraKit.switchCamera()
    }
    
    @IBAction func didClickLocalContainer(_ sender: Any) {
        switchView(localVideo)
        switchView(remoteVideo)
    }
    
    // MARK: - CANVAS : REMOVE FROM PARENT -
    func removeFromParent(_ canvas: AgoraRtcVideoCanvas?) -> UIView? {
        if let it = canvas, let view = it.view {
            let parent = view.superview
            if parent != nil {
                view.removeFromSuperview()
                return parent
            }
        }
        return nil
    }
    
    // MARK: - CAMERA : SWITCH -
    func switchView(_ canvas: AgoraRtcVideoCanvas?) {
        let parent = removeFromParent(canvas)
        if parent == localContainer {
            canvas!.view!.frame.size = remoteContainer.frame.size
            remoteContainer.addSubview(canvas!.view!)
        } else if parent == remoteContainer {
            canvas!.view!.frame.size = localContainer.frame.size
            localContainer.addSubview(canvas!.view!)
        }
    }
    
    // MARK: - ALERT : ERROR -
    @objc func call_error_popup(text:String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
             self.push_to_dashboard()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func push_to_dashboard() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DashboardId")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    // testing : cjHxmGICoUm3uOCsdPX1LQ:APA91bGazY6JeiN7gF0cNAvVhPMq52G9fLwMhpQbNCgjpUPd9ANuIrGJymi18nxHysGUey3ni0hZw_jvBFDzgwsdNgLmcMBCcN5C9c5FbHTtI9GAFYaZyM7rE5wR3kXKuP8V43DSgAEq
    
    
    
    @objc func send_notification_fore_video_chat(video_call_id:String) {
        var token_1:String!
        var token_2:String!
        
        self.str_store_channel_name = String(video_call_id)
        
        // when run in 7
        token_1 = "e4XnHFi20kNNgG_3d7zy9z:APA91bGsiU8ei0kE9V95CVkdXzSNcTXyGCLu3_CAPApnPNbSGDlr5qJOmgsu-NDmdvYnJ-Ik3sD7A3YDPX9lQntmpMQsHFCyrO1YKGsIldlo7oS9iJcnhAHhzi6VKPIy6LgFz6b52vH_"
        
        
        // when run in max
        token_2 = "ecqQOjjqkEjfjjORhKxl6D:APA91bGIYKKo6oxPpC8eJ-Rnf2coZWMVRd-rz7INSLMxuD4c0SOrtvbPoJdFETfNTmJMEy42LfxHBdzTC15WRL7QS3wG30uPi-6DPqFHVyDBxLz17Nl5QULao1umDSE_ejLEv5D5pPoB"
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString)
            
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            parameters = [
                "action"        : "sendnotification",
                "Token"        : String(token_2), /*String("cjHxmGICoUm3uOCsdPX1LQ:APA91bGazY6JeiN7gF0cNAvVhPMq52G9fLwMhpQbNCgjpUPd9ANuIrGJymi18nxHysGUey3ni0hZw_jvBFDzgwsdNgLmcMBCcN5C9c5FbHTtI9GAFYaZyM7rE5wR3kXKuP8V43DSgAEq"),*/ // receiver's token
                "message"       : (person["fullName"] as! String)+" is calling", // custom message
                "device"        : "iOS", // receiver's device
                
                // receiver's custom data
                "receiver_name"     : String("receiver_name"),
                "receiver_id"       : String("receiver_userId"),
                "receiver_image"    : String("receiver_device_image"),
                
                // sender's custom data
                "sender_id"             : String(myString),
                "sender_name"           : (person["fullName"] as! String),
                "sender_device"         : "iOS",
                "sender_device_token"   : (person["deviceToken"] as! String),
                "sender_image"          : (person["image"] as! String),
                
                //
                //"video_call_id"         : String(video_call_id),
                "channel"               : String(video_call_id),
                
                //
                "type"                  : "videocall",
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
                            
                            /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "audio_outgoing_call_id") as? audio_outgoing_call
                            //push!.dictGetAllDataForAudioCall = dict as NSDictionary
                            push!.channel_id_for_audio_call = String(audio_call_id)
                            self.navigationController?.pushViewController(push!, animated: true)*/
                            
                            // JOIN CHANNEL AFTER SENT NOTIFICATION TO RECEIVER SUCCESSFULLY
                            self.join_channel(channel_name: String(video_call_id))
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
    
}
extension outgoing_video_call: AgoraRtcEngineDelegate {

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        isRemoteVideoRender = true
        
        // audioPlayer.stop()
        
        var parent: UIView = remoteContainer
        if let it = localVideo, let view = it.view {
            if view.superview == parent {
                parent = localContainer
            }
        }

        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        if remoteVideo != nil {
            return
        }

        print("===================")
        print("TIMER : INVALIDATE.")
        print("===================")
        self.call_cut_timer.invalidate()
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: parent.frame.size))
        remoteVideo = AgoraRtcVideoCanvas()
        remoteVideo!.view = view
        remoteVideo!.renderMode = .hidden
        remoteVideo!.uid = uid
        parent.addSubview(remoteVideo!.view!)
        agoraKit.setupRemoteVideo(remoteVideo!)
    }
    
    /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves a channel.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - uid: ID of the user or host who leaves a channel or goes offline.
    ///   - reason: Reason why the user goes offline
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        isRemoteVideoRender = false
        if let it = remoteVideo, it.uid == uid {
            removeFromParent(it)
            remoteVideo = nil
        }
        
         self.leave_channel()
        
    }
    
    /// Occurs when a remote user’s video stream playback pauses/resumes.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - muted: YES for paused, NO for resumed.
    ///   - byUid: User ID of the remote user.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        isRemoteVideoRender = !muted
    }
    
    /// Reports a warning during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - warningCode: Warning code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        // logVC?.log(type: .warning, content: "did occur warning, code: \(warningCode.rawValue)")
    }
    
    /// Reports an error during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - errorCode: Error code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        // logVC?.log(type: .error, content: "did occur error, code: \(errorCode.rawValue)")
    }
}






/*

*/

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
