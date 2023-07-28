//
//  UserObject.swift
//  Messenger
//
//  Created by Stealer Of Souls on 3/1/23.
//

import Foundation
struct UserObject:Identifiable {
    var id: String?
    var userFirebase: UserFirebase
    var isSelected: Bool = false
    
    init(id: String? = nil, userFirebase: UserFirebase) {
        self.id = id
        self.userFirebase = userFirebase
    }
}

