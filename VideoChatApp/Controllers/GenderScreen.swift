//
//  GenderScreen.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class GenderScreen: UIViewController {

    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var groupBtn: UIButton!
    
    @IBOutlet weak var maleOptionBtn: UIButton!
    @IBOutlet weak var femaleOptionBtn: UIButton!
    @IBOutlet weak var selfOptionBtm: UIButton!
    @IBOutlet weak var noneOptionBtn: UIButton!
    @IBOutlet weak var selfGenderTF: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var btnUnSelectBgColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnUnSelectBgColor = maleBtn.backgroundColor
        
        getData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if AuthenticationService.shared.boolOpenPageViewBySetting{
            self.btnContinue.setTitle("Update", for: .normal)
            self.btnSkip.isHidden = false
            self.btnBack.isHidden = true
        }else{
            self.navigationHeightCons.constant = 0.0
            self.pageCountTopCons.constant = 45.0
            self.btnContinue.setTitle("Continue", for: .normal)
            self.btnSkip.isHidden = true
            self.btnBack.isHidden = false
        }
    }
    func getData() {
        if UserInfo.shared.gender != nil {
            if UserInfo.shared.gender == "Male" {
                maleBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
            } else if UserInfo.shared.gender == "Female" {
                femaleBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
            }else {
                groupBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
            }
        }
        
        if UserInfo.shared.gender != nil {
            if UserInfo.shared.gender == "Male" {
                maleOptionBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
            } else if UserInfo.shared.gender == "Female" {
                femaleOptionBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
            }else if UserInfo.shared.gender == "None" {
                noneOptionBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
            } else {
                selfOptionBtm.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
                selfGenderTF.text = UserInfo.shared.gender
            }
        }
    }

    @IBAction func continueBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[4]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func maleBtnClicked(_ sender: UIButton) {
        maleBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
        femaleBtn.backgroundColor = btnUnSelectBgColor
        groupBtn.backgroundColor = btnUnSelectBgColor
        UserInfo.shared.gender = "Male"
    }

    @IBAction func femaleBtnClicked(_ sender: UIButton) {
        femaleBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
        maleBtn.backgroundColor = btnUnSelectBgColor
        groupBtn.backgroundColor = btnUnSelectBgColor
        
        UserInfo.shared.gender = "Female"
    }

    @IBAction func groupBtnClicked(_ sender: UIButton) {
        groupBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
        femaleBtn.backgroundColor = btnUnSelectBgColor
        maleBtn.backgroundColor = btnUnSelectBgColor
        
        UserInfo.shared.gender = "Group"
    }
    
    @IBAction func maleOptionBtnAction(_ sender: UIButton) {
        maleOptionBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
        femaleOptionBtn.backgroundColor = btnUnSelectBgColor
        selfOptionBtm.backgroundColor = btnUnSelectBgColor
        noneOptionBtn.backgroundColor = btnUnSelectBgColor
        
        UserInfo.shared.gender = "Male"
    }
    
    @IBAction func femaleOptionBtnAction(_ sender: UIButton) {
        maleOptionBtn.backgroundColor = btnUnSelectBgColor
        femaleOptionBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
        selfOptionBtm.backgroundColor = btnUnSelectBgColor
        noneOptionBtn.backgroundColor = btnUnSelectBgColor
        
        UserInfo.shared.gender = "Female"
    }
    
    @IBAction func selfOptionBtnAction(_ sender: UIButton) {
        maleOptionBtn.backgroundColor = btnUnSelectBgColor
        femaleOptionBtn.backgroundColor = btnUnSelectBgColor
        selfOptionBtm.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
        noneOptionBtn.backgroundColor = btnUnSelectBgColor
        
        UserInfo.shared.gender = selfGenderTF.text
    }
    
    @IBAction func noneOptionBtnAction(_ sender: UIButton) {
        maleOptionBtn.backgroundColor = btnUnSelectBgColor
        femaleOptionBtn.backgroundColor = btnUnSelectBgColor
        selfOptionBtm.backgroundColor = btnUnSelectBgColor
        noneOptionBtn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
        
        UserInfo.shared.gender = "None"
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[2]], direction: .reverse, animated: true, completion: nil)
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[4]], direction: .forward, animated: true, completion: nil)
    }
    @IBAction func backTOSettingBtn(_ sender: Any) {
      
           self.dismiss(animated: true, completion: nil)
       }
}
