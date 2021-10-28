//
//  VideoService.swift
//  VideoChatApp
//
//  Created by Apple on 11/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class VideoService {
    
    func uploadVideoData(params : [String : String], completion: @escaping (Bool) -> ()) {
        let url = URL(string: "http://waqarulhaq.com/onboard-app/save-video.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "loginID=\(params["loginID"]!)&artistname=\(params["artistname"]!)&title=\(params["title"]!)&genre=\(params["genre"]!)&caption=\(params["caption"]!)&file=\(params["file"]!)".data(using: String.Encoding.utf8)
        print(params)
//        request.httpBody = "loginID=18&artistname=user1&title=mySong2&genre=choir&caption=dotMusic&file=http://waqarulhaq.com/onboard-app/save-video.php".data(using: String.Encoding.utf8)
        
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
            
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                
                if let resDic = jsonResponse as NSDictionary?{
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
    
    //http://waqarulhaq.com/onboard-app/deletevideo.php?videoid=14
        func deleteVideoData(params : [String : String], completion: @escaping (Bool) -> ()) {
            let url = URL(string: "http://waqarulhaq.com/onboard-app/deletevideo.php")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = "videoid=\(params["videoid"]!)".data(using: String.Encoding.utf8)
            print(params)
    //        request.httpBody = "loginID=18&artistname=user1&title=mySong2&genre=choir&caption=dotMusic&file=http://waqarulhaq.com/onboard-app/save-video.php".data(using: String.Encoding.utf8)
            
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
                
                do {
                    
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])  as? [String: Any]
                    
                    if let resDic = jsonResponse as NSDictionary?{
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
    
    func getVideoData(genre : String, completion: @escaping (Bool, [VideoModel] ) -> ()) {
        print(UserInfo.shared.userId)
        guard var url = URL(string: "http://waqarulhaq.com/onboard-app/get-video.php?userid="+UserInfo.shared.userId!) else {return}
        if genre != "" {
            url = URL(string: "http://waqarulhaq.com/onboard-app/get-video.php?genre="+genre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                
                var videoArr = [VideoModel]()
                for dic in jsonArray {
                    var videoObj = VideoModel()
                    guard let id = dic["ID"] as? String else { return }
                    guard let userId = dic["loginID"] as? String else { return }
                    guard let artistName = dic["artistname"] as? String else { return }
                    guard let title = dic["title"] as? String else { return }
                    guard let genre = dic["genre"] as? String else { return }
                    guard let caption = dic["caption"] as? String else { return }
                    guard let fileUrl = dic["file"] as? String else { return }
                    guard let profilePicUrl = dic["profilepic"] as? String else { return }
                    guard let coverPicUrl = dic["coverpic"] as? String else { return }
                    guard let fcm = dic["fcm"] as? String else { return }
                    guard let email = dic["email"] as? String else { return }
                    guard let appletoken = dic["appletoken"] as? String else { return }
                    guard let stageName = dic["stagename"] as? String else { return }
                    
                    
                    print(artistName)
                    print(caption)
                    print(fileUrl)
                    
                    videoObj.loginID = userId
                    videoObj.artistName = artistName
                    videoObj.songTitle = title
                    videoObj.genre = genre
                    videoObj.caption = caption
                    videoObj.videoUrl = fileUrl
                    videoObj.profilePicUrl = profilePicUrl
                    videoObj.coverPicUrl=coverPicUrl
                    videoObj.fcm = fcm
                    videoObj.email = email
                    videoObj.ID = id
                    videoObj.appletoken = appletoken
                    videoObj.stageName = stageName
                    
                    videoArr.append(videoObj)
                }
                completion(true, videoArr)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    

        func getMyVideosData(genre : String, completion: @escaping (Bool, [VideoModel] ) -> ()) {
            guard var url = URL(string: "http://waqarulhaq.com/onboard-app/getmyvideos.php?userid="+UserInfo.shared.userId!) else {return}
            print(UserInfo.shared.userId)
            if genre != "" {
                url = URL(string: "http://waqarulhaq.com/onboard-app/get-video.php?genre="+genre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                // http://waqarulhaq.com/onboard-app/getmyvideos.php?userid=42
                
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    print(jsonResponse) //Response result
                    
                     guard let jsonArray = jsonResponse as? [[String: Any]] else {
                        return}
                    print(jsonArray)
                    
                    var videoArr = [VideoModel]()
                    for dic in jsonArray {
                        var videoObj = VideoModel()
                          let id = dic["ID"] as? String //else { return }
                         let userId = dic["loginID"] as? String //else { return }
                         let artistName = dic["artistname"] as? String //else { return }
                         let title = dic["title"] as? String //else { return }
                        let genre = dic["genre"] as? String //else { return }
                         let caption = dic["caption"] as? String //else { return }
                         let fileUrl = dic["file"] as? String //else { return }
                         let profilePicUrl = dic["profilepic"] as? String //else { return }
                         let coverPicUrl = dic["coverpic"] as? String //else { return }
                        let stageName = dic["stagename"] as? String ?? ""
                        
                                               
        
                        
                        videoObj.loginID = userId
                        videoObj.artistName = artistName
                        videoObj.songTitle = title
                        videoObj.genre = genre
                        videoObj.caption = caption
                        videoObj.videoUrl = fileUrl
                        videoObj.ID = id
                        videoObj.stageName = stageName
                        
                        videoArr.append(videoObj)
                    }
                    completion(true, videoArr)
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
        }
    
    
}
