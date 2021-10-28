//
//  ChatMessageCell.swift
//  VideoChatApp
//
//  Created by Apple on 01/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    var msgLeadingConstraint: NSLayoutConstraint!
    var msgTrailingConstraint: NSLayoutConstraint!
    
    var imgMainViewLeadingConstraint: NSLayoutConstraint!
    var imgMainViewTrailingConstraint: NSLayoutConstraint!
    
    let msgView = UIView()
    let msgLbl = UILabel()
    let imgMainView = UIView()
    let imgView = UIImageView()
    
    let messageObj = ChatModel()
    var messageType : String?
    var chatMessage : ChatModel! {
        didSet {
            
            msgView.backgroundColor = chatMessage.incoming ? UIColor(rgb: 0xCCCCCC) : UIColor(rgb: 0x31BC94)
            msgLbl.text = chatMessage.msg
            imgView.downloaded(from: chatMessage.msg!)
            
            if chatMessage.incoming == true {
                msgLeadingConstraint.isActive = true
                msgTrailingConstraint.isActive = false
                
//                imgMainViewLeadingConstraint.isActive = true
//                imgMainViewTrailingConstraint.isActive = false
            } else {
                msgLeadingConstraint.isActive = false
                msgTrailingConstraint.isActive = true
                
//                imgMainViewLeadingConstraint.isActive = false
//                imgMainViewTrailingConstraint.isActive = true
            }
            
            print("msgType : ", chatMessage.msgType)
            if chatMessage.msgType == "Image" {
                msgView.removeFromSuperview()
                msgLbl.removeFromSuperview()
            } else {
                imgMainView.removeFromSuperview()
                
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(msgView)
        
        imgMainView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imgMainView.backgroundColor = UIColor.black
        addSubview(imgMainView)
        
//        imgMainView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        imgMainView.backgroundColor = UIColor.black
//        imgView.image = UIImage(named: "camera-icon")
        msgView.backgroundColor = UIColor.yellow
        msgView.layer.cornerRadius = 8
        addSubview(msgLbl)
        msgLbl.text = "You need to text your customers, but you aren't sure of what to say."
        msgLbl.font = UIFont(name: "Avenir Next", size: 18)
//        msgLbl.backgroundColor = UIColor.green
        msgLbl.numberOfLines = 0
        
//        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
//        imgView.image = UIImage(named: "camera-icon")
//        msgView.addSubview(imgView)
        // Constraints
        msgView.translatesAutoresizingMaskIntoConstraints = false
        msgLbl.translatesAutoresizingMaskIntoConstraints = false
        imgMainView.translatesAutoresizingMaskIntoConstraints = false
//        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            msgLbl.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(32)),
//            msgLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(32)),
            msgLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            msgLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(-32)),
                                       
            msgView.topAnchor.constraint(equalTo: msgLbl.topAnchor, constant: CGFloat(-16)),
            msgView.leadingAnchor.constraint(equalTo: msgLbl.leadingAnchor, constant: CGFloat(-16)),
            msgView.trailingAnchor.constraint(equalTo: msgLbl.trailingAnchor, constant: CGFloat(16)),
            msgView.bottomAnchor.constraint(equalTo: msgLbl.bottomAnchor, constant: CGFloat(16)),
            
//            imgView.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(0)),
////            imgView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
//            imgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(0)),
//
            imgMainView.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(-16)),
            imgMainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(-16)),
            imgMainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(16)),
            imgMainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(16))
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        msgLeadingConstraint = msgLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(32))
        msgLeadingConstraint.isActive = false
        
        msgTrailingConstraint = msgLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(-32))
        msgLeadingConstraint.isActive = true
        
//        imgMainViewLeadingConstraint = imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(32))
//        imgMainViewLeadingConstraint.isActive = false
//
//        imgMainViewTrailingConstraint = imgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(-32))
//        imgMainViewLeadingConstraint.isActive = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
