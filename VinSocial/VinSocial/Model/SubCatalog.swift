//
//  SubCatalog.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 24/03/2023.
//

import Foundation
import ObjectMapper
class SubCatalog: Mappable,Hashable,Identifiable {
    var catalogid: String?
    var title: String?
    var image: String?
    
    init(catalogid:String?,title:String?){
        
    }
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        catalogid <- (map["id"], transform: IntToStringTransform())
        title <- map["title"]
        image <- map["image"]
    }
    func hash(into hasher: inout Hasher) {
           hasher.combine(catalogid)
       }
       
    static func == (lhs: SubCatalog, rhs: SubCatalog) -> Bool {
           return lhs.catalogid == rhs.catalogid
       }
}
