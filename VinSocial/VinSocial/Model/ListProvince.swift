//
//  ListProvince.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 02/06/2023.
//

import Foundation
import ObjectMapper

class ListProvince: Mappable, Identifiable {
    var id: String?
    var code: String?
    var title: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        code <- map["code"]
        title <- map["title"]
    }
}
