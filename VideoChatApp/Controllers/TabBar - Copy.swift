//
//  TabBar.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class TabBar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let msgCount = UserDefaults.standard.integer(forKey: "message_count")
        if msgCount != nil && msgCount > 0 {
            self.tabBarController?.delegate = self
            self.tabBar.items![3].badgeValue = String(msgCount)
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageCounter(notification:)), name: .messageCounter, object: nil)
        
    }
    
    @objc func messageCounter(notification: Notification){
        self.tabBarController?.delegate = self
        let msgCount = UserDefaults.standard.integer(forKey: "message_count")
        if msgCount != nil && msgCount > 0 {
            
            self.tabBar.items![3].badgeValue = String(msgCount)
            
        } else {
            self.tabBar.items![3].badgeValue  = nil
        }
    }

}

