//
//  MediaUser.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 22/05/2023.
//

import Foundation
import ObjectMapper

class MediaUser: Mappable, Identifiable {
    var id:UUID = UUID()
    var idMedia: String?
    var title: String?
    var content: String?
    var filename: String = ""
    var filetype: String?
    
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        idMedia <- (map["id"], transform: IntToStringTransform())
        title <- map["title"]
        content <- map["content"]
        filename <- map["filename"]
        filetype <- map["filetype"]
    }
}
