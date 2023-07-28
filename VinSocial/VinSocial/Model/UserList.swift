//
//  UserList.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/13/23.
//

import Foundation
import ObjectMapper

class UserList: Mappable{
    var userid: Int?
    var fullname: String?
    var username: String?
    var firs_name: String?
    var last_name: String?
    var gender: String?
    var birthday: String?
    var firebaseuid: String?
    var photo: String?
    var email: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid <- map["userid"]
        fullname <- map["fullname"]
        username <- map["username"]
        email <- map["email"]
        photo <- map["photo"]
        firs_name <- map["firs_name"]
        last_name <- map["last_name"]
        gender <- map["gender"]
        birthday <- map["birthday"]
        firebaseuid <- map["firebaseuid"]
       }
}
