//
//  DetailCatalog.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 25/05/2023.
//

import Foundation
import ObjectMapper

class DetailCatalog: Mappable, Identifiable {
    var catid: String?
    var title: String?
    var feature: [DetailCatalogFeature]?
    var content: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        catid <- (map["catid"], transform: IntToStringTransform())
        title <- map["title"]
        feature <- map["feature"]
        content <- map["content"]
    }
}
