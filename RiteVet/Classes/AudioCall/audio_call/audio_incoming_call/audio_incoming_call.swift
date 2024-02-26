//
//  audio_incoming_call.swift
//  RiteVet
//
//  Created by Dishant Rajput on 14/02/24.
//  Copyright © 2024 Apple . All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestoreInternal

// for audio call
import AgoraRtcKit
import SwiftUI

class audio_incoming_call: UIViewController  {
    
    var dictGetAllDataForAudioCall:NSDictionary!
    
    var secondsRemaining = 30
    var call_cut_timer:Timer!
    
    var channel_id_for_audio_call:String! = "0"
    
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
    // audio
    // The Agora App ID for the session.
    public let appId: String = AGORA_KEY_ID
    // The client's role in the session.
    /*public var role: AgoraClientRole = .audience {
        didSet { agoraEngine.setClientRole(role) }
    }*/

    // The set of all users in the channel.
    @Published public var allUsers: Set<UInt> = []

    // Integer ID of the local user.
    @Published public var localUserId: UInt = 0

    private var engine: AgoraRtcEngineKit?
    
    fileprivate var agoraKit: AgoraRtcEngineKit!
    var userRole: AgoraClientRole = .broadcaster
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
    
    
    
    @IBOutlet weak var view_accept_decline:UIView! {
        didSet {
            view_accept_decline.isHidden = false
             
        }
    }
    @IBOutlet weak var view_after_Accept:UIView! {
        didSet {
            view_after_Accept.isHidden = true
             
        }
    }
    
    @IBOutlet weak var btn_accept:UIButton! {
        didSet {
            btn_accept.layer.cornerRadius = 40
            btn_accept.clipsToBounds = true
        }
    }
    @IBOutlet weak var btn_decline:UIButton!  {
        didSet {
            btn_decline.layer.cornerRadius = 40
            btn_decline.clipsToBounds = true
        }
    }
    @IBOutlet weak var btn_decline_after_accept:UIButton!  {
        didSet {
            btn_decline_after_accept.layer.cornerRadius = 40
            btn_decline_after_accept.clipsToBounds = true
        }
    }
    @IBOutlet weak var lbl_caller_name:UILabel!  {
        didSet {
            lbl_caller_name.textColor = .white
        }
    }
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var str_sub_label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("====================================")
        print(self.dictGetAllDataForAudioCall as Any)
        print("====================================")
        
        // init agora
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        self.agoraKit.delegate = self
        
        self.lbl_caller_name.text = (self.dictGetAllDataForAudioCall["sender_name"] as! String)
        
        // accept button
        self.btn_accept.addTarget(self, action: #selector(accept_call_click_method), for: .touchUpInside)
        
        // decline button
        self.btn_decline.addTarget(self, action: #selector(call_declined_before_accept_click_method), for: .touchUpInside)
        self.btn_decline_after_accept.addTarget(self, action: #selector(call_declined_after_accept_click_method), for: .touchUpInside)
        
        self.get_firebase_data()
        
        self.check_call_status()
        
        self.play_sound_while_incoming_call()
    }
    
    @objc func get_firebase_data() {
        
        print(String(self.channel_id_for_audio_call))
        Firestore.firestore().collection(audio_call_collection_path)
            .whereField("audio_call_id", isEqualTo: String(self.channel_id_for_audio_call))
        
            .addSnapshotListener() { documentSnapshot, error in
                if error != nil {
                    print("Error to get user lists")
                    
                    return
                }
                
                if let snapshot = documentSnapshot {
                    
                    for document in snapshot.documents {
                        
                        let data = document.data()
                        print(data as Any)
                        
                        if (data["call_status"] as! String) == "receiver_declined" {
                            self.leave_channel()
                            
                            print("===================")
                            print("TIMER : INVALIDATE.")
                            print("===================")
                            self.call_cut_timer.invalidate()
                            
                            self.call_error_popup(text: "Call declined")
                        } else if (data["call_status"] as! String) == "caller_declined" {
                            self.leave_channel()
                            
                            print("===================")
                            print("TIMER : INVALIDATE.")
                            print("===================")
                            self.call_cut_timer.invalidate()
                            
                            self.call_error_popup(text: "Call declined")
                        }
                        
                    }
                    
                } else {
                    print("no, data found")
                }
                
            }
    }
    
    @objc func check_call_status() {
        
        
        Firestore.firestore().collection(audio_call_collection_path)
            .whereField("audio_call_id", isEqualTo: (self.dictGetAllDataForAudioCall["channel"] as! String))
        
        
            .addSnapshotListener() { documentSnapshot, error in
                if error != nil {
                    print("Error to get user lists")
                    
                    return
                }
                
                if let snapshot = documentSnapshot {
                    
                    for document in snapshot.documents {
                        
                        let data = document.data()
                        print(data as Any)
                        
                        if (data["call_status"] as! String) == "caller_declined" {
                            //
                            self.view_accept_decline.isHidden = true
                            self.call_cut_timer.invalidate()
                            self.audioPlayer.stop()
                            self.leave_channel()
                            self.call_error_popup(text: "Call declined")
                        }
                        
                    }
                    
                } else {
                    print("no, data found")
                }
                
            }
    }
    
    @objc func play_sound_while_incoming_call() {
        
        let clickSound = URL(fileURLWithPath: Bundle.main.path(forResource: "inOrOut", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: clickSound)
            audioPlayer.play()
            //
            // start timer
            self.call_cut_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(call_cut_count_down), userInfo: nil, repeats: true)
            
        } catch {
            
        }
        
    }
    
    @objc func call_declined_before_accept_click_method() {
        
        print("===============================================")
        print("FIRESTORE : RECEIVER DECLINE WITHOUT ACCEPTING.")
        print("===============================================")
        
        var query: Query!
        
        query = Firestore.firestore().collection(audio_call_collection_path).whereField("audio_call_id", isEqualTo: (self.dictGetAllDataForAudioCall["channel"] as! String))
        
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
                
                if let documents = snapshot?.documents {
                    
                    Firestore.firestore().collection(audio_call_collection_path)
                    
                    // .whereField("audio_call_id", isEqualTo: documents[0]["audio_call_id"] as! String)
                        .document(documents[0].documentID)
                    
                        .updateData(["call_status": "receiver_declined"])
                    
                    print("=====================================================================")
                    print("=====================================================================")
                    print("FIREBASE : DATA UPDATED SUCCESSFULLY ( call_status )")
                    print("=====================================================================")
                    print("=====================================================================")
                    
                }
                
            }
        }
        
