//
//  Feature.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 29/06/2023.
//

import Foundation
import ObjectMapper

class Feature: Mappable, Identifiable {
    var key: String?
    var title: String?
    var total: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        key <- map["key"]
        title <- map["title"]
        total <- (map["total"], transform: IntToStringTransform())
    }
}
