//
//  ListAnswer.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 30/05/2023.
//

import Foundation
import ObjectMapper

class ListAnswer: Mappable, Identifiable {
    var user_info: UserInfo?
    var repid: String?
    var title: String?
    var content: String?
    var addtime: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        user_info <- map["user_info"]
        repid <- (map["repid"], transform: IntToStringTransform())
        title <- map["title"]
        content <- map["content"]
        addtime <- (map["addtime"], transform: IntToStringTransform())
    }
}
