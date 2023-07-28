//
//  Media.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/15/23.
//

import Foundation
import ObjectMapper
class Media: Mappable,Hashable, Identifiable {
    var id:String?
    var media_url: String?
    var media_type: String?
    var media_thumb: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        media_url <- map["media_url"]
        media_type <- map["media_type"]
        media_thumb <- map["media_thumb"]
    }
    func hash(into hasher: inout Hasher) {
           hasher.combine(media_url)
       }
       
    static func == (lhs: Media, rhs: Media) -> Bool {
           return lhs.media_url == rhs.media_url
       }
}
