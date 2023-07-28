//
//  Catalog.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 24/03/2023.
//

import Foundation
import ObjectMapper
class Catalog: Mappable, Identifiable {
    var groupid: String?
    var grouptitle: String?
    var image: String?
    var subcatalog:[SubCatalog]?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        groupid <- (map["groupid"], transform: IntToStringTransform())
        grouptitle <- map["grouptitle"]
        image <- map["image"]
        subcatalog <- map["subcatalog"]
    }
}
