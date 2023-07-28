//
//  Constants.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import Foundation
import Firebase
import FirebaseDatabase
let COLLECTION_USER = Firestore.firestore().collection("users")
let COLLECTION_MESSAGER = Firestore.firestore().collection("messages")
let COLLECTION_CONVERSATION = Database.database().reference().child("suckhoe123chat")
let stringURL = "https://ws.suckhoe123.vn/themes/default/images/users/no_avatar.png"
let encoder = JSONEncoder()
let decoder = JSONDecoder()
let cacheSave = NSCache<NSString,NSData>()
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

extension Array where Element: Hashable {
    func uniquelements() -> Array {
        var temp = Array()
        var s = Set<Element>()
        for i in self {
            if !s.contains(i) {
                temp.append(i)
                s.insert(i)
            }
        }
        return temp
    }
}
