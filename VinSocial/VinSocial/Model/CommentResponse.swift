//
//  CommentResponse.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 18/04/2023.
//

import Foundation
import ObjectMapper

class CommentResponse: Mappable, Identifiable {
    var userid_create_comment: UserInfo?
    var postid: String?
    var comment_id: String?
    var reptouserid: String?
    var likes: String?
    var content: String?
    var addtime: String?
    var totalreply: String?
//    var num_items: Int?
    var media:Media?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid_create_comment <- map["userid_create_comment"]
        postid <- (map["postid"], transform: IntToStringTransform())
        comment_id <- (map["comment_id"], transform: IntToStringTransform())
        reptouserid <- (map["reptouserid"], transform: IntToStringTransform())
        likes <- (map["likes"], transform: IntToStringTransform())
        content <- map["content"]
        addtime <- (map["addtime"], transform: IntToStringTransform())
        totalreply <- (map["totalreply"], transform: IntToStringTransform())
//        num_items <- map["num_items"]
        media <- map["media"]
    }
}
