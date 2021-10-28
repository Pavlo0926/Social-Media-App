//
//  ChatMessageCellTableViewCell.swift
//  VideoChatApp
//
//  Created by Apple on 01/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ChatMessageCellTableViewCell: UITableViewCell {
    
    let msgLbl = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(msgLbl)
        msgLbl.text = "You need to text your customers, but you aren't sure of what to say."
        msgLbl.backgroundColor = UIColor.green
        msgLbl.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
