//
//  Like.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/22/23.
//

import Foundation
import ObjectMapper
class Like: Mappable, Identifiable {
    var fullname: String?
    var photo: String?
    var firebaseuid: String?
    var addtime: String?
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        fullname <- map["fullname"]
        photo <- map["photo"]
        firebaseuid <- map["firebaseuid"]
        addtime <- (map["addtime"], transform: IntToStringTransform())
    }
}
