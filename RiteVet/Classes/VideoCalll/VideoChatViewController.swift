//
//  VideoChatViewController.swift
//  Agora iOS Tutorial
//
//  Created by James Fang on 7/14/16.
//  Copyright © 2016 Agora.io. All rights reserved.
//

import UIKit
import AgoraRtcKit
import AVFoundation

class VideoChatViewController: UIViewController {
    
    @IBOutlet weak var localContainer: UIView!
    @IBOutlet weak var remoteContainer: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIView!
    @IBOutlet weak var micButton: UIButton! {
        didSet {
            // micButton?.setImage(UIImage(named: audioMuted ? "btn_mute_blue" : "btn_mute"), for: .normal)
        }
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    // weak var logVC: LogViewController?
    var agoraKit: AgoraRtcEngineKit!
    var localVideo: AgoraRtcVideoCanvas?
    var remoteVideo: AgoraRtcVideoCanvas?
    
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
    
    
    
    
    
    var roomName: String!
    var setSteps:String!
    var callerName:String!
    var callerImage:String!
    var dictOfNotificationPopup:NSDictionary!
    
    
    var strIamCallingTo:String!
    
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
    
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is our usual steps for joining
        // a channel and starting a call.
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let clickSound = URL(fileURLWithPath: Bundle.main.path(forResource: "inOrOut", ofType: "mp3")!)
        
        if "\(setSteps!)" == "1" { // call is incoming
            
            self.initializeAgoraEngine()
            
            print("\(setSteps!)")
            print("\(callerName!)")
            print("\(callerImage!)")
            
            self.lblCallerName.text = "\(callerName!)"
            self.fullIncomingCallView.isHidden = false
            imgProfilePicture.sd_setImage(with: URL(string: "\(callerImage!)"), placeholderImage: UIImage(named: "logo-500"))
            
            do {
                
                 audioPlayer = try AVAudioPlayer(contentsOf: clickSound)
                 audioPlayer.play()
                
            } catch {
                
            }
            
        } else if "\(setSteps!)" == "2" { // who start the call
            
            // self.roomNameLabel.text = "ringing..."
            self.fullIncomingCallView.isHidden = true
            
            self.initializeAgoraEngine()
            self.setupVideo()
            self.setupLocalVideo()
            self.joinChannel()
            
            // self.lblCallerName.text = "\(callerName!)"
            // self.imgProfilePicture.dowloadFromServer(link:"\(callerImage!)", contentMode: .scaleToFill)
            
            do {
                
                 audioPlayer = try AVAudioPlayer(contentsOf: clickSound)
                 audioPlayer.play()
                
            } catch {
                
            }
            
        }
        
        self.btnIncomingCallAccept.addTarget(self, action: #selector(incomingAcceptClickMethod), for: .touchUpInside)
        self.btnIncomingCallDecline.addTarget(self, action: #selector(incomingDeclineClickMethod), for: .touchUpInside)
        
    }
    
    @objc func incomingAcceptClickMethod() {
        audioPlayer.stop()
        self.fullIncomingCallView.isHidden = true
        
        self.initializeAgoraEngine()
        self.setupVideo()
        self.setupLocalVideo()
        self.joinChannel()
        
    }
    
    @objc func incomingDeclineClickMethod() {
        audioPlayer.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        /*if identifier == "EmbedLogViewController",
            let vc = segue.destination as? LogViewController {
            self.logVC = vc
        }*/
        
    }
    
    func initializeAgoraEngine() {
        
        // init AgoraRtcEngineKit
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        agoraKit.delegate = self
        
    }

    func setupVideo() {
        // In simple use cases, we only need to enable video capturing
        // and rendering once at the initialization step.
        // Note: audio recording and playing is enabled by default.
        agoraKit.enableVideo()
        
        // Set video configuration
        // Please go to this page for detailed explanation
        // https://docs.agora.io/cn/Voice/API%20Reference/java/classio_1_1agora_1_1rtc_1_1_rtc_engine.html#af5f4de754e2c1f493096641c5c5c1d8f
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative, mirrorMode: .auto))
    }
    
    func setupLocalVideo() {
        // This is used to set a local preview.
        // The steps setting local and remote view are very similar.
        // But note that     if the local user do not have a uid or do
        // not care what the uid is, he can set his uid as ZERO.
        // Our server will assign one and return the uid via the block
        // callback (joinSuccessBlock) after
        // joining the channel successfully.
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: localContainer.frame.size))
        localVideo = AgoraRtcVideoCanvas()
        localVideo!.view = view
        localVideo!.renderMode = .hidden
        localVideo!.uid = 0
        localContainer.addSubview(localVideo!.view!)
        agoraKit.setupLocalVideo(localVideo)
        agoraKit.startPreview()
    }
    
    func joinChannel() {
        // Set audio route to speaker
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        agoraKit.joinChannel(byToken: nil, channelId: "\(roomName!)", info: nil, uid: 0) { [unowned self] (channel, uid, elapsed) -> Void in
            // Did join channel "demoChannel1"
            self.isLocalVideoRender = true
            // self.logVC?.log(type: .info, content: "did join channel")
        }
        isStartCalling = true
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func leaveChannel() {
        // leave channel and end chat
        agoraKit.leaveChannel(nil)
        
        isRemoteVideoRender = false
        isLocalVideoRender = false
        isStartCalling = false
        UIApplication.shared.isIdleTimerDisabled = false
        // self.logVC?.log(type: .info, content: "did leave channel")
        
        if "\(setSteps!)" == "1" {
            
             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
             self.navigationController?.pushViewController(push, animated: true)
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            leaveChannel()
            removeFromParent(localVideo)
            localVideo = nil
            removeFromParent(remoteVideo)
            remoteVideo = nil
        } else {
            setupLocalVideo()
            joinChannel()
        }
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
}

extension VideoChatViewController: AgoraRtcEngineDelegate {

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        isRemoteVideoRender = true
        audioPlayer.stop()
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
        
        
        
        
        self.leaveChannel()
        
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

