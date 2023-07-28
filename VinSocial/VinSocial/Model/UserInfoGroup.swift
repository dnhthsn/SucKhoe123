//
//  UserInfoGroup.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 16/05/2023.
//
import Foundation
import ObjectMapper
class UserInfoGroup: Mappable {
    var isadmin: String?
    var access: String?
    var status: String?
    var status_text: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        isadmin <- (map["isadmin"], transform: IntToStringTransform())
        access <- map["access"]
        status <- map["status"]
        status_text <- map["status_text"]
    }
}