        print("==================")
        print("TIMER : INVALIDATE.")
        print("==================")
        self.call_cut_timer.invalidate()
        
        self.audioPlayer.stop()
        
        let alert = UIAlertController(title: "Call ended", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.push_to_dashboard()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //
    // MARK: - CALL DECLINED AFTER USER ACCEPT THE CALL CLICK METHOD -
    @objc func call_declined_after_accept_click_method() {
        
        self.leave_channel()
        
        self.call_error_popup(text: "Call ended")
    }
    
    @objc func leave_channel() {
        self.agoraKit.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    @objc func push_to_dashboard() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DashboardId")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func call_cut_count_down() {
        
        if secondsRemaining > 0 {
            print("\(secondsRemaining)")
            secondsRemaining -= 1
            
        } else {
            
            print("==================")
            print("TIMER : INVALIDATE")
            print("==================")
            
            self.call_cut_timer.invalidate()
            self.audioPlayer.stop()
            
            self.push_to_dashboard()
            // self.call_error_popup(text: "Call not answered")
            
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
    
    //
    // MARK:- ACCEPT : USER ACCEPT CALL -
    @objc func accept_call_click_method() {
        print("===========================================")
        print("TIMER : INVALIDATE. USER PICKED UP THE CALL")
        print("===========================================")
        
        
        self.call_cut_timer.invalidate()
        
        self.audioPlayer.stop()
        
        // HIDE/UNHIDE VIEWS
        self.view_accept_decline.isHidden = true
        self.view_after_Accept.isHidden = false
        //
        self.getDataForAudioCallSystem()
    }
    
    //
    // MARK: - FIREBASE : -
    func getDataForAudioCallSystem() {
        
        var query: Query!
        
        query = Firestore.firestore().collection(audio_call_collection_path).whereField("audio_call_id", isEqualTo: (self.dictGetAllDataForAudioCall["channel"] as! String))
        
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
                
                if let documents = snapshot?.documents {
                    
                    print(documents[0]["caller_name"] as Any)
                    print(documents[0]["audio_call_id"] as Any)
                
                    self.channel_id_for_audio_call = (documents[0]["audio_call_id"] as! String)
                    
                    self.loadAgoraKit()
                    
                }
                
            }
        }
        
    }
    
    //
    // MARK: - SET UP AGORA -
    
    @objc func init_agora() {
        
    }
    
    // MARK: - CHECK AUDIO CALL PERMISSION -
    static func checkForPermissions() async -> Bool {
        var hasPermissions = await self.avAuthorization(mediaType: .video)
        // Break out, because camera permissions have been denied or restricted.
        if !hasPermissions { return false }
        hasPermissions = await self.avAuthorization(mediaType: .audio)
        return hasPermissions
    }

    static func avAuthorization(mediaType: AVMediaType) async -> Bool {
        let mediaAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch mediaAuthorizationStatus {
        case .denied, .restricted: return false
        case .authorized: return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default: return false
        }
    }
    
    
    func loadAgoraKit()   {
        
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        self.agoraKit.delegate = self
        
        let option = AgoraRtcChannelMediaOptions()
        
        option.clientRoleType = .broadcaster
        option.channelProfile = .communication
        
        let result = agoraKit.joinChannel(
            byToken: "", channelId: String(channel_id_for_audio_call), uid: 0, mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in }
        )
        
        if (result == 0) {
            print("Successfully joined the channel as \(self.userRole)")
            
            
        }
    }
}

extension audio_incoming_call: AgoraRtcEngineDelegate {
    
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        print("Connection Interrupted")
    }
   
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        print("Connection Lost")
    }
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        // append(log: "Occur error: \(errorCode.rawValue)")
        print("Occur error: \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        
         print("info")
    }
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        // append(log: "Did joined channel: \(channel), with uid: \(uid), elapsed: \(elapsed)")
        print("Did joined channel: \(channel), with uid: \(uid), elapsed: \(elapsed)")
         
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
       
        print("Did joined of uid: \(uid)")
        print("==================")
        print("TIMER : INVALIDATE.")
        print("==================")
        self.call_cut_timer.invalidate()
        
        self.str_sub_label.text = "on call"
    }
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
         
        print("Did offline of uid: \(uid), reason: \(reason.rawValue)")
        
        self.leave_channel()
        self.call_error_popup(text: "Call ended")
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioQualityOfUid uid: UInt, quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
         
        print("Audio Quality of uid: \(uid), quality: \(quality.rawValue), delay: \(delay), lost: \(lost)")
    }
  
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute api: String, error: Int) {
         
        print("Did api call execute: \(api), error: \(error)")
    }
}
