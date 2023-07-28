//
//  UserInfoRes.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 30/03/2023.
//

import Foundation
import ObjectMapper

class UserInfoRes: Mappable,Identifiable {
    var fullname: String?
    var verify: String?
    var isdoctor: Int?
    var avatar: String?
    var gender: String?
    var birthday: String?
    var address: String?
    var mobile: String?
    var education: String?
    var working: String?
    var description: String?
    var list_function: [ListFunction]?
    
    init(fullname:String?,avatar:String?){
        
    }
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        fullname <- map["fullname"]
        verify <- map["verify"]
        isdoctor <- map["isdoctor"]
        avatar <- map["avatar"]
        gender <- map["gender"]
        birthday <- map["birthday"]
        address <- map["address"]
        mobile <- map["mobile"]
        education <- map["education"]
        working <- map["working"]
        description <- map["description"]
        list_function <- map["list_function"]
    }

}
