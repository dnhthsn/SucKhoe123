//
//  SubCatalogContent.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 24/03/2023.
//

import Foundation
import ObjectMapper
class SubCatalogContent: Mappable,Hashable,Identifiable {
    var id: Int?
    var title: String?
    var image: String?
    var hometext: String?
    var info_text: String?
    var type: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        image <- map["image"]
        hometext <- map["hometext"]
        info_text <- map["info_text"]
        type <- map["type"]
    }
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
       
    static func == (lhs: SubCatalogContent, rhs: SubCatalogContent) -> Bool {
           return lhs.id == rhs.id
       }
}
