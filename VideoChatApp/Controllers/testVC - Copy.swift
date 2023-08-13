//
//  testVC.swift
//  VideoChatApp
//
//  Created by Appic Devices on 17/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class testVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[6]], direction: .forward, animated: true, completion: nil)
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[6]], direction: .forward, animated: true, completion: nil)
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[4]], direction: .forward, animated: true, completion: nil)
    }
    

}
