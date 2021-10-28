//
//  HomeFollowCell.swift
//  VideoChatApp
//
//  Created by Apple on 30/04/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import WebKit

class HomeFollowCell: UITableViewCell, AVPlayerViewControllerDelegate {

    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var title: UILabel!
//    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var btnVideo: UIButton!
    
    @IBOutlet weak var btnOpenProfile: UIButton!
    //    var videoUrl : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        print(videoUrl)
//        print("Cell awakeFromNib")
//        makeVideoPlayer()
    }
    
    
}
