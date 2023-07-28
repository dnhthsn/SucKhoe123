//
//  ListFunction.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 31/03/2023.
//

import Foundation
import ObjectMapper

class ListFunction: Mappable,Identifiable,Hashable {
    var id = UUID().uuidString
    var title: String?
    var act: String?
    
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        title <- map["title"]
        act <- map["act"]
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
       
    static func == (lhs: ListFunction, rhs: ListFunction) -> Bool {
           return lhs.id == rhs.id
       }

}
