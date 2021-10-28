//
//  MusicGenre.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MusicGenre: UIViewController {

    @IBOutlet weak var navigationHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pageCountTopCons: NSLayoutConstraint!
    @IBOutlet var genreBtns: [UIButton]!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    var loadingIndicator = UIActivityIndicatorView()
    
    var btnUnselectedBgColor : UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnUnselectedBgColor = genreBtns[0].backgroundColor
        getData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if AuthenticationService.shared.boolOpenPageViewBySetting{
            self.btnContinue.setTitle("Update", for: .normal)
            self.btnSkip.isHidden = false
            self.btnBack.isHidden = true
        }else{
            self.navigationHeightCons.constant = 0.0
            self.pageCountTopCons.constant = 50.0
            self.btnContinue.setTitle("Continue", for: .normal)
            self.btnSkip.isHidden = true
            self.btnBack.isHidden = false
        }
    }
    func getData() {
        if UserInfo.shared.musicGenre != nil {
            selectedButton(title: UserInfo.shared.musicGenre!)
        }
    }
    
    @IBAction func genreBtnClicked(_ sender: UIButton) {
        selectedButton(title: sender.title(for: .normal)!)
    }
    
    func selectedButton(title : String) {
        for btn in genreBtns {
            if btn.title(for: .normal) == title {
                UserInfo.shared.musicGenre = title
                btn.backgroundColor = UIColor(rgb: Constants.shared.appThemeColor)
            } else {
                btn.backgroundColor = btnUnselectedBgColor
            }
        }
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[8]], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        let parentVC = self.parent as! PageViewController
    parentVC.setViewControllers([Constants.shared.viewControllerArr[6]], direction: .reverse, animated: true, completion: nil)
    }
    
    @IBAction func suggestionBtnAction(_ sender: UIButton) {
        alertWithTF(controller: self) { (isOk, genre) in
            if isOk {
                self.startLoader()
                let artService = ArtistService()
                artService.genreSuggestionEmail(params: ["email" : "appicdevices@gmail.com", "genre" : genre]) { (success) in
                    if success == true {
                        DispatchQueue.main.async {
                            alert(msg: "Email has been sent.", controller: self)
                            self.stopLoader()
                        }
                    }
                }
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
    @IBAction func skipBtnClicked(_ sender: Any) {
      let parentVC = self.parent as! PageViewController
        parentVC.setViewControllers([Constants.shared.viewControllerArr[8]], direction: .forward, animated: true, completion: nil)
    }
    @IBAction func backTOSettingBtn(_ sender: Any) {
      
           self.dismiss(animated: true, completion: nil)
       }
}
