//
//  ChatImageCell.swift
//  VideoChatApp
//
//  Created by Appic  on 09/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ChatImageCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    var imgLeadingAnchor : NSLayoutConstraint!
    var imgTrailingAnchor : NSLayoutConstraint!
    let mainView = UIView()
    let img = UIImageView()
    @IBOutlet weak var outerView: UIView!
    var chatObj : ChatModel! {
        didSet {
            if ((chatObj.msg?.contains(".MOV")))! {
                if let videoUrl1 = URL(string: chatObj.msg!){
                    let player = AVPlayer(url: videoUrl1)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = img.bounds
                    img.layer.addSublayer(playerLayer)
                    player.play()
                }
            } else {
                img.downloaded(from: chatObj.msg!)
            }
            
            if chatObj.incoming == true {
                imgLeadingAnchor.isActive = true
                imgTrailingAnchor.isActive = false
            } else {
               imgLeadingAnchor.isActive = false
               imgTrailingAnchor.isActive = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(mainView)
        mainView.addSubview(img)
//        mainView.backgroundColor = UIColor.blue
//        img.backgroundColor = UIColor.orange
        img.image = UIImage(named: "dummy_black")
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = false
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        
//        outerView.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(10)).isActive = true
        mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(10)).isActive = true
        mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(-10)).isActive = true
        mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(-10)).isActive = true
        
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.topAnchor.constraint(equalTo: mainView.topAnchor, constant: CGFloat(10)).isActive = true
        img.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: CGFloat(-10)).isActive = true
        img.widthAnchor.constraint(equalToConstant: 200).isActive = true
        

        imgLeadingAnchor = img.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: CGFloat(10))
        imgLeadingAnchor.isActive = false
        imgTrailingAnchor = img.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: CGFloat(-10))
        imgTrailingAnchor.isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
