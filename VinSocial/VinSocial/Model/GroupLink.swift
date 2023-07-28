//
//  GroupLink.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 13/06/2023.
//

import Foundation
import ObjectMapper

class GroupLink: Mappable, Identifiable {
    var id: String?
    var title: String?
    var about: String?
    var banner: String?
    var link: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        title <- map["title"]
        about <- map["about"]
        banner <- map["banner"]
        link <- map["link"]
    }
}
