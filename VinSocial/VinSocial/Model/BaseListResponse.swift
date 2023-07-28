//
//  BaseListResponse.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/27/23.
//

import Foundation
import Foundation
import ObjectMapper
//Có 2 cách viết. 1: viết tất cả các thuộc tính có thể có ở cục bên ngoài gồm: message, mess,status,data,numtotal,numgroup....
//Zô thằng base -> vì khai báo thuộc tính ? có thể nil. nếu api nào không có thì nó sẽ nil.
//Cách này viết gắn gọn nhưng không đúng tư duy của OOP cho lắm.
//Cách 2 app dụng kế thừa ->Những cái gì chung thì cho vào base. Sau đó thằng con kế thừa lại.
// tính chất kế thừa là gì?
class BaseListResponse<T: Mappable> :Mappable {
    var message: String?
    var status: Int?
    var data: [T]?
    var mess: String?
    //Dùng để lưu lại trạng thái xem load đến page bao nhiêu rồi
    var currentPage:Int = 0
    var hasReachedEnd:Bool = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        mess <- map["mess"]
        currentPage <- map["currentPage"]
        hasReachedEnd <- map["hasReachedEnd"]
        data <- map["data"]
    }
       
}

class ListResponseCatalogDoctor<T: Mappable>:BaseListResponse<T>{
    var numtotal: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        numtotal <- map["numtotal"]
    }
}

//DTO
class GroupListResponse :BaseListResponse<GroupList>{
    var numgroup: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        numgroup <- map["numgroup"]
    }
}

class ListResponseFriend: BaseListResponse<ListFriend> {
    var numfriend: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        numfriend <- map["numfriend"]
    }
}

class ResponseMediaUser<T: Mappable> :BaseListResponse<T> {
    var numitems: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        numitems <- map["numitems"]
    }
       
}

class ResponsePostGroupComment<T: Mappable> : BaseListResponse<T> {
    var content: String?
    var image: String?
    var edit: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        content <- map["content"]
        image <- map["image"]
        edit <- map["edit"]
    }
}

class ResponseSearchCatalog<T: Mappable> : BaseListResponse<T> {
    var datatotal: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        datatotal <- map["datatotal"]
    }
}
