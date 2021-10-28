//
//  ArtistService.swift
//  VideoChatApp
//
//  Created by Apple on 11/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ArtistService {
    
    func uploadUserData(params : [String : String], completion: @escaping (Bool ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/createprofile.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        if UserInfo.shared.userId == nil {
            UserInfo.shared.userId = "NA"
        }
        
        if UserInfo.shared.firstName == nil {
            UserInfo.shared.firstName = "NA"
        }
        if UserInfo.shared.lastName == nil {
            UserInfo.shared.lastName = "NA"
        }
        if UserInfo.shared.stageName == nil {
            UserInfo.shared.stageName = "NA"
        }
        if UserInfo.shared.gender == nil {
            UserInfo.shared.gender = "NA"
        }
        if UserInfo.shared.dob == nil {
            UserInfo.shared.dob = Date()
        }
        if UserInfo.shared.ethnicity == nil {
            UserInfo.shared.ethnicity = "NA"
        }
        if UserInfo.shared.musicGenre == nil {
            UserInfo.shared.musicGenre = "NA"
        }
        if UserInfo.shared.timeInMusic == nil {
            UserInfo.shared.timeInMusic = "NA"
        }
        
        if UserInfo.shared.location == nil {
            UserInfo.shared.location = "NA"
        }
        if UserInfo.shared.musicIndustry == nil {
            UserInfo.shared.musicIndustry = "NA"
        }
        
        print(UserInfo.shared.userId!)
        print(UserInfo.shared.firstName!)
        print(UserInfo.shared.lastName!)
        print(UserInfo.shared.stageName!)
        print(UserInfo.shared.gender!)
        print(UserInfo.shared.dob!)
        print(UserInfo.shared.location)
        print(UserInfo.shared.ethnicity!)
        print(UserInfo.shared.musicGenre!)
        print(UserInfo.shared.timeInMusic!)
        print(UserInfo.shared.dpUrl!)
        print(UserInfo.shared.coverPhotoUrl!)
        print(UserInfo.shared.musicIndustry!)
        
        request.httpBody = "loginID=\(UserInfo.shared.userId!)&fname=\(UserInfo.shared.firstName!)&lname=\(UserInfo.shared.lastName!)&stgname=\(UserInfo.shared.stageName!)&gender=\(UserInfo.shared.gender!)&dob=\(UserInfo.shared.dob!)&location=\(UserInfo.shared.location!)&ethinicity=\(UserInfo.shared.ethnicity!)&genre=\(UserInfo.shared.musicGenre!)&timemusic=\(UserInfo.shared.timeInMusic!)&profilepic=\(UserInfo.shared.dpUrl!)&coverpic=\(UserInfo.shared.coverPhotoUrl!)&musicIndustry=\(UserInfo.shared.musicIndustry!)".data(using: String.Encoding.utf8)
        
        print("url params")
    print("loginID=\(UserInfo.shared.userId!)&fname=\(UserInfo.shared.firstName!)&lname=\(UserInfo.shared.lastName!)&stgname=\(UserInfo.shared.stageName!)&gender=\(UserInfo.shared.gender!)&dob=\(UserInfo.shared.dob!)&location=\(UserInfo.shared.location!)&ethinicity=\(UserInfo.shared.ethnicity!)&genre=\(UserInfo.shared.musicGenre!)&timemusic=\(UserInfo.shared.timeInMusic!)&profilepic=\(UserInfo.shared.dpUrl!)&coverpic=\(UserInfo.shared.coverPhotoUrl!)musicIndustry=\(UserInfo.shared.musicIndustry!)")
        
//        request.httpBody = "loginID=18&fname=user1&lname=user1Lst&stgname=last&gender=male&dob=02-04-1993&location=Pakistan&ethinicity=Asian&genre=Beat&timemusic=@ years".data(using: String.Encoding.utf8)
        
        //        request.httpBody = "loginID=user1@gmail.com&fname=simple&token=user1".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false)
                if error == nil {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
            print("response")
            print(response)
            
            completion(true)
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                
                if let resDic = jsonResponse as NSDictionary? {
                    print("resDic")
                    print(resDic)
                    
                    let isSuccess = resDic["issuccess"] as? Bool
                    
                    if isSuccess == true {
                        let msg = resDic["msg"] as? String
                        print(msg)
                    }
                    
                    completion(true)
                }
                
            } catch  let error {
                completion(false)
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    
    func uploadImageAlamo(image : UIImage, completion: @escaping (Bool, String?) -> Void) {
        let image = image
        let imgData = image.jpegData(compressionQuality: 0.5)
        
        let parameters = ["name": "rname"] //Optional for extra parameter
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "file",fileName: String(Date().ticks)+".png", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        },
                         to:"http://waqarulhaq.com/onboard-app/uploading.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
//                upload.uploadProgress(closure: { (progress) in
//                    print("Upload Progress: \(progress.fractionCompleted)")
//                })
                
                upload.responseJSON { response in
                    
                    print(response.result.value)
                    completion(true, response.result.value as! String)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func getFileExt(videoUrl : URL) -> String {
        var url = videoUrl.absoluteString
        print("string url : ", url)
        
        let urlArr = url.components(separatedBy: ".")
        url = "."+urlArr[urlArr.count - 1]
        print("Video extensiion : ", url)
        return url
    }
    
    func followUser (params : [String : String], completion: @escaping (Bool, NSDictionary? ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/follow.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "selfuserid=\(params["selfuserid"]!)&otheruserid=\(params["otheruserid"]!)&type=\(params["type"]!)".data(using: String.Encoding.utf8)
        
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
//                        let obj = resDic["data"] as! [String : Any]
                        
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
    
    func blockUser (params : [String : String], completion: @escaping (Bool, NSDictionary? ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/block.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "selfuserid=\(params["selfuserid"]!)&otheruserid=\(params["otheruserid"]!)&type=\(params["type"]!)".data(using: String.Encoding.utf8)
        
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
                        //                        let obj = resDic["data"] as! [String : Any]
                        
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
    
    func getFollowedUsers( completion: @escaping(Bool, [String]) -> ()){
        let urlString = "http://waqarulhaq.com/onboard-app/followers.php"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpBody = "selfuserid=\(UserInfo.shared.userId!)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!.localizedDescription)
//                completion(error?.localizedDescription ?? "", false, [["nothing": "nothing"]])
                return
            }
            do{
                if let res =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                    
                    
                    var followings = [String]()
                    for dicObj in res{
                        print(dicObj)
                        let data = dicObj["data"] as? [String: Any]
                        guard let otherUserId = data!["otheruserid"] as? String else { return }
                        followings.append(otherUserId)
                        print(data)
                    }
                    
                    completion(true,followings )
                }
                
            }catch let error {
                print(error.localizedDescription)
                let arrayOfDics = [["nothing": "nothing"]]
                
                completion(false, [])
            }
            
            }.resume()
    }
    
    func getBlockedUsers(completion: @escaping(Bool, [String]) -> ()){
        let urlString = "http://waqarulhaq.com/onboard-app/blocked.php"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpBody = "selfuserid=\(UserInfo.shared.userId!)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error!.localizedDescription)
                //                completion(error?.localizedDescription ?? "", false, [["nothing": "nothing"]])
                return
            }
            do{
                if let res =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                    
                    
                    var followings = [String]()
                    for dicObj in res{
                        print(dicObj)
                        let data = dicObj["data"] as? [String: Any]
                        guard let otherUserId = data!["otheruserid"] as? String else { return }
                        followings.append(otherUserId)
                        print(data)
                    }
                    
                    completion(true,followings )
                }
                
            }catch let error {
                print(error.localizedDescription)
                let arrayOfDics = [["nothing": "nothing"]]
                
                completion(false, [])
            }
            
            }.resume()
    }
    
    func getAllUsers(completion: @escaping(Bool, [UserModel]) -> ()){
            let urlString = "http://waqarulhaq.com/onboard-app/all-users.php"
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
//            request.httpBody = "selfuserid=\(UserInfo.shared.userId!)".data(using: String.Encoding.utf8)
            request.httpMethod = "POST"
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    print(error!.localizedDescription)
    //                completion(error?.localizedDescription ?? "", false, [["nothing": "nothing"]])
                    return
                }
                do{
                    if let res =  try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                        
                        
//                        var followings = [String]()
                        var allUsers = [UserModel]()
                        for dicObj in res {
                            let userObj = UserModel()
                            let data = dicObj["data"] as? [String: Any]
                            userObj.userId = data?["loginID"] as? String
                            userObj.email = data?["email"] as? String
                            userObj.fcm = data?["fcm"] as? String
                            userObj.firstName = data?["fname"] as? String
                            userObj.lastName = data?["lname"] as? String
                            userObj.dpUrl = data?["profilepic"] as? String
                            userObj.gender = data?["gender"] as? String
                            userObj.stageName = data?["stgname"] as? String
                            userObj.location = data?["location"] as? String
                            userObj.musicGenre = data?["genre"] as? String
                            userObj.timeInMusic = data?["timemusic"] as? String
                            userObj.dob = data?["dob"] as? Date
                            userObj.ethnicity = data?["ethinicity"] as? String
                            userObj.deviceToken = data?["appletoken"] as? String
//                            print(data)
                            allUsers.append(userObj)
                        }
                        
                        completion(true, allUsers)
                    }
                    
                }catch let error {
                    print(error.localizedDescription)
                    
                    completion(false, [])
                }
                
                }.resume()
        }
    
    func convertDateToStr(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    func genreSuggestionEmail(params : [String : String], completion: @escaping (Bool ) -> ()) {
        let url = URL(string: "http://waqarulhaq.com//onboard-app/send-mail.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.httpBody = "email=\(params["email"]!)&string=\(params["genre"]!)".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false)
                if error == nil {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
//            print("response")
//            print(response)
            
            completion(true)
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                
                if let resDic = jsonResponse as NSDictionary? {
//                    print("resDic")
//                    print(resDic)
                    
                    let isSuccess = resDic["issuccess"] as? Bool
                    
                    if isSuccess == true {
                        let msg = resDic["msg"] as? String
                        print(msg!)
                    }
                    
                    completion(true)
                }
                
            } catch  let error {
                completion(false)
                print(error.localizedDescription)
            }
            
            }.resume()
    }
}
