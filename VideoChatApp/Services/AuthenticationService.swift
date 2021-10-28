//
//  AuthenticationService.swift
//  VideoChatApp
//
//  Created by Apple on 08/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class AuthenticationService {
    
    
    static var shared =  AuthenticationService()
    var boolOpenPageViewBySetting: Bool!
    func register (params : [String : String], completion: @escaping (Bool, NSDictionary? ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/signup-signin.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
//        request.httpBody = "email=\(params["email"])&type=\(params["simple"])&token=\(params["password"])".data(using: String.Encoding.utf8)
        
        request.httpBody = "email=user1@gmail.com&type=simple&token=user1".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, nil)
                if error == nil {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
            print("response")
            print(response)
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                
                if let resDic = jsonResponse as NSDictionary?{
                    print("resDic")
                    print(resDic)
                    
                    let isSuccess = resDic["issuccess"] as? Bool
                    
                    if isSuccess == true {
                        let obj = resDic["data"] as! [String : Any]
                        UserInfo.shared.userId = obj["ID"] as? String
                        UserInfo.shared.email = obj["email"] as? String
                        UserInfo.shared.password = obj["token"] as? String
                        
                        UserDefaults.standard.set(UserInfo.shared.userId, forKey: "userId")
                        UserDefaults.standard.set(UserInfo.shared.password, forKey: "username")
                        
                        print(UserInfo.shared.userId)
                        print(UserInfo.shared.email)
                    }
                    
                    completion(true, resDic)
                }
                
            } catch  let error {
                completion(false, nil)
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    
    func login (params : [String : String], completion: @escaping (Bool, NSDictionary? ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/signin.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "email=\(params["email"]!)&type=\(params["type"]!)&token=\(params["token"]!)&fcm=\(params["fcm"]!)".data(using: String.Encoding.utf8)
        
//        request.httpBody = "email=user1@gmail.com&type=simple&token=user1".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, nil)
                if error == nil {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
            print("response")
            print(response)
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                
                if let resDic = jsonResponse as NSDictionary?{
                    print("resDic")
                    print(resDic)
                    
                    let isSuccess = resDic["issuccess"] as? Bool
                    
                    if isSuccess == true {
                        let obj = resDic["data"] as! [String : Any]
                        UserInfo.shared.userId = obj["ID"] as? String
                        UserInfo.shared.email = obj["email"] as? String
                        UserInfo.shared.password = obj["token"] as? String
                        UserInfo.shared.firstName = obj["fname"] as? String
                        UserInfo.shared.lastName = obj["lname"] as? String
                        UserInfo.shared.stageName = obj["stgname"] as? String
                        UserInfo.shared.gender = obj["gender"] as? String
                        UserInfo.shared.dob = obj["dob"] as? Date
                        UserInfo.shared.location = obj["location"] as? String
                        UserInfo.shared.ethnicity = obj["ethinicity"] as? String
                        UserInfo.shared.musicGenre = obj["genre"] as? String
                        UserInfo.shared.timeInMusic = obj["timemusic"] as? String
                        UserInfo.shared.dpUrl = obj["profilepic"] as? String
                        UserInfo.shared.coverPhotoUrl = obj["coverpic"] as? String
                        UserInfo.shared.musicIndustry = obj["musicindustry"] as? String
                        
                        UserDefaults.standard.set(UserInfo.shared.userId, forKey: "userId")
                        UserDefaults.standard.set(UserInfo.shared.email, forKey: "email")
                        UserDefaults.standard.set(UserInfo.shared.password, forKey: "password")
                        UserDefaults.standard.set(UserInfo.shared.firstName, forKey: "fname")
                        UserDefaults.standard.set(UserInfo.shared.lastName, forKey: "lname")
                        UserDefaults.standard.set(UserInfo.shared.stageName, forKey: "stageName")
                        UserDefaults.standard.set(UserInfo.shared.gender, forKey: "gender")
                        UserDefaults.standard.set(UserInfo.shared.dob, forKey: "dob")
                        UserDefaults.standard.set(UserInfo.shared.location, forKey: "location")
                        UserDefaults.standard.set(UserInfo.shared.ethnicity, forKey: "ethinicity")
                        UserDefaults.standard.set(UserInfo.shared.musicGenre, forKey: "genre")
                        UserDefaults.standard.set(UserInfo.shared.timeInMusic, forKey: "timemusic")
                        UserDefaults.standard.set(UserInfo.shared.dpUrl, forKey: "profilepic")
                        UserDefaults.standard.set(UserInfo.shared.coverPhotoUrl, forKey: "coverpic")
                        UserDefaults.standard.set(UserInfo.shared.coverPhotoUrl, forKey: "musicindustry")
                        print(UserInfo.shared.musicIndustry)
                        
                        print(UserInfo.shared.userId)
                        print(UserInfo.shared.email)
                        completion(true, resDic)
                    } else {
                        completion(false, resDic)
                    }
                    
                    
                }
                
            } catch  let error {
                completion(false, nil)
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    
    func signUp (params : [String : String], completion: @escaping (Bool, NSDictionary? ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/signup.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var paramStr = "email="+params["email"]!
        paramStr = paramStr+"&type="+params["type"]!
        paramStr = paramStr+"&token="+params["token"]!
        paramStr = paramStr+"&fcm="+params["fcm"]!
        paramStr = paramStr+"&appletoken="+params["appletoken"]!
        request.httpBody = paramStr.data(using: String.Encoding.utf8)
        
//        request.httpBody = "email=user1@gmail.com&type=simple&token=user1".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, nil)
                if error == nil {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
            print("response")
            print(response)
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                
                if let resDic = jsonResponse as NSDictionary?{
                    print("resDic")
                    print(resDic)
                    
                    let isSuccess = resDic["issuccess"] as? Bool
                    
                    if isSuccess == true {
                        let obj = resDic["data"] as! [String : Any]
                        UserInfo.shared.userId = obj["ID"] as? String
                        UserInfo.shared.email = obj["email"] as? String
                        UserInfo.shared.password = obj["token"] as? String
                        UserDefaults.standard.set(UserInfo.shared.email, forKey: "email")
                        UserDefaults.standard.set(UserInfo.shared.password, forKey: "password")
                        UserDefaults.standard.set(UserInfo.shared.userId, forKey: "userId")
                        UserDefaults.standard.set(UserInfo.shared.firstName, forKey: "username")
                        
                        
                        print(UserInfo.shared.userId)
                        print(UserInfo.shared.email)
                        completion(true, resDic)
                    } else {
                        completion(false, resDic)
                    }
                }
                
            } catch  let error {
                completion(false, nil)
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    func editProfile (userId : String, password: String, stageName: String, profileUrl: String, completion: @escaping (Bool, String ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/edit-profile.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.httpBody = "userID=\(userId)&stagename=\(stageName)&img=\(profileUrl)&password=\(password)".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error?.localizedDescription ?? "Unknown Error")
                if error == nil {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
            print("response")
            print(response)
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                
                if let resDic = jsonResponse as NSDictionary?{
                    print("resDic")
                    print(resDic)
                    
                    let isSuccess = resDic["issuccess"] as? Bool ?? false
                    let msg = resDic["msg"] as? String ?? ""
                    
                    if isSuccess == true {
                       
                        completion(isSuccess, msg)
                    } else {
                        completion(false, "failed")
                    }
                }
                
            } catch  let error {
                completion(false, error.localizedDescription)
                print(error.localizedDescription)
            }
            
        }.resume()
    }

    
        func SendCallPush (params : [String : String], completion: @escaping (Bool, NSDictionary? ) -> ()) {
            let url = URL(string: "http://waqarulhaq.com/onboard-app/makecall.php")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            var paramStr = "devicetoken="+params["channelName"]!
            paramStr = paramStr+"&callername="+params["uid"]!
            request.httpBody = paramStr.data(using: String.Encoding.utf8)
            
    //        request.httpBody = "email=user1@gmail.com&type=simple&token=user1".data(using: String.Encoding.utf8)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    completion(false, nil)
                    if error == nil {
                        print(error?.localizedDescription ?? "Unknown Error")
                    }
                    return
                }
                
                print("response")
                print(response)
                
                do {
                    
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                    
                    if let resDic = jsonResponse as NSDictionary?{
                        print("resDic")
                        print(resDic)
                        
                        let isSuccess = resDic["issuccess"] as? Bool
                        
                        if isSuccess == true {
                            
                            completion(true, resDic)
                        } else {
                            completion(false, resDic)
                        }
                    }
                    
                } catch  let error {
                    completion(false, nil)
                    print(error.localizedDescription)
                }
                
                }.resume()
        }

    
    func getTokenForVideoCall (params : [String : String], completion: @escaping (Bool, NSDictionary? ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/keygeneration.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var paramStr = "channelName="+params["channelName"]!
        paramStr = paramStr+"&uid="+params["uid"]!
        request.httpBody = paramStr.data(using: String.Encoding.utf8)
        
//        request.httpBody = "email=user1@gmail.com&type=simple&token=user1".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, nil)
                if error == nil {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
            print("response")
            print(response)
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                
                if let resDic = jsonResponse as NSDictionary?{
                    print("resDic")
                    print(resDic)
                    
                    let isSuccess = resDic["issuccess"] as? Bool
                    
                    if isSuccess == true {
                        
                        completion(true, resDic)
                    } else {
                        completion(false, resDic)
                    }
                }
                
            } catch  let error {
                completion(false, nil)
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    
}
