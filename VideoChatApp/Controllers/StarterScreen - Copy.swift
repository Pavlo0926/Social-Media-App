//
//  StarterScreen.swift
//  VideoChatApp
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import InstagramLogin
import FirebaseMessaging
import FirebaseInstanceID
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices

class StarterScreen: UIViewController {

    @IBOutlet weak var fbImg: UIImageView!
    @IBOutlet weak var instaImg: UIImageView!
    @IBOutlet weak var phoneImg: UIImageView!
    @IBOutlet weak var envelopImg: UIImageView!
    
    var loadingIndicator = UIActivityIndicatorView()
    
    var instagramLogin: InstagramLoginViewController!
    
    let clientId = "<YOUR CLIENT ID GOES HERE>"
    let redirectUri = "<YOUR REDIRECT URI GOES HERE>"
    
    let appleProvider = AppleSignInClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if UserDefaults.standard.string(forKey: "userId") != nil && UserDefaults.standard.string(forKey: "email") != nil && UserDefaults.standard.string(forKey: "password") != nil {
//
//            UserInfo.shared.userId = UserDefaults.standard.string(forKey: "userId")
//            UserInfo.shared.email = UserDefaults.standard.string(forKey: "email")
//            UserInfo.shared.password = UserDefaults.standard.string(forKey: "password")
//            UserInfo.shared.firstName = UserDefaults.standard.string(forKey: "fname")
//            UserInfo.shared.lastName = UserDefaults.standard.string(forKey: "lname")
//            UserInfo.shared.stageName = UserDefaults.standard.string(forKey: "stageName")
//            UserInfo.shared.gender = UserDefaults.standard.string(forKey: "gender")
//            UserInfo.shared.dob = UserDefaults.standard.string(forKey: "dob") as? Date
//            UserInfo.shared.location = UserDefaults.standard.string(forKey: "location")
//            UserInfo.shared.ethnicity = UserDefaults.standard.string(forKey: "ethnicity")
//            UserInfo.shared.musicGenre = UserDefaults.standard.string(forKey: "genre")
//            UserInfo.shared.timeInMusic = UserDefaults.standard.string(forKey: "timemusic")
//            UserInfo.shared.dpUrl = UserDefaults.standard.string(forKey: "profilepic")
//            UserInfo.shared.coverPhotoUrl = UserDefaults.standard.string(forKey: "coverpic")
//
//            print(UserInfo.shared.email)
//            print(UserInfo.shared.firstName)
//            print(UserInfo.shared.dpUrl)
//
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "StarterToTabbar", sender: nil)
//            }
//
//        }
        
