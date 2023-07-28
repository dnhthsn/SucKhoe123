//
//  ListCatalog.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 4/3/23.
//

import Foundation
import ObjectMapper
class ListCatalog: Mappable{
    var id = UUID().uuidString
    var catid: String?
    var title: String?
    var total: String = "0"
    
    required init?(map: Map) {
        
    }
    
    init(catid: String,title: String,total:String){
        self.catid = catid
        self.title = title
        self.total = total
    }
       
    func mapping(map: Map) {
        catid <- (map["catid"], transform: IntToStringTransform())
        title <- map["title"]
        total <- map["total"]
    }
    
//    func hash(into hasher: inout Hasher) {
//           hasher.combine(id)
//       }
//       
//    static func == (lhs: ListCatalog, rhs: ListCatalog) -> Bool {
//           return lhs.id == rhs.id
//       }
    
}
