//
//  ProfileTableViewCell.swift
//  VideoChatApp
//
//  Created by Apple on 20/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnOpenProfile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
