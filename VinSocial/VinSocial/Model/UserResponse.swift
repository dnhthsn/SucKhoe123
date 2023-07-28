//
//  DataResponse.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/10/23.
//

import Foundation
import ObjectMapper

class UserResponse: Mappable, Identifiable {
    var userid: String?
    var fullname: String?
    var verify: String?
    var isdoctor: Int?
    var username: String?
    var email: String?
    var photo: String?
    var gender: String?
    var birthday: String?
    var address: String?
    var mobile: String?
    var education: String?
    var working: String?
    var description: String?
    var checknum: String?
    var checknum2: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid <- (map["userid"], transform: IntToStringTransform())
        fullname <- map["fullname"]
        verify <- map["verify"]
        isdoctor <- map["isdoctor"]
        username <- map["username"]
        email <- map["email"]
        photo <- map["photo"]
        gender <- map["gender"]
        birthday <- map["birthday"]
        address <- map["address"]
        mobile <- map["mobile"]
        education <- map["education"]
        working <- map["working"]
        description <- map["description"]
        checknum <- map["checknum"]
        checknum2 <- map["checknum2"]
    }

}
