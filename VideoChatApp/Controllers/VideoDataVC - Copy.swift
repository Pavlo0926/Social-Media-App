//
//  VideoDataVC.swift
//  VideoChatApp
//
//  Created by Apple on 11/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoDataVC: UIViewController {

    @IBOutlet weak var cationSV: UIStackView!
    @IBOutlet weak var genreSV: UIStackView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var captionTF: UITextField!
    @IBOutlet weak var selectGenreBtn: UIButton!
    
    @IBOutlet weak var videoViewImg: UIImageView!
    @IBOutlet weak var videoView: UIView!
    var loadingIndicator = UIActivityIndicatorView()
    var player = AVPlayer()
    
    var videoServerUrl: String!
    var videoData = VideoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("videoServerUrl : ", videoServerUrl)
        videoData.videoUrl = videoServerUrl.replacingOccurrences(of: "\\", with: "")
        print("filtered url : ", videoData.videoUrl!)
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupVideo(videoUrl: videoData.videoUrl!.replacingOccurrences(of: "\"", with: ""))
    }
    
    func setupVideo(videoUrl : String) {
        
        if let videoUrl1 = URL(string: videoUrl){
            player = AVPlayer(url: videoUrl1)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoViewImg.bounds
            videoViewImg.layer.addSublayer(playerLayer)
            player.play()
            
//            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
    }

    @IBAction func genreBtnOnClick(_ sender: Any) {
        let actionSheet = ActionSheet()
        actionSheet.sheetPopUp(controller: self, options: ["Band", "Cello", "Choir", "Choreographer", "Composer", "Cover Art", "Drum", "DJ", "Electronic"], sheetTitle: "Genre") { (selection) in
            print(selection)
            self.videoData.genre = selection
        }
    }
    
    @IBAction func captionBtnOnClick(_ sender: Any) {
        genreSV.isHidden = true
        cationSV.isHidden = false
        
        selectGenreBtn.isHidden = false
    }
    
    
    @IBAction func selectGenreBtnAction(_ sender: UIButton) {
        
        let actionSheet = ActionSheet()
        actionSheet.sheetPopUp(controller: self, options: ["Band", "Cello", "Choir", "Choreographer", "Composer", "Cover Art", "Drum", "DJ", "Electronic"], sheetTitle: "Genre") { (selection) in
            print(selection)
            self.videoData.genre = selection
        }
    }
    
    @IBAction func continueBtnOnClick(_ sender: Any) {
        if videoData.genre == nil{
            let alertController = UIAlertController(title: "", message: "Please select genre first", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                print("do nothing")
            }
            
            
            // Add the actions
            alertController.addAction(okAction)
            
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }else{
            player.pause()
            startLoader()
            
            videoData.songTitle = titleTF.text
            videoData.caption = "caption"
            
            
            let videoService = VideoService()
            
            let userID = UserDefaults.standard.string(forKey: "userId")
//            let username = UserDefaults.standard.string(forKey: "fname") as? String ?? ""
            let userName =  UserInfo.shared.stageName ?? ""
            
            let params : [String : String] = ["loginID" : userID!, "artistname" : userName, "title" : videoData.songTitle!, "genre" : videoData.genre!, "caption" : videoData.caption!, "file" : videoData.videoUrl!]
            
            videoService.uploadVideoData(params: params) { (success) in
                print(success)
                DispatchQueue.main.async {
                    self.stopLoader()
                    
                    self.popNavigationCompletion(completion: { (success) in
                        self.tabBarController?.selectedIndex = 0
                        //                    let homeScreen = self.tabBarController?.viewControllers![0] as! HomeScreen
                        //                    homeScreen.isFromAddMusicScreen = true
                        //                    self.tabBarController?.selectedIndex = 0
                    })
                    //                alertWithCompletion(msg: "Data saved successfully!", controller: self, onCompletion: { (success) in
                    //                    self.navigationController?.popViewController(animated: true)
                    //                    self.tabBarController?.selectedIndex = 0
                    //                })
                }
            }
            
        }
        
    }
    
    func popNavigationCompletion(completion: @escaping (Bool) -> ()) {
        self.navigationController?.popViewController(animated: true)
        completion(true)
    }
    
    func startLoader() {
        self.view.isUserInteractionEnabled = false
        loadingIndicator.frame = CGRect(x: (self.view.frame.width / 2) - 50, y: (self.view.frame.height / 2) - 25, width: 25, height: 50)
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        self.view.addSubview(loadingIndicator)
    }
    
    func stopLoader() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
