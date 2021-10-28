//
//  Birthname.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class Birthname: UIViewController {

    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    @IBOutlet weak var fnameTxtField: UITextField!
    @IBOutlet weak var lnameTxtField: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fnameTxtField.delegate = self
//        lnameTxtField.delegate = self
        
        getData()
        hideKeyboardWhenTappedAround()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        
           if AuthenticationService.shared.boolOpenPageViewBySetting{
                 self.btnContinue.setTitle("Update", for: .normal)
                 self.btnSkip.isHidden = false
            
             }else{
                 self.btnContinue.setTitle("Continue", for: .normal)
                 self.btnSkip.isHidden = true
            self.navigationHeightCons.constant = 0.0
            self.pageCountTopCons.constant = 50.0
                 
             }
    }
    
    func setData() {
        if fnameTxtField.text != "" || lnameTxtField.text != "" {
            UserInfo.shared.firstName = fnameTxtField.text
            UserInfo.shared.lastName = lnameTxtField.text
            
            UserDefaults.standard.set(UserInfo.shared.firstName, forKey: "fname")
        }
        
    }

    func getData() {
        print("firstName : ", UserInfo.shared.firstName)
        print("lastName : ", UserInfo.shared.lastName)
        
        if UserInfo.shared.firstName != nil {
            fnameTxtField.text = UserInfo.shared.firstName
        }
        
        if UserInfo.shared.lastName != nil {
            lnameTxtField.text = UserInfo.shared.lastName
        }
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        
        
        let parentVC = self.parent as! PageViewController
               parentVC.setViewControllers([Constants.shared.viewControllerArr[2]], direction: .forward, animated: true, completion: nil)
        

    }
    @IBAction func continueBtnClicked(_ sender: Any) {
        setData()
        
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[2]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func backTOSettingBtn(_ sender: Any) {
   
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
