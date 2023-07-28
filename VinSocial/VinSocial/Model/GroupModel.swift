//
//  Group.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 16/05/2023.
//

import Foundation

import ObjectMapper
class GroupModel: Mappable, Identifiable {
    var groupid: String?
    
    init(groupid: String){
        self.groupid = groupid
    }
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        groupid <- (map["groupid"], transform: IntToStringTransform())
    }
}
