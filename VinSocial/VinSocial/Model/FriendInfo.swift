//
//  FriendInfo.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 31/05/2023.
//

import Foundation
import ObjectMapper
class FriendInfo: Mappable {
    var isfriend: String?
    var follow: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        isfriend <- (map["isfriend"], transform: IntToStringTransform())
        follow <- (map["follow"], transform: IntToStringTransform())
    }
}
