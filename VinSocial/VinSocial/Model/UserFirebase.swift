//
//  UserFirebase.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/16/23.
//

import Foundation

class UserFirebase: Identifiable, Codable {
    var full_name: String?
    var image: String?
    var uid: String?
    var userId: String?
    var userState: UserState?
}
