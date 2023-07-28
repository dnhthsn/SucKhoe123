//
//  CatalogNewsDetail.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 29/05/2023.
//

import Foundation
import ObjectMapper

class CatalogNewsDetail: Mappable, Identifiable {
    var user_info: UserInfo?
    var postid: String?
    var catid: String?
    var title: String?
    var linkpost: String?
    var image: String?
    var description: String?
    var hometext: String?
    var bodytext: String?
    var hitstotal: String?
    var commenttotal: String?
    var addtime: String?
    var edittime: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        user_info <- map["user_info"]
        postid <- (map["postid"], transform: IntToStringTransform())
        catid <- (map["catid"], transform: IntToStringTransform())
        title <- map["title"]
        linkpost <- map["linkpost"]
        image <- map["image"]
        description <- map["description"]
        hometext <- map["hometext"]
        bodytext <- map["bodytext"]
        hitstotal <- (map["hitstotal"], transform: IntToStringTransform())
        commenttotal <- (map["commenttotal"], transform: IntToStringTransform())
        addtime <- (map["addtime"], transform: IntToStringTransform())
        edittime <- (map["edittime"], transform: IntToStringTransform())
    }
}
