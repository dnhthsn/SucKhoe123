//
//  BaseListCommentResponse.swift
//  VinSocial
//
//  Created by Đinh Thái Sơn on 18/04/2023.
//

import Foundation
import ObjectMapper

class CommentsModel<T: Mappable> :Mappable {
    var comment:[T]?
    var num_items: String?
    
    //Dùng để lưu lại trạng thái xem load đến page bao nhiêu rồi
    var currentPage:Int = 0
    var hasReachedEnd:Bool = false
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        comment <- map["comment"]
        num_items <- (map["num_items"], transform: IntToStringTransform())
        currentPage <- map["currentPage"]
        hasReachedEnd <- map["hasReachedEnd"]
    }
       
}
