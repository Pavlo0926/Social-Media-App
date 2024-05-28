//
//  settingVC.swift
//  VideoChatApp
//
//  Created by Appic Devices on 07/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class settingVC: UIViewController {

    
    @IBOutlet weak var tblSetting: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Settings"
        self.tblSetting.tableFooterView = UIView()
    }
    
    @IBAction func editAccountAction(_ sender: UIButton){
        self.performSegue(withIdentifier: "settingToEditAccount", sender: nil)
    }
    @IBAction func editProfileAction(_ sender: UIButton){
        DispatchQueue.main.async {
//        self.navigationController?.viewControllers = [self]
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let parentVC = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            
            if parentVC.children.count > 0{
                for viewContoller in parentVC.children{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
                
            }
        AuthenticationService.shared.boolOpenPageViewBySetting = true
//        self.performSegue(withIdentifier: "settingToPageVC", sender: nil)
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func notificationAction(_ sender: UIButton){
        
    }
    @IBAction func logoutAction(_ sender: UIButton){
        UserDefaults.standard.set(nil, forKey: "userId")
          UserDefaults.standard.set(nil, forKey: "email")
          UserDefaults.standard.set(nil, forKey: "password")
          
          let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
          let starterVC = mainStoryBoard.instantiateViewController(withIdentifier: "StarterVC") as! StarterScreen

          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.window?.rootViewController = starterVC

    }

}
extension settingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! notificationCell
        if indexPath.row == 0{
            cell.lblTitle.text = "Edit Profile"
            cell.imgIcon.image = UIImage.init(named: "editProfile")
            cell.switchView.isHidden = true
        }else if indexPath.row == 1{
            
            cell.lblTitle.text = "Edit Account"
            cell.imgIcon.image = UIImage.init(named: "editInfo")
            cell.switchView.isHidden = true
            
        }else if indexPath.row == 2{
            cell.lblTitle.text = "Notification"
            cell.imgIcon.image = UIImage.init(named: "notifications")
            cell.switchView.isHidden = false
            
        }else if indexPath.row == 3{
            cell.lblTitle.text = "Logout"
            cell.imgIcon.image = UIImage.init(named: "logout")
            cell.switchView.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            DispatchQueue.main.async {
                //        self.navigationController?.viewControllers = [self]
//                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let parentVC = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
                
//                if parentVC.children.count > 0 {
//                    for viewContoller in parentVC.children{
//                        viewContoller.willMove(toParent: nil)
//                        viewContoller.view.removeFromSuperview()
//                        viewContoller.removeFromParent()
//                    }
//
//                }
                AuthenticationService.shared.boolOpenPageViewBySetting = true
//                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                
//                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                let pageVC = mainStoryBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
//
//
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.window?.rootViewController = pageVC
                
                
//                        self.performSegue(withIdentifier: "settingToPageVC", sender: nil)
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
                self.navigationController?.present(vc, animated: true, completion: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.row == 1{
//            self.performSegue(withIdentifier: "settingToEditAccount", sender: nil)
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let editProfilevc = mainStoryBoard.instantiateViewController(withIdentifier: "editProfileVC") as! editProfileVC
            self.navigationController?.pushViewController(editProfilevc, animated: true)
            
        }else if indexPath.row == 2{
            
        }else if indexPath.row == 3{
            UserDefaults.standard.set(nil, forKey: "userId")
              UserDefaults.standard.set(nil, forKey: "email")
              UserDefaults.standard.set(nil, forKey: "password")
            
            UserInfo.shared.userId = nil
            UserInfo.shared.email = nil
            UserInfo.shared.password = nil
            UserInfo.shared.firstName = nil
            UserInfo.shared.lastName = nil
            UserInfo.shared.stageName = nil
            UserInfo.shared.gender = nil
            UserInfo.shared.dob = nil
            UserInfo.shared.location = nil
            UserInfo.shared.ethnicity = nil
            UserInfo.shared.musicGenre = nil
            UserInfo.shared.timeInMusic = nil
            UserInfo.shared.dpUrl = nil
            UserInfo.shared.coverPhotoUrl = nil
              
              let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
              let starterVC = mainStoryBoard.instantiateViewController(withIdentifier: "StarterVC") as! StarterScreen

              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              appDelegate.window?.rootViewController = starterVC
        }
    }
    
}
