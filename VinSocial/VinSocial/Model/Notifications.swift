//
//  Notifications.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 27/03/2023.
//

import Foundation
import ObjectMapper
class Notifications: Mappable, Identifiable {
    var user_info:UserInfo?
    var id: String?
    var postid: String?
    var comment_id: String?
    var styleof: String?
    var content: String?
    var addtime: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        user_info <- map["user_info"]
        id <- (map["id"], transform: IntToStringTransform())
        postid <- (map["postid"], transform: IntToStringTransform())
        comment_id <- (map["comment_id"], transform: IntToStringTransform())
        styleof <- map["styleof"]
        content <- map["content"]
        addtime <- (map["addtime"], transform: IntToStringTransform())
    }
}

