//
//  SearchViewController.swift
//  VideoChatApp
//
//  Created by Apple on 19/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreenVC = storyboard.instantiateViewController(withIdentifier: "HomeScreenVC") as! HomeScreen
        
        self.addChild(homeScreenVC)
        homeScreenVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(homeScreenVC.view)
        homeScreenVC.transparentView.isHidden = false
        homeScreenVC.tblBackView.isHidden = false
        homeScreenVC.isHomeVCC=false
        homeScreenVC.didMove(toParent: self)
        
    }
    
}
