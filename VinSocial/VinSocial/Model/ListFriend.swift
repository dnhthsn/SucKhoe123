//
//  ListFriend.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 07/06/2023.
//

import Foundation
import ObjectMapper

class ListFriend: Mappable, Identifiable {
    var userid: String?
    var firebaseuid: String?
    var fullname: String?
    var verify: String?
    var numfriend: String?
    var avatar: String?
    var gender: String?
    var birthday: String?
    var pending: String?
    var follow: String?
    var accepttime: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid <- (map["userid"], transform: IntToStringTransform())
        firebaseuid <- map["firebaseuid"]
        fullname <- map["fullname"]
        verify <- map["verify"]
        numfriend <- (map["numfriend"], transform: IntToStringTransform())
        avatar <- map["avatar"]
        gender <- map["gender"]
        birthday <- map["birthday"]
        pending <- map["pending"]
        follow <- (map["follow"], transform: IntToStringTransform())
        accepttime <- (map["accepttime"], transform: IntToStringTransform())
    }
}
