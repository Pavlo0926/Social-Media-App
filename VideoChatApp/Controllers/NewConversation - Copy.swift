//
//  NewConversation.swift
//  VideoChatApp
//
//  Created by Appic  on 22/06/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class NewConversation: UIViewController {

    @IBOutlet weak var userTbl: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var loadingIndicator = UIActivityIndicatorView()
    
    var allUsers = [UserModel]()
    var allUsersMaster = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTbl.delegate = self
        userTbl.dataSource = self
        searchTF.delegate = self
        
        getAllUsers()
    }
    
    func getAllUsers() {
        startLoader()
        let artistService = ArtistService()
        artistService.getAllUsers { (success, users) in
            if success == true {
                self.allUsers = users
                self.allUsersMaster = users
                DispatchQueue.main.async {
                    self.userTbl.reloadData()
                    self.stopLoader()
                }
            }
        }
    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

    @IBAction func textFieldOnChange(_ sender: UITextField) {
        if sender.text == "" {
            allUsers = allUsersMaster
        } else {
            let filteredArr = allUsersMaster.filter { (user) -> Bool in
                return (user.firstName?.lowercased().contains(searchTF.text!.lowercased()))!
            }
            allUsers = filteredArr
        }
        
        userTbl.reloadData()
    }
}

extension NewConversation: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewConversationCell", for: indexPath) as! NewConversationCell
        cell.profileImg.image = UIImage(named: "dummy_black")
        cell.nameLbl.text = allUsers[indexPath.row].stageName
        
        if allUsers[indexPath.row].dpUrl != nil {
            let dpUrl = allUsers[indexPath.row].dpUrl
            
            cell.profileImg.sd_setImage(with: URL.init(string: (dpUrl)!)) { (image, error, cache, urls) in
                        if (error != nil) {
                            cell.profileImg.image = UIImage(named: "dp")
                        } else {
                            cell.profileImg.image = image
                        }
            }
            
//            cell.profileImg.downloaded(from: allUsers[indexPath.row].dpUrl!)
        } else {
            cell.profileImg.image = UIImage(named: "dp")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Messages") as? Messages
            vc!.emailTo = self.allUsers[indexPath.row].email
            vc!.fcmTo = self.allUsers[indexPath.row].fcm
            vc!.deviceTokenForVideoCall = self.allUsers[indexPath.row].deviceToken!
            vc!.toUser = self.allUsers[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 82
        }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        let filteredArr = allUsersMaster.filter { (user) -> Bool in
//            return (user.firstName?.lowercased().contains(searchTF.text!.lowercased()))!
//        }
//        print(filteredArr)
//        allUsers = filteredArr
//        userTbl.reloadData()
//        return true
//    }
    
    
}
