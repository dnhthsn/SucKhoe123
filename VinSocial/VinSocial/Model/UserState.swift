//
//  UserState.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/16/23.
//

import Foundation
import ObjectMapper

class UserState: Mappable, Identifiable, Codable{
    var date: String?
    var state: String?
    var time: String?
    var time_long: String?
    
    init(date: String? = nil, state: String? = nil, time: String? = nil, time_long: String? = nil) {
        self.date = date
        self.state = state
        self.time = time
        self.time_long = time_long
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        state <- map["state"]
        time <- map["time"]
        time_long <- map["time_long"]
       }
}
