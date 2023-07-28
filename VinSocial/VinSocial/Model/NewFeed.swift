//
//  NewFeed.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/15/23.
//

import Foundation
import ObjectMapper
class NewFeed: Mappable, Identifiable {
    var user_info:UserInfoNewFeed?
    var postid: String?
    var catid: String?
    var layoutid: String?
    var display: String?
    var title: String?
    var linkpost: String?
    var urlshare: String?
    var content: String?
    var hometext: String?
    var bodytext: String?
    var image: String?
    var like: String?
    var list_like: [Like]?
    var commenttotal: String?
    var addtime: String?
    var contentstyle: String?
    var media:[Media]?
    var feelid: String?
    var taguser: String?
    var numlike: String?
    var numcomment: String?
    var numshare: String?
    var allowcomment: String?
    var groupid: String?
    var grouptitle: String?
    var groupbanner: String?
    var didLike: Bool? = false
    var numLikes: String? = ""
    var numComments: String? = ""
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        user_info <- map["user_info"]
        postid <- (map["postid"], transform: IntToStringTransform())
        catid <- (map["catid"], transform: IntToStringTransform())
        layoutid <- (map["layoutid"], transform: IntToStringTransform())
        display <- (map["display"], transform: IntToStringTransform())
        title <- map["title"]
        linkpost <- map["linkpost"]
        urlshare <- map["urlshare"]
        content <- map["content"]
        hometext <- map["hometext"]
        like <- (map["liked"], transform: IntToStringTransform())
        list_like <- map["list_like"]
        commenttotal <- (map["commenttotal"], transform: IntToStringTransform())
        addtime <- (map["addtime"], transform: IntToStringTransform())
        contentstyle <- map["contentstyle"]
        media <- map["media"]
        feelid <- (map["feelid"], transform: IntToStringTransform())
        taguser <- map["taguser"]
        numlike <- (map["numlike"], transform: IntToStringTransform())
        numcomment <- (map["numcomment"], transform: IntToStringTransform())
        numshare <- (map["numshare"], transform: IntToStringTransform())
        allowcomment <- (map["allowcomment"] , transform: IntToStringTransform())
        groupid <- (map["groupid"], transform: IntToStringTransform())
        grouptitle <- map["grouptitle"]
        groupbanner <- map["groupbanner"]
        bodytext <- map["bodytext"]
        image <- map["image"]
    }
}
