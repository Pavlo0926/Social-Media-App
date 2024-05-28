//
//  ChatlistCell.swift
//  VideoChatApp
//
//  Created by Appic  on 28/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ChatlistCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var msgCounterLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImg.layer.cornerRadius = 27
        profileImg.layer.borderWidth = 1
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor.black.cgColor
        profileImg.clipsToBounds = true
        
        msgCounterLbl.layer.cornerRadius = 12.5
        msgCounterLbl.layer.masksToBounds = false
        msgCounterLbl.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
