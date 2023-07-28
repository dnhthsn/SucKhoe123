//
//  GroupList.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 05/06/2023.
//

import Foundation
import ObjectMapper

class GroupList: Mappable, Identifiable {
    var groupid: String?
    var title: String?
    var grouptype: String?
    var banner: String?
    var addtime: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        groupid <- (map["groupid"], transform: IntToStringTransform())
        title <- map["title"]
        grouptype <- map["grouptype"]
        banner <- map["banner"]
        addtime <- (map["addtime"], transform: IntToStringTransform())
    }
}
