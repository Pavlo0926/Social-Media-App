//
//  ChatList.swift
//  VideoChatApp
//
//  Created by Appic  on 28/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatList: UIViewController {
    
    @IBOutlet weak var chatlistTbl: UITableView!
    
    var loadingIndicator = UIActivityIndicatorView()
    
    var ref: DatabaseReference!
    var chatlistArr = [String]()
    var chatlistUser = [UserModel]()
    let artistService = ArtistService()
    var currentUser = UserInfo.shared.email
    var otherEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatlistTbl.delegate = self
        chatlistTbl.dataSource = self
        
        UserDefaults.standard.set(0, forKey: "message_count")
        NotificationCenter.default.post(name: .messageCounter, object: nil)
        
        self.navigationItem.title = "Messages"
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(userMessageCounter(notification:)), name: .userMessageCounter, object: nil)
        self.chatlistTbl.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(0, forKey: "message_count")
        NotificationCenter.default.post(name: .messageCounter, object: nil)
        ref = Database.database().reference()
        fetchChatlistFirebase()
    }
    
    @objc func userMessageCounter(notification : Notification) {
        msgUpdater()
    }
    
    func msgUpdater() {
        var newArray = [UserModel]()
        var removedUser = UserModel()
        if chatlistUser.count > 0 {
            for user in chatlistUser {
                if user.userId != nil {
                    let userMsgCountKey = "msg_count_"+user.userId!
                    if UserDefaults.standard.integer(forKey: userMsgCountKey) != nil {
                        let msgCount = UserDefaults.standard.integer(forKey: userMsgCountKey)
                        user.msgCount = msgCount
                    }
                    
                    if UserDefaults.standard.string(forKey: "last_msg_user") != nil {
                        let lastMsgUser = UserDefaults.standard.string(forKey: "last_msg_user")
                        
                        if user.userId == lastMsgUser {
                            removedUser = user
                        } else {
                            newArray.append(user)
                        }
                    } else {
                       newArray.append(user)
                    }
                }
                
            }
            if removedUser.firstName != nil {
                newArray.insert(removedUser, at: 0)
            }
            
        }
        
        chatlistUser = newArray
        chatlistTbl.reloadData()
    }
    
    func getOtherEmail(chatRoomName : String) {
        let arr = chatRoomName.components(separatedBy: "-")
        if arr[0] == changeEmailFormat(email: currentUser!) {
            otherEmail = arr[1]
        } else {
            otherEmail = arr[0]
        }
    }
    
    func fetchChatlistFirebase () {
        startLoader()
        ref.child("chat").observeSingleEvent(of: .value) { (snapshot) in
            let loggedInEmail = self.changeEmailFormat(email: self.currentUser!)
            self.chatlistArr = []
            for child in snapshot.children {
                let value = child as! DataSnapshot
                let key = value.key
                self.getOtherEmail(chatRoomName: key)
                if key.contains(loggedInEmail) {
                    self.chatlistArr.append(self.otherEmail)
                }
            }
            
            self.artistService.getAllUsers { (success, response) in
                print(response)
                
                self.chatlistUser = self.getUsername(allUsers: response)
                
                DispatchQueue.main.async {
                    self.msgUpdater()
                    self.chatlistTbl.reloadData()
                    self.stopLoader()
                }
                
            }
            
        }
    }
    
    func getUsername(allUsers : [UserModel]) -> [UserModel] {
        chatlistUser = []
        for chatlist in chatlistArr {
            for user in allUsers {
                let email = changeEmailFormat(email: user.email!)
                
                if chatlist.contains(email) {
                    let userMsgCountKey = "msg_count_"+user.userId!
                    if UserDefaults.standard.integer(forKey: userMsgCountKey) != nil {
                        var msgCount = UserDefaults.standard.integer(forKey: userMsgCountKey)
                        user.msgCount = msgCount
                    }
                    chatlistUser.append(user)
                }
            }
        }
        return chatlistUser
    }
    
    func changeEmailFormat(email : String) -> String {
        var emailLocal = email
        emailLocal = emailLocal.replacingOccurrences(of: "@", with: "_")
        emailLocal = emailLocal.replacingOccurrences(of: ".", with: "_")
        
        return emailLocal
    }
    
    @IBAction func addNewBtnAction(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewConversation") as? NewConversation
        self.navigationController?.pushViewController(vc!, animated: true)
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

}

extension ChatList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatlistUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ChatlistCell", for: indexPath) as! ChatlistCell
        cell.nameLbl.text = chatlistUser[indexPath.row].stageName
        if chatlistUser[indexPath.row].dpUrl != nil {
            cell.profileImg.downloaded(from: chatlistUser[indexPath.row].dpUrl!)
        } else {
            cell.profileImg.image = UIImage(named: "dp")
        }
        
        cell.msgCounterLbl.text = String(chatlistUser[indexPath.row].msgCount)
        
        if chatlistUser[indexPath.row].msgCount > 0 {
            cell.msgCounterLbl.isHidden = false
        } else {
            cell.msgCounterLbl.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Messages") as? Messages
        vc!.emailTo = self.chatlistUser[indexPath.row].email
        vc!.fcmTo = self.chatlistUser[indexPath.row].fcm
        print(self.chatlistUser[indexPath.row].deviceToken!)
        vc!.deviceTokenForVideoCall = self.chatlistUser[indexPath.row].deviceToken!
        vc!.toUser = self.chatlistUser[indexPath.row]
//        self.tabBarController?.selectedIndex = 3
        self.navigationController?.pushViewController(vc!, animated: true)
//        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
}
