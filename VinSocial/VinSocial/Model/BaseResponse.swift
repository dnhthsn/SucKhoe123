//
//  BaseResponse.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/11/23.
//

import Foundation
import ObjectMapper

class BaseResponse<T: Mappable> :Mappable {
    var message: String?
    var status: Int?
    var status1: String?
    var data: T?
    var mess: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        status1 <- map["status"]
        data <- map["data"]
        mess <- map["mess"]
    }
       
}

class ResponseRegister<T: Mappable> :BaseResponse<T> {
    var input: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        input <- map["input"]
    }

}

class ResponseEditInfo<T: Mappable> :BaseResponse<T> {
    var input: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        input <- map["input"]
    }
       
}

class ResponseGroup<T: Mappable> :BaseResponse<T> {
    var groupid: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
            groupid <- map["groupid"]
       }
       
}

class BaseResponseMakeFriend: Mappable {
    var status: Int?
    var mess: String?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
           
        status <- map["status"]
        mess <- map["mess"]
    }
       
}

class ResponseLikePost<T: Mappable> :BaseResponse<T> {
    var totallike: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        totallike <- (map["totallike"], transform: IntToStringTransform())
    }
       
}

