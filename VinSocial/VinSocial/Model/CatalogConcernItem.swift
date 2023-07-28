//
//  CatalogConcernItem.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/06/2023.
//

import Foundation
import ObjectMapper

class CatalogConcernItem: Mappable, Identifiable {
    var id: String?
    var title: String?
    var image: String?
    var hometext: String?
    var info_text: String?
    var type: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        title <- map["title"]
        image <- map["image"]
        hometext <- map["hometext"]
        info_text <- map["info_text"]
        type <- map["type"]
    }
}
