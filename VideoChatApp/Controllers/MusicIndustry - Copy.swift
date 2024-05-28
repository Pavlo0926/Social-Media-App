//
//  MusicIndustry.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MusicIndustry: UIViewController {
    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    var loadingIndicator = UIActivityIndicatorView()

    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserInfo.shared.lastName != nil {
            txtView.text = UserInfo.shared.musicIndustry
        }
        if AuthenticationService.shared.boolOpenPageViewBySetting{
            self.btnContinue.setTitle("Update", for: .normal)
            self.btnSkip.isHidden = false
            self.btnBack.isHidden = true
        }else{
            self.navigationHeightCons.constant = 0.0
            self.pageCountTopCons.constant = 50.0
            self.btnContinue.setTitle("Continue", for: .normal)
            self.btnSkip.isHidden = true
            self.btnBack.isHidden = false
        }
    }
    @IBAction func continueBtnClicked(_ sender: Any) {
//        startLoader()
        UserInfo.shared.musicIndustry = txtView.text
        
//        let params : [String : String] = ["" : ""]
//
//        let artistService = ArtistService()
//        artistService.uploadUserData(params: params) { (success, response) in
//            if success == true {
//                DispatchQueue.main.async {
//                    self.stopLoader()
//
//                    let parentVC = self.parent as! PageViewController
//                    parentVC.setViewControllers([Constants.shared.viewControllerArr[10]], direction: .forward, animated: true, completion: nil)
//                }
//            }
//        }
        
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[10]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[8]], direction: .reverse, animated: true, completion: nil)
    }
    
    func startLoader() {
        self.view.isUserInteractionEnabled = false
        loadingIndicator.frame = CGRect(x: (self.view.frame.width / 2) - 50, y: (self.view.frame.height / 2) - 25, width: 25, height: 50)
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        self.view.addSubview(loadingIndicator)
    }
    
    func stopLoader() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
    @IBAction func skipBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
               parentVC.setViewControllers([Constants.shared.viewControllerArr[10]], direction: .forward, animated: true, completion: nil)
    }
    @IBAction func backTOSettingBtn(_ sender: Any) {
      
           self.dismiss(animated: true, completion: nil)
       }
}
