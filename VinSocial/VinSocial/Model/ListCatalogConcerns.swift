//
//  ListCatalogConcerns.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 24/05/2023.
//

import Foundation
import ObjectMapper

class ListCatalogConcerns: Mappable, Identifiable {
    var id: String?
    var title: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        title <- map["title"]
    }
}
