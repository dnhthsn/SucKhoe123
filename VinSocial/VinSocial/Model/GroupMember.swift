//
//  GroupMember.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 07/06/2023.
//

import Foundation
import ObjectMapper
class GroupMember: Mappable, Identifiable {
    var userid: String?
    var fullname: String?
    var isadmin: String?
    var avatar: String?
    var firebaseuid: String?
    var text_note: String?
    var addtime: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid <- (map["userid"], transform: IntToStringTransform())
        fullname <- map["fullname"]
        isadmin <- (map["isadmin"], transform: IntToStringTransform())
        avatar <- map["avatar"]
        firebaseuid <- map["firebaseuid"]
        text_note <- map["text_note"]
        addtime <- (map["addtime"], transform: IntToStringTransform())
    }
}