        let fbImgTap = UITapGestureRecognizer(target: self, action: #selector(fbImgTapped(tapGestureRecognizer:)))
        fbImg.addGestureRecognizer(fbImgTap)
        
        let phoneImgTap = UITapGestureRecognizer(target: self, action: #selector(phoneImgTapped(tapGestureRecognizer:)))
        phoneImg.addGestureRecognizer(phoneImgTap)
        
        let envelopImgTap = UITapGestureRecognizer(target: self, action: #selector(envImgTapped(tapGestureRecognizer:)))
        envelopImg.addGestureRecognizer(envelopImgTap)
        
        let instagramImgTap = UITapGestureRecognizer(target: self, action: #selector(instagramImgTapped(tapGestureRecognizer:)))
        instaImg.isUserInteractionEnabled = true
        instaImg.addGestureRecognizer(instagramImgTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "userId") != nil && UserDefaults.standard.string(forKey: "email") != nil && UserDefaults.standard.string(forKey: "password") != nil {
            
            UserInfo.shared.userId = UserDefaults.standard.string(forKey: "userId")
            UserInfo.shared.email = UserDefaults.standard.string(forKey: "email")
            UserInfo.shared.password = UserDefaults.standard.string(forKey: "password")
            UserInfo.shared.firstName = UserDefaults.standard.string(forKey: "fname")
            UserInfo.shared.lastName = UserDefaults.standard.string(forKey: "lname")
            UserInfo.shared.stageName = UserDefaults.standard.string(forKey: "stageName")
            UserInfo.shared.gender = UserDefaults.standard.string(forKey: "gender")
            UserInfo.shared.dob = UserDefaults.standard.string(forKey: "dob") as? Date
            UserInfo.shared.location = UserDefaults.standard.string(forKey: "location")
            UserInfo.shared.ethnicity = UserDefaults.standard.string(forKey: "ethnicity")
            UserInfo.shared.musicGenre = UserDefaults.standard.string(forKey: "genre")
            UserInfo.shared.timeInMusic = UserDefaults.standard.string(forKey: "timemusic")
            UserInfo.shared.dpUrl = UserDefaults.standard.string(forKey: "profilepic")
            UserInfo.shared.coverPhotoUrl = UserDefaults.standard.string(forKey: "coverpic")
            
//            print(UserInfo.shared.email)
//            print(UserInfo.shared.firstName)
//            print(UserInfo.shared.dpUrl)
            if AuthenticationService.shared.boolOpenPageViewBySetting != nil{
                if AuthenticationService.shared.boolOpenPageViewBySetting{
                    print("do nothing")
                }else{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "StarterToTabbar", sender: nil)
                    }

                }
            }else{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "StarterToTabbar", sender: nil)
                }
            }
            
            
        }
    }
    
    func handleLogTokenTouch() {
        let token = Messaging.messaging().fcmToken
        print("FCM token : \(token ?? "")")
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
//            self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
          }
        }
    }
    
    @objc func fbImgTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        performSegue(withIdentifier: "StarterToSignup", sender: nil)
        
        let fbToken = UserDefaults.standard.string(forKey: "fb_token")
        if fbToken != nil {
            getFBUserData(token: fbToken!, isLoggedIn: true)
            
        } else {
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
                            self.getFBUserData(token: tokens, isLoggedIn: false)
                        }
                    }
                }
            }
        }
    }
    
    @objc func phoneImgTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        AuthenticationService.shared.boolOpenPageViewBySetting = false
        performSegue(withIdentifier: "StarterToSignup", sender: nil)
    }
    
    @objc func envImgTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        AuthenticationService.shared.boolOpenPageViewBySetting = false
        performSegue(withIdentifier: "StarterToSignup", sender: nil)
    }
    
    @objc func instagramImgTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //loginWithInstagram()
        
        if #available(iOS 13.0, *) {
            appleProvider.handleAppleIdRequest { (fullName, email, token) in
                print("sign in pressed")
                print(fullName)
                print(email)
                print(token)
                
                UserDefaults.standard.setValue(token, forKey: "apple_login_token")
//                self.performSegue(withIdentifier: "StarterToTabbar", sender: nil)
                
//                self.startLoader()
//                let auth = AuthenticationService()
//                auth.signUp(params: ["email" : email!, "token" : token!, "type" : "apple", "fcm" : Constants.shared.currentFCM]) { (success, response) in
//                    if success == true {
//                        print("Response after completion call")
//                        DispatchQueue.main.async {
//                            self.stopLoader()
//                            self.performSegue(withIdentifier: "StarterToPVC", sender: nil)
//                        }
//                    }
//                    else {
//                        DispatchQueue.main.async {
//                            self.stopLoader()
//                            alert(msg: "You are already registered.", controller: self)
//                        }
//                    }
//                }
            }
        } else {
            alert(msg: "Sign In with Apple is only available on iOS 13 or above.", controller: self)
        }
    }

    @IBAction func loginBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "StartScreenToLogin", sender: nil)
    }
    
    func getFBUserData(token: String, isLoggedIn : Bool){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user dat
                    if let fbuserDic = result as? NSDictionary {
                        print(fbuserDic)
                        var email = fbuserDic["email"] as? String ?? ""
                        let name = fbuserDic["name"] as? String ?? ""
                        let id = fbuserDic["id"] as? String ?? ""
                        let fname = fbuserDic["first_name"] as? String ?? ""
                        let lname = fbuserDic["last_name"] as? String ?? ""
                        let picture = fbuserDic["picture"] as! [String : Any]
                        let data = picture["data"] as! [String : Any]
                        let dpUrl = data["url"] as! String
                        if email == "" {
                            email = name
                        }
                        
                        UserDefaults.standard.set(id, forKey: "fb_token")
//                        UserDefaults.standard.set(email, forKey: "fb_email")
//                        UserDefaults.standard.set(name, forKey: "fb_name")
//                        UserDefaults.standard.set(fname, forKey: "fb_fname")
//                        UserDefaults.standard.set(lname, forKey: "fb_lname")
//                        UserDefaults.standard.set(dpUrl, forKey: "fb_dpUrl")
//
                        UserInfo.shared.password = id
                        UserInfo.shared.email = email
                        UserInfo.shared.firstName = fname
                        UserInfo.shared.lastName = lname
                        UserInfo.shared.dpUrl = dpUrl
                        
                        let auth = AuthenticationService()
                        self.startLoader()
//                        auth.register(params: ["email" : email, "token" : id, "type" : "facebook"], completion: { (success, response) in
//                            if success == true {
//                                DispatchQueue.main.async {
//                                    self.stopLoader()
//                                    self.performSegue(withIdentifier: "StarterToTabbar", sender: nil)
//                                }
//                            }
//                        })
                        if isLoggedIn == false {
                            auth.signUp(params: ["email" : email, "token" : id, "type" : "facebook", "fcm" : Constants.shared.currentFCM]) { (success, response) in
                                if success == true {
                                    print("Response after completion call")
                                    DispatchQueue.main.async {
                                        self.stopLoader()
                                        self.performSegue(withIdentifier: "StarterToPVC", sender: nil)
                                    }
                                }
                                else {
                                    DispatchQueue.main.async {
                                        self.stopLoader()
                                        alert(msg: "You are already registered.", controller: self)
                                    }
                                }
                            }
                        } else {
                            auth.login(params: ["email" : email, "token" : id, "type" : "facebook"]) { (success, response) in
                                if success == true {
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "StarterToTabbar", sender: nil)
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
                        
                    }
                }
            })
        }
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

extension StarterScreen:InstagramLoginViewControllerDelegate
{
    
    
    func loginWithInstagram() {

        // 2. Initialize your 'InstagramLoginViewController' and set your 'ViewController' to delegate it
        instagramLogin = InstagramLoginViewController(clientId: clientId, redirectUri: redirectUri)
        instagramLogin.delegate = self

        // 3. Customize it
        instagramLogin.scopes = [.basic, .publicContent] // [.basic] by default; [.all] to set all permissions
        instagramLogin.title = "Instagram" // If you don't specify it, the website title will be showed
        instagramLogin.progressViewTintColor = .blue // #E1306C by default

        // If you want a .stop (or other) UIBarButtonItem on the left of the view controller
        instagramLogin.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))

        // You could also add a refresh UIBarButtonItem on the right
        instagramLogin.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPage))

        // 4. Present it inside a UINavigationController (for example)
        present(UINavigationController(rootViewController: instagramLogin), animated: true)
    }

    @objc func dismissLoginViewController() {
        instagramLogin.dismiss(animated: true)
    }

    @objc func refreshPage() {
        instagramLogin.reloadPage()
    }
    
    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?) {

       // Whatever you want to do ...

       // And don't forget to dismiss the 'InstagramLoginViewController'
       instagramLogin.dismiss(animated: true)
   }
    
    
}

