//
//  CatalogVideo.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 02/06/2023.
//

import Foundation
import ObjectMapper

class CatalogVideo: Mappable, Identifiable {
    var id:UUID = UUID()
    var user_info: UserInfo?
    var postid: String?
    var catid: String?
    var title: String?
    var image: String?
    var linkshare: String?
    var urlvideo: String?
    var videotype: String?
    var hometext: String?
    var hitstotal: String?
    var commenttotal: String?
    var addtime: String?
    
    init(postid:String?,image:String?){
        
    }
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        user_info <- map["user_info"]
        postid <- (map["postid"], transform: IntToStringTransform())
        catid <- (map["catid"], transform: IntToStringTransform())
        title <- map["title"]
        image <- map["image"]
        linkshare <- map["linkshare"]
        urlvideo <- map["urlvideo"]
        videotype <- map["videotype"]
        hometext <- map["hometext"]
        hitstotal <- (map["hitstotal"], transform: IntToStringTransform())
        commenttotal <- (map["commenttotal"], transform: IntToStringTransform())
        addtime <- (map["addtime"], transform: IntToStringTransform())
    }
}
