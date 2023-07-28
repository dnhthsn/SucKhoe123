//
//  CatalogSearch.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/06/2023.
//

import Foundation
import ObjectMapper

class CatalogSearch: Mappable, Identifiable {
    var id: String?
    var module: String?
    var op: String?
    var title: String?
    var hometext: String?
    var image: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        module <- map["module"]
        op <- map["op"]
        title <- map["title"]
        hometext <- map["hometext"]
        image <- map["image"]
    }
}
