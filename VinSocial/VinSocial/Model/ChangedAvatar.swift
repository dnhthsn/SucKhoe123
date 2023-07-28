//
//  ChangedAvatar.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 23/06/2023.
//

import Foundation
import ObjectMapper

class ChangedAvatar: Mappable {
    var avatar: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        avatar <- map["avatar"]
    }

}

