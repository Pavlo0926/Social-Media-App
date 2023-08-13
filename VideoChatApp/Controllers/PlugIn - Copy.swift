//
//  PlugIn.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class PlugIn: UIViewController {
    
    @IBOutlet weak var gifImgView: UIImageView!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        autoreleasepool {
//            self.gifImgView.image = UIImage.gifImageWithName("plugin_gif")
//        }
        
        
    }
    
    @IBAction func pluginBtn(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[1]], direction: .forward, animated: true, completion: nil)
    }
}

