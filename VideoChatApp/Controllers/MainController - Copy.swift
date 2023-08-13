

//
//  MainController.swift
//  VideoChatApp
//
//  Created by Apple on 28/04/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
//import AVKit
//import AVFoundation
import AgoraRtcKit
//import AgoraRtcEngineKit
import CallKit

class MainController: UIViewController, CXProviderDelegate {

    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var callReceiverView: UIView!
    
    @IBOutlet weak var btnOkClick:UIButton!
    
    @IBOutlet weak var lblOutGoingCall:UILabel!
    @IBOutlet weak var lblRinging:UILabel!
    
    
    var agoraKit : AgoraRtcEngineKit?
    
    var isFromAppDelegate=false
    
//    var token = "006755439491731488ea6d2aca9a988e145IAB77SsKIPqca1mdhX2FjTkhyy6SSToohQ/nYbybxgoUmbWLdcoAAAAAEADxldpwC1HSXgEAAQALUdJe"
    var token = ""
    let appId = "755439491731488ea6d2aca9a988e145"
    var useraccount = ""
    var deviceTokenForVideoCall = ""
    var callerNameForVideoCall = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("voipcall"), object: nil)
        
        let authService = AuthenticationService()
        authService.getTokenForVideoCall(params: ["channelName" : "channel_soundplg", "uid" : "0"]) { (success, response) in
            if success == true {
                self.token = (response?["intuid"] as? String)!
                self.useraccount = (response?["useraccount"] as? String)!
                
//                DispatchQueue.main.async {
//                    self.initializeAgoraEngine()
//                    self.setupLocalVideo(view: self.localView)
//                    self.joinChannel()
//
//
//                }
                
            }
        }
//        when user side application recives a call
        if isFromAppDelegate
        {
            let authService = AuthenticationService()
            authService.getTokenForVideoCall(params: ["channelName" : "channel_soundplg", "uid" : "0"]) { (success, response) in
                if success == true {
                    self.token = (response?["intuid"] as? String)!
                    self.useraccount = (response?["useraccount"] as? String)!
                    
                    DispatchQueue.main.async {
                        self.initializeAgoraEngine()
                        self.setupLocalVideo(view: self.localView)
                        self.joinChannel()
                        
                        
                    }
                    
                }
            }

        }
        else
        {
            /*self.SendCallPush(params: ["devicetoken" : "2e1371ad40d170dab488d61c76cf091edbf5340ef867f82424041e09c9d53ad7", "callername" : "Wahab"]) { (success, data) in
                
                print("")
            }*/
            
            print("deviceTokenForVideoCall:",deviceTokenForVideoCall)
            
            self.SendCallPush(params: ["devicetoken" : "\(deviceTokenForVideoCall)", "callername" : "\(UserInfo.shared.firstName!)"]) { (success, data) in
                DispatchQueue.main.async {
                    self.initializeAgoraEngine()
                    self.joinChannel()
                    
                    self.callReceiverView.isHidden = false
                    self.setupLocalVideo(view: self.callReceiverView)
                }
                
            }
        }
        
