//
//  GroupCatalog.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 06/06/2023.
//

import Foundation
import ObjectMapper

class GroupCatalog: Mappable, Identifiable {
    var id:UUID = UUID()
    var catid: String?
    var title: String?
    var image: String?
    var description: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        catid <- (map["id"], transform: IntToStringTransform())
        title <- map["title"]
        image <- map["image"]
        description <- map["description"]
    }
}
