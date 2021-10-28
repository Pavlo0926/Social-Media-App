//
//  Login.swift
//  VideoChatApp
//
//  Created by Apple on 08/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire

class Login: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var fbImg: UIImageView!
    @IBOutlet weak var gmailImg: UIImageView!
    
    var loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let loginButton = FBLoginButton()
        //        loginButton.center = view.center
        //        view.addSubview(loginButton)
        //
        //        loginButton.permissions = ["public_profile", "email"]
        
        hideKeyboardWhenTappedAround()
        
        let fbTap = UITapGestureRecognizer(target: self, action: #selector(fbLoginAction))
        fbImg.isUserInteractionEnabled = true
        fbImg.addGestureRecognizer(fbTap)
        
        let gmailTap = UITapGestureRecognizer(target: self, action: #selector(gmailLoginAction))
        gmailImg.isUserInteractionEnabled = true
        gmailImg.addGestureRecognizer(gmailTap)
    }
    
    @objc func fbLoginAction() {
        //        if let token = AccessToken.current {
        //            self.performSegue(withIdentifier: "LoginToTabbar", sender: nil)
        //        } else {
        //            let loginManager = LoginManager()
        //            loginManager.logIn(permissions: [Permission.publicProfile, Permission.email], viewController: self) { (loginResult) in
        //                switch loginResult {
        //                case .failed(error):
        //                    print(error)
        //
        //                case .cancelled:
        //                    print("User cancelled login")
        //
        //                    case .success(granted: grantedPermission, declined: <#T##Set<Permission>#>, token: <#T##AccessToken#>)
        //                }
        //
        //
        //            }
        //        }
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    print("User cancelled login")
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    let token = result?.token?.tokenString
                    if let tokens = token{
                        self.getFBUserData(token: tokens)
                    }
                }
            }
        }
    }
    
    // Get and extract needed data of facbook login
    func getFBUserData(token: String){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user dat
                    if let fbuserDic = result as? NSDictionary{
                        
                        var email = fbuserDic["email"] as? String ?? ""
                        let name = fbuserDic["name"] as? String ?? ""
                        let id = fbuserDic["id"] as? String ?? ""
                        if email == ""{
                            email = name
                        }
                        
                        let auth = AuthenticationService()
                        self.startLoader()
                        auth.register(params: ["email" : email, "token" : id, "type" : "facebook"], completion: { (success, response) in
                            if success == true {
                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    self.performSegue(withIdentifier: "LoginToTabbar", sender: nil)
                                }
                                
                            }
                        })
                        // self.userRegister(emails: email, passwords: id, type: "facebook")
                        
                    }
                }
            })
        }
    }
    
    @objc func gmailLoginAction() {
        
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        if emailField.text == "" || passwordField.text == "" {
            alert(msg: "All fields are required", controller: self)
            return
        } else {
            
            let params : [String : String] = ["email" : emailField.text!, "token" : passwordField.text!, "type" : "simple", "fcm" : Constants.shared.currentFCM]
            
            if NetworkReachabilityManager()!.isReachable
            {
                startLoader()
                let auth = AuthenticationService()
                auth.login(params: params) { (success, response) in
                    if success == true {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "LoginToTabbar", sender: nil)
                            self.stopLoader()
                        }
                    } else {
                        print("No SUccess after completion call")
                        DispatchQueue.main.async {
                            self.stopLoader()
                            alert(msg: "Invalid Username or password!", controller: self)
                        }
                    }
                }
            }
            else{
                alert(msg: "No Internet Connection", controller: self)
            }
        }
    }
    
    @IBAction func goToSignup(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginToSignup", sender: nil)
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
