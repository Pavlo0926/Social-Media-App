//
//  UploadCoverPhoto.swift
//  VideoChatApp
//
//  Created by Apple on 15/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UploadCoverPhoto: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    var loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if AuthenticationService.shared.boolOpenPageViewBySetting{
            self.btnUpload.setTitle("Update", for: .normal)
            self.btnSkip.isHidden = false
        }else{
            self.navigationHeightCons.constant = 0.0
            self.pageCountTopCons.constant = 50.0
            self.btnUpload.setTitle("Upload", for: .normal)
            self.btnSkip.isHidden = true
        }
    }
    @IBAction func uploadBtnAction(_ sender: Any) {
        let imagePickerController = UIImagePickerController ()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        //        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            startLoader()
            let artistService = ArtistService()
            artistService.uploadImageAlamo(image: pickedImage) { (success, response) in
                print(response)
                
                if success == true {
                    UserInfo.shared.coverPhotoUrl = response
                    DispatchQueue.main.async {
                        
                        let params : [String : String] = ["" : ""]
                        
                        let artistService = ArtistService()
                        artistService.uploadUserData(params: params) { (success) in
                            if success == true {
                                DispatchQueue.main.async {
                                    self.stopLoader()
                                    
                                    //                                    alertWithCompletion(msg: "User data successfully uploaded!", controller: self, onCompletion: { (success) in
                                    //                                    if AuthenticationService.shared.boolOpenPageViewBySetting{
                                    //                                      self.performSegue(withIdentifier: "uploadCoverPhotoToTabBar", sender: nil)
                                    //                                    }else{
                                    //                                        let parentVC = self.parent as! PageViewController
                                    //
                                    //                                            parentVC.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")], direction: .forward, animated: true, completion: nil)
                                    //                                    }
                                    
                                    let parentVC = self.parent as! PageViewController
                                    
                                    parentVC.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")], direction: .forward, animated: true, completion: nil)
                                    
                                    
                                    
                                    //                                    parentVC.setViewControllers(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar"), direction: <#T##UIPageViewController.NavigationDirection#>, animated: <#T##Bool#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
                                    //                                        return
                                    //                                    })
                                }
                            }
                        }
                        //
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
    @IBAction func skipBtnClicked(_ sender: Any) {
        
        
        
        DispatchQueue.main.async {
            self.startLoader()
            let params : [String : String] = ["" : ""]
            
            let artistService = ArtistService()
            artistService.uploadUserData(params: params) { (success) in
                if success == true {
                    DispatchQueue.main.async {
                        self.stopLoader()
                        
                        //                                    alertWithCompletion(msg: "User data successfully uploaded!", controller: self, onCompletion: { (success) in
                        //                                    if AuthenticationService.shared.boolOpenPageViewBySetting{
                        //                                      self.performSegue(withIdentifier: "uploadCoverPhotoToTabBar", sender: nil)
                        //                                    }else{
                        //                                        let parentVC = self.parent as! PageViewController
                        //
                        //                                            parentVC.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")], direction: .forward, animated: true, completion: nil)
                        //                                    }
                      
                        let parentVC = self.parent as! PageViewController

                        parentVC.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")], direction: .forward, animated: true, completion: nil)
                        
                        
                        
                        //                                    parentVC.setViewControllers(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar"), direction: <#T##UIPageViewController.NavigationDirection#>, animated: <#T##Bool#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
                        //                                        return
                        //                                    })
                    }
                }
            }
            //
        }

        
           
       }
    @IBAction func backTOSettingBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
