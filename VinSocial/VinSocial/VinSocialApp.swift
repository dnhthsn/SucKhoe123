//
//  VinSocialApp.swift
//  VinSocial
//
//  Created by Stealer Of Souls on 3/9/23.
//

import SwiftUI
import Firebase

@main
struct VinSocialApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthenViewModel())
        }
    }
}
