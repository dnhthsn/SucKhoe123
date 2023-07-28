//
//  GroupInfo.swift
//  Suckhoe123
//
//  Created by Đinh Thái Sơn on 16/05/2023.
//

import Foundation
import ObjectMapper

class GroupInfo: Mappable, Identifiable {
    var id: String?
    var catid: String?
    var title: String?
    var banner: String?
    var about: String?
    var membertotal: String?
    var grouptype: String?
    var addtime: String?
    var updatetime: String?
    var status: String?
    var user_info:UserInfoGroup?
    
    init(id: String, catid: String, title: String, banner: String, about: String, membertotal: String, grouptype: String, addtime: String, updatetime: String, status: String, user_info: UserInfoGroup?) {
        self.id = id
        self.catid = catid
        self.title = title
        self.banner = banner
        self.about = about
        self.membertotal = membertotal
        self.grouptype = grouptype
        self.addtime = addtime
        self.updatetime = updatetime
        self.status = status
        self.user_info = user_info
    }
    
    required init?(map: Map) {
        
    }
       
    func mapping(map: Map) {
        id <- (map["id"], transform: IntToStringTransform())
        catid <- (map["catid"], transform: IntToStringTransform())
        title <- map["title"]
        banner <- map["banner"]
        about <- map["about"]
        membertotal <- (map["membertotal"], transform: IntToStringTransform())
        grouptype <- (map["grouptype"], transform: IntToStringTransform())
        addtime <- (map["addtime"], transform: IntToStringTransform())
        updatetime <- (map["updatetime"], transform: IntToStringTransform())
        status <- (map["status"], transform: IntToStringTransform())
        user_info <- map["user_info"]
    }
}