//        let videoUrl = "http://www.waqarulhaq.com/onboard-app/videos/637248161609756800"
//        let avPlayer = AVPlayer(url: URL(fileURLWithPath: videoUrl))
//        playerView.playerLayer.player = avPlayer
//        playerView.player.play()
        
        
        
        
    }
    
    func SendCallPush (params : [String : String], completion: @escaping (Bool, NSDictionary? ) -> ()) {
            let url = URL(string: "http://waqarulhaq.com/onboard-app/makecall.php")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            var paramStr = "devicetoken="+params["devicetoken"]!
            paramStr = paramStr+"&callername="+params["callername"]!+"&isdev=1"  // +"&isdev=1"
            request.httpBody = paramStr.data(using: String.Encoding.utf8)
            
    //        request.httpBody = "email=user1@gmail.com&type=simple&token=user1".data(using: String.Encoding.utf8)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completion(false, nil)
                    if error == nil {
                        print(error?.localizedDescription ?? "Unknown Error")
                    }
                    return
                }
                
                print("response")
                print(response)
                
                do {
                    
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                    
                    if let resDic = jsonResponse as NSDictionary?{
                        print("resDic")
                        print(resDic)
                        
                        let isSuccess = resDic["issuccess"] as? Bool
                        
                        if isSuccess == true {
                            
                            completion(true, resDic)
                        } else {
                            completion(false, resDic)
                        }
                    }
                    
                } catch  let error {
                    completion(false, nil)
                    print(error.localizedDescription)
                }
                
                }.resume()
        }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "VideoChatApp"))
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Test User")
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
        
    }
    
    func providerDidReset(_ provider: CXProvider) {
        print(provider)
        }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
            action.fulfill()
        }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
            action.fulfill()
        }
    
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self as! AgoraRtcEngineDelegate)
    }
    
    func setupLocalVideo(view:UIView) {
        agoraKit?.enableVideo()

        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = view//localView
        videoCanvas.renderMode = .hidden
        

        agoraKit?.setupLocalVideo(videoCanvas)
    }
//    when user accept call while sending
    func joinChannel(){
        //006755439491731488ea6d2aca9a988e145IAA4yxjvbKGmpTu/W6OI7/3J0l0ZTRSkaaF5rh7U++I3fLWLdcoAAAAAEADxldpw3QvVXgEAAQDcC9Ve
        agoraKit?.joinChannel(byToken: self.token, channelId: "channel_soundplg", info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
            print("Succesfully joined channel \(channel)")
            
            //self.callReceiverView.isHidden = true
            
        })
    }
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        localView.isHidden = true
        remoteView.isHidden = true
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnOnClick(_ sender: Any) {
        leaveChannel()
    }
    
    @IBAction func acceptCallBtnAction(_ sender: Any) {
//        joinChannel()
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = Constants.shared.videoCallUdid!
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .hidden
        print("video call uid : ", Constants.shared.videoCallUdid)
        agoraKit?.setupRemoteVideo(videoCanvas)
        callReceiverView.isHidden = true
    }
    
    @IBAction func joinChannelBtnAction(_ sender: Any) {
        
        joinChannel()
    }
    
    @IBAction func rejectCallBtnAction(_ sender: Any) {
        callReceiverView.isHidden = true
        leaveChannel()
    }
}

extension MainController: AgoraRtcEngineDelegate {
    
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        
        print("call uid : ", uid)
        Constants.shared.videoCallUdid = uid
        //callReceiverView.isHidden = false
        
        
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = Constants.shared.videoCallUdid!
        videoCanvas.view = self.remoteView
        videoCanvas.renderMode = .hidden
        print("video call uid : ", Constants.shared.videoCallUdid)
        self.agoraKit?.setupRemoteVideo(videoCanvas)
        self.callReceiverView.isHidden = true
        self.setupLocalVideo(view: self.localView)
        self.lblOutGoingCall.isHidden=true
        self.lblRinging.isHidden=true
        self.view.bringSubviewToFront(btnOkClick)//btnOkClick.
        
        print("Remote video received")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
//        isRemoteVideoRender = false
        print("didOfflineOfUid")
        
//        dismiss(animated: true, completion: nil)
    }
    
    /// Occurs when a remote user’s video stream playback pauses/resumes.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - muted: YES for paused, NO for resumed.
    ///   - byUid: User ID of the remote user.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
//        isRemoteVideoRender = !muted
        print("didVideoMuted")
    }
    
    /// Reports a warning during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - warningCode: Warning code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("did occur warning, code: \(warningCode.rawValue)")
    }
    
    /// Reports an error during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - errorCode: Error code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("did occur error, code: \(errorCode.rawValue)")
    }
}
