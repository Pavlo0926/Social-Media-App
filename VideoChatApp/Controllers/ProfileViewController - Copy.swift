//
//  ProfileViewController.swift
//  VideoChatApp
//
//  Created by Apple on 19/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation
import MediaPlayer
import AudioToolbox
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var coverPhoto: UIImageView!
    
    @IBOutlet weak var profileHeightConst: NSLayoutConstraint!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var ethnicityLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var musicLbl: UILabel!
    @IBOutlet weak var stageLbl: UILabel!
    @IBOutlet weak var musicTimeLbl: UILabel!
    @IBOutlet weak var lblMusicIndustry: UILabel!
    
    @IBOutlet weak var profileTbl: UITableView!
    @IBOutlet weak var collViewProfileVids: UICollectionView!
    
    let actionSheet = ActionSheet()
    
    var videoArr = [VideoModel]()
    var masterVideoArr = [VideoModel]()
    
    var loadingIndicator = UIActivityIndicatorView()
    var refreshControl = UIRefreshControl()
    
    var isRefeshingTable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTbl.delegate = self
        profileTbl.dataSource = self
        
       
        
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 100, y: 0, width: 130, height: 35)
        imageView.invalidateIntrinsicContentSize()
        imageView.contentMode  = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        
        //self.tabBarController?.delegate = self
        
        let profileViewTap = UITapGestureRecognizer(target: self, action: #selector(self.profileViewTapped(_:)))
        profileView.addGestureRecognizer(profileViewTap)
        

        
        self.collViewProfileVids.delegate = self
        
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        profileTbl.refreshControl = refreshControl
    }
    func assignValuesToLabels(){
        if UserInfo.shared.userId == nil {
            UserInfo.shared.userId = "NA"
        }
        
        if UserInfo.shared.firstName == nil {
            UserInfo.shared.firstName = "NA"
        }
        if UserInfo.shared.lastName == nil {
            UserInfo.shared.lastName = "NA"
        }
        if UserInfo.shared.stageName == nil {
            UserInfo.shared.stageName = "NA"
        }
        if UserInfo.shared.gender == nil {
            UserInfo.shared.gender = "NA"
        }
        if UserInfo.shared.dob == nil {
            UserInfo.shared.dob = Date()
        }
        if UserInfo.shared.ethnicity == nil {
            UserInfo.shared.ethnicity = "NA"
        }
        if UserInfo.shared.musicGenre == nil {
            UserInfo.shared.musicGenre = "NA"
        }
        print(UserInfo.shared.timeInMusic)
        if UserInfo.shared.timeInMusic == nil {
            UserInfo.shared.timeInMusic = "NA"
        }
        if UserInfo.shared.musicIndustry == nil {
            UserInfo.shared.musicIndustry = "NA"
        }
        if UserInfo.shared.location == nil {
            UserInfo.shared.location = "NA"
        }
        if (UserInfo.shared.stageName?.elementsEqual("NA"))!{
            displayNameLbl.text =  ""
        }else{
            displayNameLbl.text = UserInfo.shared.stageName ?? ""
        }
        
        if (UserInfo.shared.email?.elementsEqual("NA"))!{
            infoLbl.text = "Email : \("")"
        }else{
            infoLbl.text = "Email : "+(UserInfo.shared.email ?? "")
        }
        
        if (UserInfo.shared.gender?.elementsEqual("NA"))!{
            genderLbl.text = "Gender : "+("")
        }else{
            genderLbl.text = "Gender : "+(UserInfo.shared.gender ?? "")
        }
        
        if UserInfo.shared.dob != nil {
            dobLbl.text = "Birth Date : "+convertDateToStr(date: UserInfo.shared.dob!)
        } else {
            dobLbl.text = "Birth Date : "
        }
        
        if (UserInfo.shared.ethnicity?.elementsEqual("NA"))!{
            ethnicityLbl.text = "Ethnicity : "+("")
        }else{
            ethnicityLbl.text = "Ethnicity : "+(UserInfo.shared.ethnicity ?? "")
        }
        
        if (UserInfo.shared.musicGenre?.elementsEqual("NA"))!{
            genreLbl.text = "Genre : "+("")
        }else{
            genreLbl.text = "Genre : "+(UserInfo.shared.musicGenre ?? "")
        }
         
        if (UserInfo.shared.location?.elementsEqual("NA"))!{
            musicLbl.text = "Location : "+("")
        }else{
            musicLbl.text = "Location : "+(UserInfo.shared.location ?? "")
        }
        print(UserInfo.shared.timeInMusic)
        if (UserInfo.shared.timeInMusic?.elementsEqual("NA"))!{
            musicTimeLbl.text = "Music Duration : "+("")
        }else{
            musicTimeLbl.text = "Music Duration : "+(UserInfo.shared.timeInMusic ?? "")
        }
        
        if (UserInfo.shared.musicIndustry?.elementsEqual("NA"))!{
            self.lblMusicIndustry.text = "Music Industry : \("")"
        }else{
            self.lblMusicIndustry.text = "Music Industry : \(UserInfo.shared.musicIndustry ?? "")"
        }
        print(UserInfo.shared.stageName)
        if (UserInfo.shared.stageName?.elementsEqual("NA"))!{
            stageLbl.text = "Stage: \("")"
        }else{
            stageLbl.text = "Stage: \(UserInfo.shared.stageName ?? "")"
        }
               
               
        
               
               
                guard let coverPic=UserInfo.shared.coverPhotoUrl else{return}
                coverPhoto.contentMode = .scaleAspectFit
                coverPhoto.downloaded(from: coverPic)
                coverPhoto.contentMode = .scaleAspectFit

                profilePic.layer.cornerRadius = 40
                profilePic.layer.borderWidth = 1
                profilePic.layer.masksToBounds = false
                profilePic.layer.borderColor = UIColor.black.cgColor
                profilePic.clipsToBounds = true
        //        profilePic.image = UIImage(named: "dummy_black")
                profilePic.downloaded(from: UserInfo.shared.dpUrl!)
                
                profileView.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        startLoader()
        getData(genre: "")
        
        self.assignValuesToLabels()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.profileTbl.reloadData()
            self.collViewProfileVids.reloadData()
        })
        
    }
    
    func convertDateToStr(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    
    
    
    @IBAction func settingBtnAction(_ sender: Any) {
        
        
        let share = ["Settings"]
        actionSheet.sheetPopUp(controller: self, options: share, sheetTitle: "") { (response) in
            print("response : ", response)
            
            switch (response) {
            case "Settings":
                print("Setting Pressed")
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let settingvc = mainStoryBoard.instantiateViewController(withIdentifier: "settingVC") as! settingVC
                self.navigationController?.pushViewController(settingvc, animated: true)
                
            case "Ok":
                print("Delete Pressed")
                
            default:
                print("Nothing")
            
            }
        }
        
      
        
        

//        self.performSegue(withIdentifier: "profileVCToSetting", sender: nil)

    }
    @IBAction func editBtnAction(_ sender: Any) {
        
//        performSegue(withIdentifier: "ProfileToSignUp", sender: nil) n    n
        performSegue(withIdentifier: "profileVCToSetting", sender: nil)
    }
    @IBAction func logoutBtnAction(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "userId")
          UserDefaults.standard.set(nil, forKey: "email")
          UserDefaults.standard.set(nil, forKey: "password")
          
          let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
          let starterVC = mainStoryBoard.instantiateViewController(withIdentifier: "StarterVC") as! StarterScreen

          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.window?.rootViewController = starterVC
    }
    
    @objc func pullToRefresh(sender: UIRefreshControl) {
            isRefeshingTable = true
            getData(genre: "")
    //        sender.endRefreshing()
    //
    //        followingTbl.reloadData()
        }
    
    @objc func profileViewTapped(_ sender: UITapGestureRecognizer) {
        sender.view?.isHidden = true
        self.profileHeightConst.constant = 0.0
        
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
        
//        displayNameLbl.text = videoArr[btn.tag].artistName
//        infoLbl.text = ""//videoArr[btn.tag].
//        genderLbl.text = videoArr[btn.tag].genre
//        coverPhoto.image=UIImage(named: "")
//        let dp = videoArr[btn.tag].profilePicUrl!.replacingOccurrences(of: "\"", with: "") //else{return}
//        profilePic.downloaded(from: dp)
        
        profileView.isHidden = false
    }
    
    
    
    @IBAction func menuBtnClicked(_ sender: Any) {
            let buttonPosition = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.profileTbl)
            
            if let indexPath = profileTbl.indexPathForRow(at: buttonPosition) {
                let rowIndex =  indexPath.row
                print(rowIndex)
                
                
                
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
        }
    
    
    func deleteVideo(videoId : String) {
        //        startLoader()
        let videoService = VideoService()
        let param=["videoid":videoId]
        videoService.deleteVideoData(params: param) { (success) in
            if success{
                
                self.getData(genre: "")
                //self.profileTbl.reloadData()
            }
            else{
                alert(msg: "Video not Deleted", controller: self)
            }
        }
    }
    
    
    func getData(genre : String) {
        //        startLoader()
        let videoService = VideoService()
        videoService.getMyVideosData(genre: genre) { (success, response) in
            if success == true {
                self.masterVideoArr = response
                self.videoArr = response
                
                DispatchQueue.main.async {
                    if self.isRefeshingTable == true {
                        self.refreshControl.endRefreshing()
                    }
                    self.profileTbl.reloadData()
                    self.collViewProfileVids.reloadData()
                    self.stopLoader()
                }
                    
//                DispatchQueue.main.async {
//                    let artistService = ArtistService()
//                    artistService.getFollowedUsers { (success, followUsers) in
//                        print(followUsers)
//                        if success == true {
//                            for video in 0 ..< self.masterVideoArr.count {
//                                for user in followUsers {
//                                    if self.masterVideoArr[video].loginID! == user {
//                                        self.masterVideoArr[video].isFollowing = true
//                                        self.videoArr = self.masterVideoArr
//
//                                    }
//                                }
//
//                            }
//
////                            artistService.getBlockedUsers(completion: { (success, blockedUsers) in
////                                if success == true {
////                                    for video in 0 ..< self.masterVideoArr.count {
////                                        for user in blockedUsers {
////                                            if self.masterVideoArr[video].loginID! == user {
////                                                self.masterVideoArr[video].isBlocked = true
////                                                self.videoArr = self.masterVideoArr
////                                            }
////                                        }
////
////                                    }
////                                }
////                            })
//
//                            DispatchQueue.main.async {
//                                if self.isRefeshingTable == true {
//                                    self.refreshControl.endRefreshing()
//                                }
//                                self.profileTbl.reloadData()
//                                self.stopLoader()
//
//
//                            }
//
//                        } else {
//                            DispatchQueue.main.async {
//                                self.stopLoader()
//                            }
//                        }
//
//                    }
//
//                }
            } else {
                DispatchQueue.main.async {
                    self.stopLoader()
                }
            }
        }
    }
    

