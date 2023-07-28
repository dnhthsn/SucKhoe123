//
//  VideoFeedModel.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 4/3/23.
//

import Foundation
import ObjectMapper
class VideoFeedModel :Mappable{
    var message: String?
    var status: Int?
    var data: [NewFeed]?
    var listcatalog: [ListCatalog]?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        message <- map["mess"]
        status <- map["status"]
        data <- map["data"]
        listcatalog <- map["listcatalog"]
    }
}
