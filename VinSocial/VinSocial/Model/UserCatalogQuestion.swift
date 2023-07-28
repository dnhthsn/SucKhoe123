//
//  UserCatalogQuestion.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 02/06/2023.
//

import Foundation
import ObjectMapper

class UserCatalogQuestion: Mappable, Identifiable {
    var postid: String?
    var catid: String?
    var title: String?
    var content: String?
    var linkpost: String?
    var listfile: ListFile?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        postid <- (map["postid"], transform: IntToStringTransform())
        catid <- (map["catid"], transform: IntToStringTransform())
        title <- map["title"]
        content <- map["content"]
        linkpost <- map["linkpost"]
        listfile <- map["listfile"]
    }
}
