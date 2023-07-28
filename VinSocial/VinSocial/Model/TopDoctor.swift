//
//  TopDoctor.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 23/05/2023.
//

import Foundation
import ObjectMapper

class TopDoctor: Mappable, Identifiable {
    var userid: String?
    var fullname: String?
    var avatar: String?
    var clinic_name: String?
    var firebaseuid: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        userid <- (map["userid"], transform: IntToStringTransform())
        fullname <- map["fullname"]
        avatar <- map["avatar"]
        clinic_name <- map["clinic_name"]
        firebaseuid <- map["firebaseuid"]
    }
}
