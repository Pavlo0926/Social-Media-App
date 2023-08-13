//
//  Stagename.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class Stagename: UIViewController {

    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    @IBOutlet weak var stageTxtFiled: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        getData()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        if AuthenticationService.shared.boolOpenPageViewBySetting{
            self.btnContinue.setTitle("Update", for: .normal)
            self.btnSkip.isHidden = false
            self.btnBack.isHidden = true
        }else{
            self.btnContinue.setTitle("Continue", for: .normal)
            self.btnSkip.isHidden = true
            self.btnBack.isHidden = false
            self.navigationHeightCons.constant = 0.0
            self.pageCountTopCons.constant = 50.0
        }
    }
    
    func setData() {
        if stageTxtFiled.text != "" {
            UserInfo.shared.stageName = stageTxtFiled.text
        }
        
    }
    
    func getData() {
        
        if UserInfo.shared.stageName != nil {
            stageTxtFiled.text = UserInfo.shared.stageName
        }
    }

    @IBAction func continueBtnClicked(_ sender: Any) {
        UserInfo.shared.stageName = stageTxtFiled.text
        
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[3]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[1]], direction: .reverse, animated: true, completion: nil)
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[3]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func backTOSettingBtn(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
        
    }
}
