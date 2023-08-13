//
//  Messages.swift
//  VideoChatApp
//
//  Created by Apple on 30/04/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase
import FirebaseStorage

class Messages: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var chatTbl: UITableView!
    @IBOutlet weak var sendMsgField: UITextField!
    @IBOutlet weak var textViewBottomCons: NSLayoutConstraint!
    
    var loadingIndicator = UIActivityIndicatorView()
    
    var chatArray = [ChatModel]()
    var emailTo : String? = nil
    var fcmTo : String? = nil
    var toUser : UserModel? = nil
    
    var ref: DatabaseReference!
    
    let currentEmail = UserInfo.shared.email
//    let currentEmail = "haroon@gmail.com"
    var chatRoom = String()
    
    var deviceTokenForVideoCall : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
        
        ref = Database.database().reference()
//        ["haris@gmail.com", "haroon@gmail.com"]
//        let chatRoomArr = ["haris@gmail.com", "haroon@gmail.com"]
        let chatRoomArr = [currentEmail, emailTo]
        chatRoom = getChatRoomName(chatRoomArr: chatRoomArr as! [String])
        
        fetchMsgFromFirebase(chatRoom: chatRoom)
        
        chatTbl.delegate = self
        chatTbl.dataSource = self
        
        chatTbl.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        chatTbl.estimatedRowHeight = UITableView.automaticDimension
        
        sendMsgField.delegate = self

//        setupViews()
        
        hideKeyboardWhenTappedAround()
        
        let userMsgCountKey = "msg_count_"+toUser!.userId!
        UserDefaults.standard.set(0, forKey: userMsgCountKey)
        NotificationCenter.default.post(name: .userMessageCounter, object: nil)
    }
    
    func loadViews() {
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "vidIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left:60, bottom: 12, right: 10)

//        button.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        button.addTarget(self, action: #selector(callBtnClicked), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        
        navigationItem.rightBarButtonItem = barButton
        
        navigationItem.title = toUser?.stageName

        
//        let callImg = UIImage(named: "hangup")?.withRenderingMode(.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: callImg, style: .plain, target: self, action: #selector(callBtnClicked))
    }
    
    @objc func callBtnClicked() {
        print("Video call button clicked")
        performSegue(withIdentifier: "MessagesToCallScreen", sender: deviceTokenForVideoCall)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessagesToCallScreen" {
            let destVC = segue.destination as! MainController
            print(sender as! String)
            destVC.deviceTokenForVideoCall = sender as! String
        }
    }
    
    func getChatRoomName(chatRoomArr : [String]) -> String {
        var chatRoomArr1 = chatRoomArr
        for cht in 0 ..< chatRoomArr1.count {
            chatRoomArr1[cht] = chatRoomArr1[cht].replacingOccurrences(of: "@", with: "_")
            chatRoomArr1[cht] = chatRoomArr1[cht].replacingOccurrences(of: ".", with: "_")
        }
        
        chatRoomArr1 = chatRoomArr1.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        print(chatRoomArr1)
        let chatRoom = chatRoomArr1.joined(separator: "-")
        return chatRoom
    }
    
