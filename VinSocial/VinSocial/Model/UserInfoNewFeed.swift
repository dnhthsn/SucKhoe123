//
//  UserInfoNewFeed.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 31/05/2023.
//

import Foundation
import ObjectMapper
class UserInfoNewFeed: Mappable {
    var userid: String?
    var fullname: String?
    var avatar: String?
    var firebaseuid: String?
    var friend_info: FriendInfo?
    var isadmin: Int?
    var access: Int?
    var status: Int?
    var status_text: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid <- (map["userid"], transform: IntToStringTransform())
        fullname <- map["fullname"]
        avatar <- map["avatar"]
        firebaseuid <- map["firebaseuid"]
        friend_info <- map["friend_info"]
        isadmin <- map["isadmin"]
        access <- map["access"]
        status <- map["status"]
        status_text <- map["status_text"]
    }
}
