//
//  UserInfo.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/15/23.
//

import Foundation
import ObjectMapper
class UserInfo: Mappable {
    var userid: String?
    var fullname: String?
    var avatar: String?
    var firebaseuid: String?
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid <- (map["userid"], transform: IntToStringTransform())
        fullname <- map["fullname"]
        avatar <- map["avatar"]
        firebaseuid <- map["firebaseuid"]
    }
}
