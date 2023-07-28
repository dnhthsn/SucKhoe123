//
//  NewFeedForCatalog.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 4/4/23.
//

import Foundation
import ObjectMapper
class NewFeedForCatalog: Mappable {
    var currentPage:Int = 0
    var hasEndReach:Bool = false
    var newFeeds: [NewFeed]?
    var catId:Int = 0
    var catTitle:String = ""
    
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        currentPage <- map["currentPage"]
        hasEndReach <- map["hasEndReach"]
        newFeeds <- map["newFeeds"]
        catId <- map["catId"]
        catTitle <- map["catTitle"]
    }
    
}
