//
//  ListFile.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 30/05/2023.
//

import Foundation
import ObjectMapper

class ListFile: Mappable, Identifiable {
    var id: String?
    var filename: String?
    var filetype: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        filename <- map["filename"]
        filetype <- map["filetype"]
    }
}
