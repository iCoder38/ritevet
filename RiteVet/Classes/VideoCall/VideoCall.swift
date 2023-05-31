//
//  VideoCall.swift
//  RiteVet
//
//  Created by Apple on 19/02/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit
import AgoraRtcKit

class VideoCall: UIViewController {

    // @IBOutlet weak var viewForCallingUser:UIView!
    // @IBOutlet weak var viewForRemoteUser:UIView!
    
    var agoraKit: AgoraRtcEngineKit?
    
    // Defines localView
    var localView: UIView!
    
    // Defines remoteView
    var remoteView: UIView!
    
    var loginUserId:String!
    var vendorId:String!
    
    var panGesture       = UIPanGestureRecognizer()
    
    @IBOutlet weak var viewMainView:UIView!
    @IBOutlet weak var btnEndCall:UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(vendorId as Any)
        
        self.btnEndCall.addTarget(self, action: #selector(leaveChannel), for: .touchUpInside)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            self.loginUserId = String(myString)
        }
        // This function initializes the local and remote video views
        initView()
        
        // The following functions are used when calling Agora APIs
        initializeAgoraEngine()
        setupLocalVideo()
        joinChannel()
        
    }
    
    // Sets the video view layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        remoteView.frame = self.viewMainView.bounds
        remoteView.backgroundColor = .systemGray4
        
        localView.frame = CGRect(x: self.viewMainView.bounds.width - 140, y: 40, width: 140, height: 140)
        localView.backgroundColor = .systemGray3
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(VideoCall.draggedView(_:)))
        localView.isUserInteractionEnabled = true
        localView.addGestureRecognizer(panGesture)
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(localView)
        let translation = sender.translation(in: self.viewMainView)
        localView.center = CGPoint(x: localView.center.x + translation.x, y: localView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.viewMainView)
    }
    
    func initView() {
            // Initializes the remote video view
        remoteView = UIView()
        // self.view.addSubview(remoteView)
        self.viewMainView.addSubview(remoteView)
            // Initializes the local video view
        localView = UIView()
        // self.view.addSubview(localView)
        self.viewMainView.addSubview(localView)
    }
    
    func initializeAgoraEngine() {
         agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AGORA_KEY_ID, delegate: self)
        
 
     }
    
    // ViewController.swift
    func setupLocalVideo() {
        // Enables the video module
        agoraKit?.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        // Sets the local video view
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    @objc func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func joinChannel() {
        
        // vendorId+loginUserId
        
            agoraKit?.joinChannel(byToken: "", channelId: vendorId+loginUserId, info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
        })
    }
    
}


extension VideoCall: AgoraRtcEngineDelegate {
    // Monitors the firstRemoteVideoDecodedOfUid callback
    // The SDK triggers the callback when it has received and decoded the first video frame from the remote user
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Sets the remote video view
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}
