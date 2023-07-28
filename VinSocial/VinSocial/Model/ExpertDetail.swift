//
//  ExpertDetail.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 29/06/2023.
//

import Foundation
import ObjectMapper

class ExpertDetail: Mappable, Identifiable {
    var fullname: String?
    var email: String?
    var phone: String?
    var address: String?
    var avatar: String?
    var feature: [Feature]?
    
    required init?(map: Map) {
        
    }
    
    init(fullname:String?,avatar:String?){
        
    }
    
    func mapping(map: Map) {
        fullname <- map["fullname"]
        email <- map["email"]
        phone <- map["phone"]
        address <- map["address"]
        avatar <- map["avatar"]
        feature <- map["feature"]
    }
}
