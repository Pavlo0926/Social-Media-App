//
//  BirthDate.swift
//  VideoChatApp
//
//  Created by Apple on 01/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class BirthDate: UIViewController {

    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
//        datePicker.setValue(false, forKey: "highlightsToday")
        
     
        
    }
    override func viewWillAppear(_ animated: Bool) {
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
    
    func getData() {
        if UserInfo.shared.dob != nil {
            datePicker.date = UserInfo.shared.dob!
            let age = calcAge(birthday: datePicker.date.toString(dateFormat: "MM/dd/yyyy"))
            ageLbl.text = "Age : "+String(age)
        }
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[5]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        let age = calcAge(birthday: datePicker.date.toString(dateFormat: "MM/dd/yyyy"))
        UserInfo.shared.dob = datePicker.date
        print(datePicker.date)
        print(UserInfo.shared.dob)
        ageLbl.text = "Age : "+String(age)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        let parentVC = self.parent as! PageViewController
    parentVC.setViewControllers([Constants.shared.viewControllerArr[3]], direction: .reverse, animated: true, completion: nil)
        
    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[5]], direction: .forward, animated: true, completion: nil)
        print("skip button cliked in birtd date")
    }
    @IBAction func backTOSettingBtn(_ sender: Any) {
      
           self.dismiss(animated: true, completion: nil)
       }
}
