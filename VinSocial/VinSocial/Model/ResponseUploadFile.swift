//
//  ResponseUploadFile.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/22/23.
//

import Foundation
import Foundation
import ObjectMapper

class ResponseUploadFile: Mappable {
    var status: Int?
    var filename: String?
    var fileurl: String?
    var ext: String?
    var mime: String?
    var filesize: Int64?
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        status <- map["status"]
        filename <- map["filename"]
        fileurl <- map["fileurl"]
        ext <- map["ext"]
        mime <- map["mime"]
        filesize <- map["filesize"]
       }

}
