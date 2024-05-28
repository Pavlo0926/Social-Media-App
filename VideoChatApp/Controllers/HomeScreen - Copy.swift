//
//  HomeScreen.swift
//  VideoChatApp
//
//  Created by Apple on 30/04/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import AudioToolbox
import Alamofire

class HomeScreen: UIViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var followingTbl: UITableView!
    @IBOutlet weak var sideMenuTbl: UITableView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var profileHeightConst: NSLayoutConstraint!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var captionLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var ethnicityLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var stageLbl: UILabel!
    @IBOutlet weak var musicTimeLbl: UILabel!
    
    var loadingIndicator = UIActivityIndicatorView()
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tblBackView: UIView!
    var videoArr = [VideoModel]()
    var masterVideoArr = [VideoModel]()
    
    let actionSheet = ActionSheet()
    let search = ["All Genres", "Band", "Cello", "Choir", "Choreographer", "Composer", "Cover Art", "Drum", "DJ", "Electronic"]
    var avPlayerArr = [AVPlayer]()
    var isFromAddMusicScreen = false
    var isRefeshingTable = false
    var selectedIndex = 0
    
    var isHomeVCC = true
    var genre : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followingTbl.delegate = self as UITableViewDelegate
        followingTbl.dataSource = self as UITableViewDataSource
        sideMenuTbl.delegate = self as UITableViewDelegate
        sideMenuTbl.dataSource = self as UITableViewDataSource

        displayNameLbl.text = UserInfo.shared.stageName
        infoLbl.text = UserInfo.shared.email
        genderLbl.text = UserInfo.shared.gender


