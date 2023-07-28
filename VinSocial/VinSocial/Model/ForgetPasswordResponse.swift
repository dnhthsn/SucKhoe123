//
//  ForgetPasswordResponse.swift
//  VinChat
//
//  Created by Đinh Thái Sơn on 06/04/2023.
//

import Foundation
import ObjectMapper

class ForgetPasswordResponse: Mappable, Identifiable {
    var status: String?
    var input: String?
    var step: String?
    var info: String?
    var mess: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        status <- map["status"]
        input <- map["input"]
        step <- (map["step"], transform: IntToStringTransform())
        info <- map["info"]
        mess <- map["mess"]
    }
       
}