//    func setupViews() {
////        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: navigationController, action: nil)
//    }
    
    @IBAction func sendMsgBtnAction(_ sender: UIButton) {
        if sendMsgField.text != "" {
//            sendMessage(token:"eDPQjLIz-khohv2P-VYEcG:APA91bEx5yCW_2cViRfK_R1C8-QLQnBO2HZ13CDCfuQE89KjNTcOMivZofgQlmZr2DtVptt4WgEbifESNqVPq0qqoe-8Ax8oLBXLXj8RJ4In1eaiS2JYxTcCPNeXTsXbdwn5puJKKPS6", title: "Message from user", body: sendMsgField.text!)
            
            sendMessage(token: fcmTo!, title: "Message from user", body: sendMsgField.text!, msgType: "text")
        }
        

    }
    
    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    func sendMessage(token : String, title : String, body : String, msgType : String) {
        let legacyServerKey = "AAAAtpsYuXw:APA91bHJSeBC2FbImlWW3ti_UU6Y-34tdAxriheBPSeXdiGOOP0LC0NFHE4TmsyB2V6Ox2sbB4bl8I16bYQl5LU9_R3IlYMPR1HV7ohahXqlpBI2MsP0S-Z_BJKseYWjIem5w_Fs9EbH"
        let headers = [
            "Authorization": "key=AAAAtpsYuXw:APA91bHJSeBC2FbImlWW3ti_UU6Y-34tdAxriheBPSeXdiGOOP0LC0NFHE4TmsyB2V6Ox2sbB4bl8I16bYQl5LU9_R3IlYMPR1HV7ohahXqlpBI2MsP0S-Z_BJKseYWjIem5w_Fs9EbH",
            "Content-Type": "application/json"
        ]
        
        let params : [String : Any] = ["to" : token,
                                       "notification" : ["title" : title, "body" : body],
                                       "data" : ["user" : UserInfo.shared.userId]]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                print(response)
//to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
//to get JSON return value
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
                print(JSON["success"])
                self.saveMessageToFirebase(chatRoom: self.chatRoom, message: body, emailFrom: self.currentEmail!, msgType: msgType)
            }
        }
    }
    
    func saveMessageToFirebase(chatRoom : String, message: String, emailFrom : String, msgType : String) {
        self.ref.child("chat").child(chatRoom).childByAutoId().setValue(["message" : message, "email" : emailFrom, "date" : Date().toString(dateFormat: "dd-MM-yyyy HH:mm:ss"), "ms_for_sorting" : getCurrentMillis(), "msgType" : msgType]){
            (error: Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not saved: \(error)")
            } else {
                print("Data saved Successfully")
                self.sendMsgField.text = ""
            }
        }
    }
    
    func fetchMsgFromFirebase (chatRoom : String) {
        ref.child("chat").child(chatRoom).queryOrdered(byChild: "ms_for_sorting").observe(.value) { (snapShot) in
            var chatData = [ChatModel]()
            if let data = snapShot.value as? NSDictionary {
                for eachSnap in data {
    //                print("key : ", eachSnap.key)
                    var chatModel = ChatModel()
                    guard let eachObjectDict = eachSnap.value as? NSDictionary else { return }
                    print(eachObjectDict)
                    let email = eachObjectDict["email"] as? String
                    let ms_for_sorting = eachObjectDict["ms_for_sorting"] as? Int
                    chatModel.msg = eachObjectDict["message"] as? String
                    chatModel.ms_for_sorting = ms_for_sorting ?? 0
                    chatModel.msgType = eachObjectDict["msgType"] as? String
                    if chatModel.msgType == nil {
                        chatModel.msgType = "text"
                    }
                    
                    if email == self.currentEmail {
                        chatModel.incoming = false
                    } else {
                        chatModel.incoming = true
                    }
                    
                    chatData.append(chatModel)
                }
            }
            chatData = chatData.sorted(by: { $0.ms_for_sorting < $1.ms_for_sorting })
            self.chatArray = chatData
            self.chatTbl.reloadData()
            if self.chatArray.count > 0 {
                self.scrollToBottom()
            }
            
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatArray.count-1, section: 0)
            self.chatTbl.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func imgAttachBtnAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController ()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie", "public.image"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
}

extension Messages: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
        
        if chatArray[indexPath.row].msgType == "text" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
            cell.chatMessage = chatArray[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageCell", for: indexPath) as! ChatImageCell
            cell.chatObj = chatArray[indexPath.row]
            return cell
        }
        
//        chatImageCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if chatArray[indexPath.row].msgType == "Image" {
//            return 300
//        }
        if chatArray[indexPath.row].msgType == "Image" {
            return 200
        }
        return UITableView.automaticDimension
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        startLoader()
        if let pickedImage = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            let data = NSData(contentsOf: pickedImage)
            
            
            uploadVideo(pickedImage: data as! Data, ext: "MOV") { (url) in
                print(url)
                DispatchQueue.main.async {
                    self.sendMessage(token: self.fcmTo!, title: "Message from user", body: url!, msgType: "Image")
                    self.stopLoader()
                }
            }
        } else {
            if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                uploadImage(pickedImage: img, ext: ".png") { (url) in
                    print(url)
                    DispatchQueue.main.async {
                        self.sendMessage(token: self.fcmTo!, title: "Message from user", body: url!, msgType: "Image")
                        self.stopLoader()
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(pickedImage : UIImage, ext : String, completion: @escaping (_ url: String?) -> Void) {

        let storageRef = Storage.storage().reference().child(String(Date().ticks)+"."+ext)
        if let uploadData = pickedImage.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("firebase storage error : ", error?.localizedDescription)
                    completion(nil)
                } else {

                    storageRef.downloadURL(completion: { (url, error) in

                        print(url?.absoluteString)
                        
                        completion(url?.absoluteString)
                    })

                  //  completion((metadata?.downloadURL()?.absoluteString)!))
                    // your uploaded photo url.


                }
            }
        }
    }
    
    func uploadVideo(pickedImage : Data, ext : String, completion: @escaping (_ url: String?) -> Void) {

            let storageRef = Storage.storage().reference().child(String(Date().ticks)+"."+ext)
    //        if let uploadData = pickedImage.jpegData(compressionQuality: 0.5) {
                storageRef.putData(pickedImage, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print("firebase storage error : ", error?.localizedDescription)
                        completion(nil)
                    } else {

                        storageRef.downloadURL(completion: { (url, error) in

                            print(url?.absoluteString)
                            
                            completion(url?.absoluteString)
                        })

                      //  completion((metadata?.downloadURL()?.absoluteString)!))
                        // your uploaded photo url.


                    }
                }
    //        }
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

extension Messages : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        
        if UIDevice.current.hasNotch
        {
            
            textViewBottomCons.constant = 75
        }
        else
        {
        
        textViewBottomCons.constant = 50
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textViewBottomCons.constant = 0
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
