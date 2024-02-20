//
//  audio_outgoing_call.swift
//  RiteVet
//
//  Created by Dishant Rajput on 13/02/24.
//  Copyright © 2024 Apple . All rights reserved.
//

import UIKit
import FirebaseFirestoreInternal

// for audio call
import AgoraRtcKit
import SwiftUI

import AVFoundation

class audio_outgoing_call: UIViewController {

    var secondsRemaining = 10
    var call_cut_timer:Timer!
    
    var dictGetAllDataForAudioCall:NSDictionary!
    
    var channel_id_for_audio_call:String!
    
    var str_receiver_name:String!
    
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
    
    @IBOutlet weak var lbl_caller_name:UILabel!  {
        didSet {
            lbl_caller_name.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_decline:UIButton!  {
        didSet {
            btn_decline.layer.cornerRadius = 40
            btn_decline.clipsToBounds = true
        }
    }
    
    var audioPlayer = AVAudioPlayer()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("====================================")
        print(self.dictGetAllDataForAudioCall as Any)
        print("====================================")
        
        
        // init agora
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
            
        } catch {
            
        }
        
        
        
        
        self.loadAgoraKit()
        
        self.lbl_caller_name.text = String(self.str_receiver_name)
        //(self.dictGetAllDataForAudioCall["receiver_name"] as! String)
        
        self.get_firebase_data()
        
        self.btn_decline.addTarget(self, action: #selector(call_declined_after_accept_click_method), for: .touchUpInside)
        
        // start timer
        self.call_cut_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(call_cut_count_down), userInfo: nil, repeats: true)
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
                        }
                        
                    }
                    
                } else {
                    print("no, data found")
                }
                
            }
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
             
            self.call_error_popup(text: "Call not answered")
            
        }
        
    }
    
    // MARK: - CALL DECLINED AFTER USER ACCEPT THE CALL CLICK METHOD -
    @objc func call_declined_after_accept_click_method() {
        
        self.call_decline_after_call_but_receiver_not_picked()
    }
    
    // MARK: - DECLINE CALL -
    @objc func leave_channel() {
        self.agoraKit.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
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
  
    @objc func call_decline_after_call_but_receiver_not_picked() {
        
        print("===============================================")
        print("FIRESTORE : RECEIVER DECLINE WITHOUT ACCEPTING.")
        print("===============================================")
        
        var query: Query!
        
        query = Firestore.firestore().collection(audio_call_collection_path).whereField("audio_call_id", isEqualTo: String((self.channel_id_for_audio_call)))
        
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
                    
                        .document(documents[0].documentID)
                    
                        .updateData(["call_status": "caller_declined"])
                    
                    print("=====================================================================")
                    print("=====================================================================")
                    print("FIREBASE : DATA UPDATED SUCCESSFULLY ( call_status )")
                    print("=====================================================================")
                    print("=====================================================================")
                    
                }
                
            }
        }
        
        self.leave_channel()
        
        print("===================")
        print("TIMER : INVALIDATE.")
        print("===================")
        self.call_cut_timer.invalidate()
        
        self.call_error_popup(text: "Call ended")
        
    }
    
    // MARK: - SAVE MISSED CALL -
    @objc func save_missed_call() {
        
    }
    
}

extension audio_outgoing_call: AgoraRtcEngineDelegate {
    
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
    }
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
         
        print("Did offline of uid: \(uid), reason: \(reason.rawValue)")
        
        self.leave_channel()
        
        print("===================")
        print("TIMER : INVALIDATE.")
        print("===================")
        self.call_cut_timer.invalidate()
        
        self.call_error_popup(text: "Call ended")
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioQualityOfUid uid: UInt, quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
         
        print("Audio Quality of uid: \(uid), quality: \(quality.rawValue), delay: \(delay), lost: \(lost)")
    }
  
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute api: String, error: Int) {
         
        print("Did api call execute: \(api), error: \(error)")
    }
}
