//
//  UserInfo.swift
//  VideoChatApp
//
//  Created by Apple on 05/05/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class UserInfo {
    
    static let shared = UserInfo()
    
    var userId : String?
    var email : String?
    var password : String?
    var firstName : String?
    var lastName : String?
    var stageName : String?
    var gender : String?
    var dob : Date?
    var location : String?
    var ethnicity : String?
    var musicGenre : String?
    var timeInMusic : String?
    var musicIndustry : String?
    var dpUrl : String?
    var coverPhotoUrl : String?
}
