//
//  AddMusic.swift
//  VideoChatApp
//
//  Created by Apple on 30/04/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import SwiftyJSON

class AddMusic: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    var loadingIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermission()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Upload", style: .done, target: self, action: #selector(self.upload(sender:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.selectedIndex = 0
    }

    @IBAction func uploadBtn(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController ()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print("videoUrl")
            print(videoURL)
            startLoader()
            uploadVideo(videoUrl: videoURL) { (success, videoServerUrl) in
                print(success)
                print("videoServerUrl", videoServerUrl)
                DispatchQueue.main.async {
                    self.stopLoader()
                    self.uploadBtn.isUserInteractionEnabled = true
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoDataVC") as? VideoDataVC
                    vc?.videoServerUrl = videoServerUrl
                    self.navigationController?.pushViewController(vc!, animated: true)
                    return
                    
//                    alertWithCompletion(msg: "Video successfully uploaded!", controller: self, onCompletion: { (success) in
//                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoDataVC") as? VideoDataVC
//                        vc?.videoServerUrl = videoServerUrl
//                        self.navigationController?.pushViewController(vc!, animated: true)
//                        return
//                    })
                    
                }
                
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
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
    
    func uploadVideo(videoUrl : URL, completion: @escaping (Bool, String) -> Void) {
        
        let ext = getFileExt(videoUrl: videoUrl)
        
        uploadBtn.isUserInteractionEnabled = false
        let url = "http://waqarulhaq.com/onboard-app/uploading.php"      // your API url
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]

        Alamofire.upload(multipartFormData: { (multipartFormData) in

//            var parameters : [String : Any]
            var videoData: NSData? = nil
//            var imageData: Data? = nil

                do {
                    videoData = try NSData(contentsOfFile: videoUrl.path, options: NSData.ReadingOptions.alwaysMapped)

                } catch _ {
                    videoData = nil
                }

                print(videoData)
//                parameters = ["OrderID" : newOrderID, "DataID" : files[file].DataID, "mediaFile" : videoData, "UnixTimestamp" : uploadDictionary["UnixTimestamp"]!]



//            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }

            if videoUrl.path.contains(".jpg") {
//                multipartFormData.append(videoData, withName: "mediaFile", fileName: videoUrl.path, mimeType: "image/jpg")
            }else if videoUrl.path.contains(".mp4") {
                multipartFormData.append(Data(referencing: videoData!), withName: "file", fileName: String(Date().ticks)+ext, mimeType: "video/MOV")
            }else {
                multipartFormData.append(Data(referencing: videoData!), withName: "file", fileName: String(Date().ticks)+ext, mimeType: "video/MOV")
            }

        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseString { response in
                    let data = JSON(response.result.value!).stringValue
                    print(data)
                    completion(true, data)
                    if let err = response.error {
                        print(err)
                        return
                    }

                }
            case .failure(let error):
                completion(false, "")
                print("Error in image uploading : \(error.localizedDescription)")
            }
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
