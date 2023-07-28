//
//  CatalogQuestionDetail.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 30/05/2023.
//

import Foundation
import ObjectMapper

class CatalogQuestionDetail: Mappable, Identifiable {
    var user_info: UserInfo?
    var postid: String?
    var catid: String?
    var title: String?
    var linkpost: String?
    var content: String?
    var description: String?
    var hometext: String?
    var listfile: [ListFile]?
    var numreply: String?
    var hitstotal: String?
    var addtime: String?
    var listanswer: [ListAnswer]?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        user_info <- map["user_info"]
        postid <- (map["postid"], transform: IntToStringTransform())
        catid <- (map["catid"], transform: IntToStringTransform())
        title <- map["title"]
        linkpost <- map["linkpost"]
        content <- map["content"]
        description <- map["description"]
        hometext <- map["hometext"]
        listfile <- map["listfile"]
        numreply <- (map["numreply"], transform: IntToStringTransform())
        hitstotal <- (map["hitstotal"], transform: IntToStringTransform())
        addtime <- (map["addtime"], transform: IntToStringTransform())
        listanswer <- map["listanswer"]
    }
}
