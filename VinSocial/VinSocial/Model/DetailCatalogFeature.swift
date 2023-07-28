//
//  DetailCatalogFeature.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 25/05/2023.
//

import Foundation
import ObjectMapper

class DetailCatalogFeature: Mappable, Identifiable {
    var key: String?
    var title: String?
    var total: Int?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        key <- map["key"]
        title <- map["title"]
        total <- map["total"]
    }
}
