//
//  CatalogNews.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 26/05/2023.
//

import Foundation
import ObjectMapper

class CatalogNews: Mappable, Identifiable {
    var id: String?
    var title: String?
    var image: String?
    var hometext: String?
    var hitstotal: String?
    var add_time: String?
    var edit_time: String?
    var linkshare: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        title <- map["title"]
        image <- map["image"]
        hometext <- map["hometext"]
        hitstotal <- (map["hitstotal"], transform: IntToStringTransform())
        add_time <- (map["add_time"], transform: IntToStringTransform())
        edit_time <- (map["edit_time"], transform: IntToStringTransform())
        linkshare <- map["linkshare"]
    }
}