//    @IBAction func logoutBtnAction(_ sender: UIButton) {
////        UserDefaults.standard.string(forKey: "userId") != nil && UserDefaults.standard.string(forKey: "email") != nil && UserDefaults.standard.string(forKey: "password") != nil
//
//        UserDefaults.standard.set(nil, forKey: "userId")
//        UserDefaults.standard.set(nil, forKey: "email")
//        UserDefaults.standard.set(nil, forKey: "password")
//
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let starterVC = mainStoryBoard.instantiateViewController(withIdentifier: "StarterVC") as! StarterScreen
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = starterVC
//    }
    
    func startLoader() {
        self.view.isUserInteractionEnabled = false
        loadingIndicator.frame = CGRect(x: (self.view.frame.width / 2) - 50, y: (self.view.frame.height / 2) + 50, width: 25, height: 50)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileToSignUp" {
            let signUpVC = segue.destination as? SignUp
            signUpVC?.isEditProfile = true
        }
    }
}
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(videoArr.count)
        return videoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollCell", for: indexPath) as! profileCollCell
        var videoUrl = videoArr[indexPath.item].videoUrl?.replacingOccurrences(of: "\"", with: "")
                
                if videoUrl == nil {
                    videoUrl = "http://www.waqarulhaq.com/onboard-app/videos/sample.mp4"
                }
                
                if let videoUrl1 = URL(string: videoUrl!){
                    print("cell : ", indexPath.row)
                    print(videoUrl1)
                    let player = AVPlayer(url: videoUrl1)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = cell.videoView.bounds
                    cell.videoView.layer.addSublayer(playerLayer)
                    player.volume = 0
                    player.play()
                    
        //                avPlayerArr.append(player)
                    
                    playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoURL = URL(string: (videoArr[indexPath.item].videoUrl?.replacingOccurrences(of: "\"", with: ""))!)
              let player = AVPlayer(url: videoURL!)
              let playerViewController = AVPlayerViewController()
              playerViewController.player = player
              self.present(playerViewController, animated: true) {
                  playerViewController.player!.play()
              }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 0.0, left: 100.0, bottom: 0.0, right: 0.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource, AVPlayerViewControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return videoArr.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        cell.btnVideo.tag=indexPath.row
        cell.btnVideo.addTarget(self, action: #selector(self.btnVideoTapped(btn:)), for: UIControl.Event.touchUpInside)
        
        cell.btnOpenProfile.tag=indexPath.row
        cell.btnOpenProfile.addTarget(self, action: #selector(self.btnOpenProfileTapped(btn:)), for: UIControl.Event.touchUpInside)
        
        
        print("Cell Called")
        print("isFollowing : ", videoArr[indexPath.row].isFollowing)
        cell.displayPicture.image = UIImage(named: "dummy_black")
        if let dpp=videoArr[indexPath.row].profilePicUrl
        {
            let dp = videoArr[indexPath.row].profilePicUrl!.replacingOccurrences(of: "\"", with: "")
            print("display pic url before : ", videoArr[indexPath.row].profilePicUrl!)
            cell.displayPicture.downloaded(from: dp)
            
//            cell.displayPicture.sd_setImage(with: URL(string: dp), placeholderImage: UIImage(named: "default"))
        }
        
//        cell.displayPicture.sd_setImage(with: URL(string: videoArr[indexPath.row].profilePicUrl!), placeholderImage: UIImage(named: "default"))
    
        //print("dp : ", dp)
//        if let proPic=videoArr[indexPath.row].profilePicUrl
//        {
//            print("display pic url after : ", videoArr[indexPath.row].profilePicUrl!.replacingOccurrences(of: "\"", with: ""))
//
//        }
        cell.displayName.text = videoArr[indexPath.row].stageName
        cell.title.text = videoArr[indexPath.row].songTitle
        var videoUrl = videoArr[indexPath.row].videoUrl?.replacingOccurrences(of: "\"", with: "")
        
        if videoUrl == nil {
            videoUrl = "http://www.waqarulhaq.com/onboard-app/videos/sample.mp4"
        }
        
        if let videoUrl1 = URL(string: videoUrl!){
            print("cell : ", indexPath.row)
            print(videoUrl1)
            let player = AVPlayer(url: videoUrl1)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = cell.videoView.bounds
            cell.videoView.layer.addSublayer(playerLayer)
            player.volume = 0
            player.play()
            
//                avPlayerArr.append(player)
            
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
        
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 20.0
        if tableView == profileTbl {
            cellHeight = 380
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect")
        
    }

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
