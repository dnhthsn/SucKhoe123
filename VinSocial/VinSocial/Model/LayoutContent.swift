//
//  LayoutContent.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 14/07/2023.
//

import Foundation
import ObjectMapper

class LayoutContent: Mappable, Identifiable {
    var id: String?
    var title: String?
    var image: String?
    var hidebox: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        title <- map["title"]
        image <- map["image"]
        hidebox <- map["hidebox"]
    }
}