//        sideMenuTbl.register(SideMenuCell.self, forCellReuseIdentifier: "SideMenuCell")
//        self.sideMenuTbl.separatorStyle = UITableViewCell.SeparatorStyle.none
//        self.sideMenuTbl.separatorColor = UIColor.clear
//        sideMenuTbl.allowsSelection = true

        self.navigationItem.title = "Following"
        self.tabBarController?.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.transparentViewOnClick(_:)))
        transparentView.addGestureRecognizer(tap)

        let profileViewTap = UITapGestureRecognizer(target: self, action: #selector(self.transparentViewOnClick(_:)))
        profileView.addGestureRecognizer(profileViewTap)

        //coverPhoto.downloaded(from: UserInfo.shared.coverPhotoUrl!)

        profilePic.layer.cornerRadius = 40
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.clipsToBounds = true
//        profilePic.contentMode = .scaleAspectFill
        guard let proPic=UserInfo.shared.dpUrl else {return}
        profilePic.downloaded(from: proPic)
//        profilePic.contentMode = .scaleAspectFill

        transparentView.isHidden = true
        tblBackView.isHidden = true



        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        followingTbl.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        startLoader()
        getData(genre: "")
        
        if isHomeVCC
        {
            transparentView.isHidden = true
            tblBackView.isHidden = true

            profileView.isHidden = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.followingTbl.reloadData()
        })
        
        
    }
    
    @objc func pullToRefresh(sender: UIRefreshControl) {
        isRefeshingTable = true
        if isHomeVCC {
            getData(genre: "")
        } else {
            if genre == "All Genres" {
                
            } else {
                startLoader()
                getData(genre: genre!)
            }
        }
        
//        sender.endRefreshing()
//
//        followingTbl.reloadData()
    }
    
    func getData(genre : String) {
//        startLoader()
        let videoService = VideoService()
        videoService.getVideoData(genre: genre) { (success, response) in
            if success == true {
                self.masterVideoArr = response
                self.videoArr = response
                DispatchQueue.main.async {
                    let artistService = ArtistService()
                    artistService.getFollowedUsers { (success, followUsers) in
                        print(followUsers)
                        if success == true {
                            for video in 0 ..< self.masterVideoArr.count {
                                for user in followUsers {
                                    if self.masterVideoArr[video].loginID! == user {
                                        self.masterVideoArr[video].isFollowing = true
                                        self.videoArr = self.masterVideoArr
                                    }
                                }
                            }
                            
                            artistService.getBlockedUsers(completion: { (success, blockedUsers) in
                                if success == true {
                                    for video in 0 ..< self.masterVideoArr.count {
                                        for user in blockedUsers {
                                            if self.masterVideoArr[video].loginID! == user {
                                                self.masterVideoArr[video].isBlocked = true
                                                self.videoArr = self.masterVideoArr
                                            }
                                        }
                                        
                                    }
                                }
                            })
                            
                            DispatchQueue.main.async {
                                if self.isRefeshingTable == true {
                                    self.refreshControl.endRefreshing()
                                }
                                self.followingTbl.reloadData()
                                self.stopLoader()
                                
                                if self.transparentView.isHidden == false || self.tblBackView.isHidden == false {
                                    if self.isHomeVCC
                                    {
                                        self.transparentView.isHidden = true
                                        self.tblBackView.isHidden = true
                                    }
                                }
                            }
                            
                        } else {
                            DispatchQueue.main.async {
                                self.stopLoader()
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.stopLoader()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("isFromAddMusicScreen", isFromAddMusicScreen)
        
    }
    
    @objc func transparentViewOnClick(_ sender: UITapGestureRecognizer) {
        sender.view?.isHidden = true
        //transparentView.isHidden=true
        self.profileHeightConst.constant = 0.0
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Following"
        tblBackView.isHidden = true
    }
    
    @objc func btnVideoTapped(btn:UIButton)
    {
        let videoURL = URL(string: (videoArr[btn.tag].videoUrl?.replacingOccurrences(of: "\"", with: ""))!)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
    }
    
    @objc func btnOpenProfileTapped(btn:UIButton)
    {
        
        
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 35)
        imageView.invalidateIntrinsicContentSize()
        imageView.contentMode  = .scaleAspectFit
        self.navigationItem.titleView = imageView
        self.profileHeightConst.constant = 450.0
        
        coverPhoto.contentMode = .scaleAspectFit
        profilePic.image = UIImage(named: "dummy_black")
        coverPhoto.image = UIImage(named: "dummy_black")
        displayNameLbl.text = videoArr[btn.tag].stageName
        infoLbl.text = "Email : "+(videoArr[btn.tag].email ?? "")
        
        let cover = videoArr[btn.tag].coverPicUrl!.replacingOccurrences(of: "\"", with: "")
        coverPhoto.downloaded(from: cover)//.image= UIImage(named: "")
        coverPhoto.contentMode = .scaleAspectFit
        let dp = videoArr[btn.tag].profilePicUrl!.replacingOccurrences(of: "\"", with: "") //else{return}
        profilePic.downloaded(from: dp)
        
        profileView.isHidden = false
        
        
        startLoader()
        let artisttService = ArtistService()
        artisttService.getAllUsers { (success, response) in
            if success == true {
                DispatchQueue.main.async {
                    for user in response {
                        if user.email == self.videoArr[btn.tag].email {
                            self.genderLbl.text = "Gender : "+(user.gender ?? "")
                            if user.dob != nil {
                                self.dobLbl.text = "Birth Date : "+self.convertDateToStr(date: user.dob!)
                            } else {
                                self.dobLbl.text = "Birth Date : "
                            }
                            
                            self.ethnicityLbl.text = "Ethnicity : "+(user.ethnicity ?? "")
                            self.genreLbl.text = "Genre : "+(user.musicGenre ?? "")
                            self.locationLbl.text = "Location : "+(user.location ?? "")
                            self.stageLbl.text = "Stage : "+(user.stageName ?? "")
                            self.musicTimeLbl.text = "Music Duration : "+(user.timeInMusic ?? "")
                            self.stopLoader()
                            break
                        }
                    }
                }
            }
        }
    }
    
    @objc func navBackBtnAction() {
        profileView.isHidden = true
        navigationItem.leftBarButtonItem = nil
        startLoader()
        getData(genre: "")
        
    }
    
    func convertDateToStr(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    @IBAction func menuBtnClicked(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.followingTbl)
        
        if let indexPath = followingTbl.indexPathForRow(at: buttonPosition) {
            let rowIndex =  indexPath.row
            print(rowIndex)
            
            if videoArr[indexPath.row].loginID == UserInfo.shared.userId
            {
                let share = ["Share", "Delete"]
                actionSheet.sheetPopUp(controller: self, options: share, sheetTitle: "") { (response) in
                    print("response : ", response)
                    
                    switch (response) {
                    case "Share":
                        print("Share Pressed")
                        let videoUrl=self.videoArr[rowIndex].videoUrl
                        let items = [videoUrl]
                        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        self.present(ac, animated: true)
                        
                    case "Delete":
                        print("Delete Pressed")
                        guard let videoID=self.videoArr[rowIndex].ID else{return}
                        self.deleteVideo(videoId: videoID)
                        
                        
                    default:
                        print("Nothing")
                    
                    }
                }
            }
            else
            {
            
            var follow = "Follow"
            if videoArr[indexPath.row].isFollowing == true {
                follow = "Unfollow"
            }
            
            var block = "Block"
            if videoArr[indexPath.row].isBlocked == true {
                block = "Unblock"
            }
            let share = ["Share", "Report", follow, "Message", "Video Call", block]
                actionSheet.sheetPopUp(controller: self, options: share, sheetTitle: "") { (response) in
                print("response : ", response)
                
                switch (response) {
                case "Follow":
                    self.startLoader()
                    let artistService = ArtistService()
                    artistService.followUser(params: ["selfuserid":UserInfo.shared.userId!, "otheruserid": self.videoArr[indexPath.row].loginID!, "type":"follow"], completion: { (success, response) in
                        DispatchQueue.main.async {
                            self.sendMessage(token: self.videoArr[indexPath.row].fcm!, title: "Following", body: UserInfo.shared.firstName!+" followed you", msgType: "follow")
                            self.getData(genre: "")
                        }
                        
                    })
                    
                case "Unfollow":
                    self.startLoader()
                    let artistService = ArtistService()
                    artistService.followUser(params: ["selfuserid":UserInfo.shared.userId!, "otheruserid": self.videoArr[indexPath.row].loginID!, "type":"unfollow"], completion: { (success, response) in
                        DispatchQueue.main.async {
                            self.getData(genre: "")
                        }
                        
                    })
                    
                case "Message":
//                    let msgVc = self.tabBarController?.viewControllers?[3] as! Messages
//                    msgVc.emailTo = self.videoArr[indexPath.row].email
//                    msgVc.fcmTo = self.videoArr[indexPath.row].fcm
                    
//                    let navController = self.tabBarController?.viewControllers![3] as! UINavigationController
//                    let msgVc = navController.topViewController as! Messages
//                    msgVc.emailTo = self.videoArr[indexPath.row].email
//                    msgVc.fcmTo = self.videoArr[indexPath.row].fcm
                    
//                    self.tabBarController?.selectedIndex = 3
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Messages") as? Messages
                    vc!.emailTo = self.videoArr[indexPath.row].email
                    vc!.fcmTo = self.videoArr[indexPath.row].fcm
                    vc!.deviceTokenForVideoCall = self.videoArr[indexPath.row].appletoken!
                    let user = UserModel()
                    user.userId = self.videoArr[indexPath.row].loginID
                    user.firstName = self.videoArr[indexPath.row].artistName
                    vc!.toUser = user
                    
            //        self.tabBarController?.selectedIndex = 3
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                    // HomeToMessages
                case "Video Call":
//                    self.selectedIndex = indexPath.row
                    self.performSegue(withIdentifier: "HomeToVideoCall", sender: self.videoArr[indexPath.row].appletoken!)
                case "Block":
                    self.startLoader()
                    let artistService = ArtistService()
                    artistService.blockUser(params: ["selfuserid":UserInfo.shared.userId!, "otheruserid": self.videoArr[indexPath.row].loginID!, "type":"block"], completion: { (success, response) in
                        DispatchQueue.main.async {
                            self.getData(genre: "")
                        }
                        
                    })
                    
                case "Unblock":
                    self.startLoader()
                    let artistService = ArtistService()
                    artistService.blockUser(params: ["selfuserid":UserInfo.shared.userId!, "otheruserid": self.videoArr[indexPath.row].loginID!, "type":"unblock"], completion: { (success, response) in
                        DispatchQueue.main.async {
                            self.getData(genre: "")
                        }
                        
                    })
                    
                case "Share":
                    let videoUrl=self.videoArr[rowIndex].videoUrl
                    let items = [videoUrl]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    self.present(ac, animated: true)
                default:
                    print("default")
                }
            }
        }
        }
    }
    
    func deleteVideo(videoId : String) {
        //        startLoader()
        let videoService = VideoService()
        let param=["videoid":videoId]
        videoService.deleteVideoData(params: param) { (success) in
            if success {
                
                self.getData(genre: "")
                //self.profileTbl.reloadData()
            }
            else {
                alert(msg: "Video not Deleted", controller: self)
            }
        }
    }
    
    func startLoader() {
        self.view.isUserInteractionEnabled = false
        loadingIndicator.frame = CGRect(x: (self.view.frame.width / 2) - 50, y: (self.view.frame.height / 2) - 25, width: 25, height: 50)
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
    }
    
    func stopLoader() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
    func sideMenuItemOnClick(selectedOption : String) {
        //transparentView.isUserInteractionEnabled = false
        print(selectedOption)
        genre = selectedOption
        if selectedOption == "All Genres" {
            
        } else {

            startLoader()
            getData(genre: selectedOption)
        }
    }
    
    func sendMessage(token : String, title : String, body : String, msgType : String) {
        let legacyServerKey = "AAAAtpsYuXw:APA91bHJSeBC2FbImlWW3ti_UU6Y-34tdAxriheBPSeXdiGOOP0LC0NFHE4TmsyB2V6Ox2sbB4bl8I16bYQl5LU9_R3IlYMPR1HV7ohahXqlpBI2MsP0S-Z_BJKseYWjIem5w_Fs9EbH"
        let headers = [
            "Authorization": "key=AAAAtpsYuXw:APA91bHJSeBC2FbImlWW3ti_UU6Y-34tdAxriheBPSeXdiGOOP0LC0NFHE4TmsyB2V6Ox2sbB4bl8I16bYQl5LU9_R3IlYMPR1HV7ohahXqlpBI2MsP0S-Z_BJKseYWjIem5w_Fs9EbH",
            "Content-Type": "application/json"
        ]
        
        let params : [String : Any] = ["to" : token,
                                       "notification" : ["title" : title, "body" : body],
                                       "data" : ["user" : "follow"]]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                print(response)
//to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
//to get JSON return value
            if let result = response.result.value {
                let JSON = result as! NSDictionary
//                print(JSON)
//                print(JSON["success"])
//                self.saveMessageToFirebase(chatRoom: self.chatRoom, message: body, emailFrom: self.currentEmail!, msgType: msgType)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToVideoCall" {
            let videoCallVC = segue.destination as? MainController
            videoCallVC!.deviceTokenForVideoCall = (sender as? String)!
        }
    }
}

extension HomeScreen: UITableViewDelegate, UITableViewDataSource, AVPlayerViewControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == followingTbl {
            return videoArr.count
        } else {
            return search.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == followingTbl {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFollowCell", for: indexPath) as! HomeFollowCell
            
            if (cell.videoView.layer.sublayers) != nil {
                for layere in cell.videoView.layer.sublayers! {
                    if layere.isKind(of: AVPlayerLayer.self)
                    {
                        layere.removeFromSuperlayer()
                    }
                }
            }
            
            cell.btnVideo.tag=indexPath.row
            cell.btnVideo.addTarget(self, action: #selector(self.btnVideoTapped(btn:)), for: UIControl.Event.touchUpInside)
            
            cell.btnOpenProfile.tag=indexPath.row
            cell.btnOpenProfile.addTarget(self, action: #selector(self.btnOpenProfileTapped(btn:)), for: UIControl.Event.touchUpInside)
            
            cell.displayPicture.image = UIImage(named: "dummy_black")
            let dp = videoArr[indexPath.row].profilePicUrl!.replacingOccurrences(of: "\"", with: "")
            print("display pic url before : ", videoArr[indexPath.row].profilePicUrl!)
            cell.displayPicture.downloaded(from: dp)
            cell.displayName.text = videoArr[indexPath.row].stageName
            cell.title.text = videoArr[indexPath.row].songTitle
            let videoUrl = videoArr[indexPath.row].videoUrl?.replacingOccurrences(of: "\"", with: "")
            cell.videoView.image = UIImage(named: "dummy_black")
            
            var player = AVPlayer()
            player.replaceCurrentItem(with: nil)
            if let videoUrl1 = URL(string: videoUrl!){
                print("cell : ", indexPath.row)
                print(videoUrl1)
                player = AVPlayer(url: videoUrl1)
                
                let playerLayer = AVPlayerLayer(player: player)
                player.automaticallyWaitsToMinimizeStalling = false
                playerLayer.frame = cell.videoView.frame
                cell.videoView.layer.addSublayer(playerLayer)
                player.volume = 0
//                player.replaceCurrentItem(with: nil)
                player.play()
                
                //avPlayerArr.append(player)
                
                playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
            cell.genreLbl.text = search[indexPath.row]
            return cell
        }
//        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 20.0
        if tableView == followingTbl {
            cellHeight = 380
        }else {
            cellHeight = tableView.frame.height / CGFloat(search.count)
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect")
        if tableView == followingTbl {
            
            
        } else {
            videoArr = masterVideoArr
            
            sideMenuItemOnClick(selectedOption: search[indexPath.row])
            transparentView.isHidden=true
            tblBackView.isHidden = true
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Item : ", tabBarController.selectedIndex)
        if tabBarController.selectedIndex == 1 {
            //tabBarController.selectedIndex = 0
            
            transparentView.isHidden = false
            tblBackView.isHidden = false
            profileView.isHidden = true
        }else
        {
            transparentView.isHidden = true
            tblBackView.isHidden = true
            profileView.isHidden = true
        }
        
        if tabBarController.selectedIndex == 0 {
            startLoader()
            getData(genre: "")
        }
        

        /*if tabBarController.selectedIndex == 4 {
            //tabBarController.selectedIndex = 0
            profileView.isHidden = false
        } else {
            profileView.isHidden = true
        }*/
    }
    
    
//     func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
//        if item == (self.tabBar.items as! [UITabBarItem])[0]{
//           //Do something if index is 0
//        }
//        else if item == (self.tabBar.items as! [UITabBarItem])[1]{
//           //Do something if index is 1
//        }
//    }
    
    func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController){
        print("playerViewControllerWillStartPictureInPicture")
    }
    
    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController)
    {
        print("playerViewControllerDidStartPictureInPicture")
        
    }
    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error)
    {
        print("failedToStartPictureInPictureWithError")
    }
    func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController)
    {
        print("playerViewControllerWillStopPictureInPicture")
    }
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController)
    {
        print("playerViewControllerDidStopPictureInPicture")
    }
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool
    {
        print("playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart")
        return true
    }
    

}
