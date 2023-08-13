//
//  SignUp.swift
//  VideoChatApp
//
//  Created by Apple on 08/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
import InstagramLogin

class SignUp: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var loadingIndicator = UIActivityIndicatorView()
    var isEditProfile = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        if isEditProfile == true {
            email.text = UserDefaults.standard.value(forKey: "email") as? String
            password.text = UserDefaults.standard.value(forKey: "token") as? String
            confirmPassword.text = UserDefaults.standard.value(forKey: "token") as? String
        }
    }
    
    @IBAction func signUpOnClick(_ sender: UIButton) {
        if email.text == "" || password.text == "" || confirmPassword.text == "" {
            alert(msg: "All fields are required", controller: self)
        }
        else
        {
            if isValidEmail(emailStr: email.text!)
            {
                
                if password.text == confirmPassword.text && isEditProfile == false {
                    
                    let params : [String : String] = ["email" : email.text!, "token" : password.text!, "type" : "simple", "fcm" : Constants.shared.currentFCM,"appletoken":Constants.shared.deviceToken]
                    if NetworkReachabilityManager()!.isReachable
                    {
                        let auth = AuthenticationService()
                        startLoader()
                        auth.signUp(params: params) { (success, response) in
                            if success == true {
                                print("Response after completion call")
                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    AuthenticationService.shared.boolOpenPageViewBySetting = false
                                    self.performSegue(withIdentifier: "SignupToPageVC", sender: nil)
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    alert(msg: "You are already registered.", controller: self)
                                }
                            }
                        }
                    }
                    
                    else
                    {
                        alert(msg: "No Internet Connection", controller: self)
                    }
                    
                } else {
                    if isEditProfile == false {
                        alert(msg: "Passwords does not match", controller: self)
                    } else {
            AuthenticationService.shared.boolOpenPageViewBySetting = false
                        self.performSegue(withIdentifier: "SignupToPageVC", sender: nil)
                    }
                    
                }
            }
            else {
                alert(msg: "Invalid Email", controller: self)
            }
        }
    }
    
    @IBAction func goToLoginOnClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
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


