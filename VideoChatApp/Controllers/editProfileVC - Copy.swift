//
//  editProfileVC.swift
//  VideoChatApp
//
//  Created by Appic Devices on 07/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire



class editProfileVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
var loadingIndicator = UIActivityIndicatorView()
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    var stageName = ""
    var password = ""
    var imgUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Edit Account"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.stageName = UserInfo.shared.stageName!
        self.password = UserInfo.shared.password!
        self.imgUrl = UserInfo.shared.dpUrl!
        self.txtUserName.text = UserInfo.shared.stageName
        self.txtPassword.text = UserInfo.shared.password
        imgProfile.layer.cornerRadius = 90
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = UIColor.black.cgColor
        imgProfile.clipsToBounds = true
        //        profilePic.image = UIImage(named: "dummy_black")
        if UserInfo.shared.dpUrl != nil{
            print(UserInfo.shared.dpUrl!)
            let url = UserInfo.shared.dpUrl?.replacingOccurrences(of: "http", with: "https")
            imgProfile.downloaded(from: url!)
        }
        
    }
    
    @IBAction func editProfileAction(_ sender: UIButton){
        
        
        print(self.txtUserName.text)
        print(self.txtPassword.text)
        print(self.stageName)
        print(self.password)
        print(self.imgUrl)
        print(UserInfo.shared.dpUrl!)
        
        
        if (self.txtUserName.text?.elementsEqual(self.stageName))! && (self.txtPassword.text?.elementsEqual(self.password))! && self.imgUrl.elementsEqual(UserInfo.shared.dpUrl!){
            self.navigationController?.popViewController(animated: true)
        }else{
            UserInfo.shared.stageName = self.txtUserName.text
            //        UserInfo.shared.firstName = self.txtUserName.text
            UserInfo.shared.password = self.txtPassword.text
            
            DispatchQueue.main.async {
                
                let params : [String : String] = ["" : ""]
                
                let artistService = ArtistService()
                
                AuthenticationService.shared.editProfile(userId: UserInfo.shared.userId!, password: self.txtPassword.text!, stageName: self.txtUserName.text!, profileUrl: UserInfo.shared.dpUrl!) { (isSucceed, msg) in
                    if isSucceed{
                        DispatchQueue.main.async {
                            self.stopLoader()
                            
                            //                        alert(msg: "information updated successfully", controller: self)
                            // Create the alert controller
                            let alertController = UIAlertController(title: "Success", message: "information updated successfully", preferredStyle: .alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            
                            // Add the actions
                            alertController.addAction(okAction)
                            
                            
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                
                //
            }
            
        }
        
        
    }
    
    @IBAction func imgUploadAction(_ sender: UIButton){
        let imagePickerController = UIImagePickerController ()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        //        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }

      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.imgProfile.image = pickedImage
                startLoader()
                let artistService = ArtistService()
                artistService.uploadImageAlamo(image: pickedImage) { (success, response) in
                    print(response)
                    
                    if success == true {
                        UserInfo.shared.dpUrl = response
                        DispatchQueue.main.async {
                            self.stopLoader()
                            
                            
                            alertWithCompletion(msg: "Display Picture successfully uploaded!", controller: self, onCompletion: { (success) in
//                                let parentVC = self.parent as! PageViewController
//                                parentVC.setViewControllers([Constants.shared.viewControllerArr[11]], direction: .forward, animated: true, completion: nil)
                                return
                            })
                        }
                        
                    }
                }
            }
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
}
