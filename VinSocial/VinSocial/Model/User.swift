//
//  User.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable{
    @DocumentID var id:String?
    let email:String
    let fullName:String
    let profileImageUrl:String
    let userName:String
    
}

