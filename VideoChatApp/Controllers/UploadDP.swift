//
//  UploadDP.swift
//  VideoChatApp
//
//  Created by Apple on 12/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UploadDP: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    var loadingIndicator = UIActivityIndicatorView()
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
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
    
    @IBAction func uploadBtnAction(_ sender: UIButton) {
        
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
                    UserInfo.shared.dpUrl = response
                    DispatchQueue.main.async {
                        self.stopLoader()
                        
//                        alertWithCompletion(msg: "Display Picture successfully uploaded!", controller: self, onCompletion: { (success) in
                            let parentVC = self.parent as! PageViewController
                            parentVC.setViewControllers([Constants.shared.viewControllerArr[11]], direction: .forward, animated: true, completion: nil)
//                            return
//                        })
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
           let parentVC = self.parent as! PageViewController
           parentVC.setViewControllers([Constants.shared.viewControllerArr[11]], direction: .forward, animated: true, completion: nil)
    }
    @IBAction func backTOSettingBtn(_ sender: Any) {
      
           self.dismiss(animated: true, completion: nil)
       }
}
