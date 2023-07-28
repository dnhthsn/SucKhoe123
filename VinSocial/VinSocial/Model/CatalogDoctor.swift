//
//  CatalogDoctor.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 25/05/2023.
//

import Foundation
import ObjectMapper

class CatalogDoctor: Mappable, Identifiable {
    var userid: String?
    var fullname: String?
    var verify: String?
    var avatar: String?
    var totalanswer: String?
    var totalvideo: String?
    var totalimage: String?
    var description: String?
    var firebaseuid: String?
    var friend_info: FriendInfo?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid <- (map["userid"], transform: IntToStringTransform())
        fullname <- map["fullname"]
        verify <- map["verify"]
        avatar <- map["avatar"]
        totalanswer <- (map["totalanswer"], transform: IntToStringTransform())
        totalvideo <- (map["totalvideo"], transform: IntToStringTransform())
        totalimage <- (map["totalimage"], transform: IntToStringTransform())
        description <- map["description"]
        firebaseuid <- map["firebaseuid"]
        friend_info <- map["friend_info"]
    }
}
