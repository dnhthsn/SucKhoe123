//
//  CatalogQuestion.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 29/05/2023.
//

import Foundation
import ObjectMapper

class CatalogQuestion: Mappable, Identifiable {
    var user_info: UserInfo?
    var postid: String?
    var catid: String?
    var title: String?
    var hometext: String?
    var doctor_answer: String?
    var hitstotal: String?
    var numreply: String?
    var addtime: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        user_info <- map["user_info"]
        postid <- (map["postid"], transform: IntToStringTransform())
        catid <- (map["catid"], transform: IntToStringTransform())
        title <- map["title"]
        hometext <- map["hometext"]
        doctor_answer <- map["doctor_answer"]
        hitstotal <- (map["hitstotal"], transform: IntToStringTransform())
        numreply <- (map["numreply"], transform: IntToStringTransform())
        addtime <- (map["addtime"], transform: IntToStringTransform())
    }
}
