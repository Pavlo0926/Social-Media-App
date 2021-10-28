//
//  Constants.swift
//  VideoChatApp
//
//  Created by Apple on 04/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let shared = Constants()
    
      var viewControllerArr : [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlugIn"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Birthname"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Stagename"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GenderScreen"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BirthDate"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationScreen"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Ethnicity"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicGenre"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicDuration"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicIndustry"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDP"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadCoverPhoto"),
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        ]
    }()
    
     
    
    let appThemeColor = 0x31BC94
    var currentFCM = ""
    var deviceToken = ""
    var videoCallUdid : UInt? = nil
}
