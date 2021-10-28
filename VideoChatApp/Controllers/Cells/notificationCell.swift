//
//  notificationCell.swift
//  VideoChatApp
//
//  Created by Appic Devices on 08/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class notificationCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var switchView: UISwitch!
//    @IBOutlet weak var switchView: u
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
