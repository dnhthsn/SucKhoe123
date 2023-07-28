//
//  SettingsCellViewModel.swift
//  Messenger
//
//  Created by Stealer Of Souls on 2/7/23.
//

import SwiftUI

enum SettingsCellViewModel: Int, CaseIterable{
    case account
    case notification
    case starredMessages
    var title:String{
        switch self{
        case .account: return "Account"
        case .notification: return "Notification"
        case .starredMessages: return "Starred Messages"
        }
    }
    
    var imageName: String{
        switch self{
        case .account: return "key.fill"
        case .notification: return "bell.badge.fill"
        case .starredMessages: return "star.fill"
        }
    }
    
    var backgroundColor: Color{
        switch self{
        case .account: return .blue
        case .notification: return .red
        case .starredMessages: return .yellow
        }
    }
}
    

