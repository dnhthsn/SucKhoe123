//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import UserNotifications

import GoogleSignIn
import FirebaseCore
import FirebaseMessaging
import FBSDKCoreKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  let gcmMessageIDKey = "gcm.message_id"
    static var fcmToken: String?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication
                     .LaunchOptionsKey: Any]?) -> Bool {
                         // Override point for customization after application launch.
                         GIDSignIn.sharedInstance.restorePreviousSignIn(callback: { user, error in
                             if error != nil || user == nil {
                                 // Show the app's signed-out state.
                                 print("Not sign-in")
                             }
                             else {
                                 // Show the app's signed-in state.
                                 if let user=user, let userID = user.userID {
                                     print("Already signed-in as :\(userID)")
                                 }
                             }
                         })
    FirebaseApp.configure()
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)


    // [START set_messaging_delegate]
    Messaging.messaging().delegate = self
    // [END set_messaging_delegate]

    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]

    UNUserNotificationCenter.current().delegate = self

    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )

    application.registerForRemoteNotifications()

    // [END register_for_notifications]
    print("HX application open")

    return true
  }

  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)
  }

  // [START receive_message]
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    return UIBackgroundFetchResult.newData
  }

  // [END receive_message]

  func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }

  // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
  // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
  // the FCM registration token.
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")

    // With swizzling disabled you must set the APNs token here.
    // Messaging.messaging().apnsToken = deviceToken
  }
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("HX applicationDidFinishLaunching ====")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("HX applicationWillResignActive ====")
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("HX applicationWillEnterForeground ====")

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("HX applicationDidEnterBackground ====")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("HX applicationDidBecomeActive ====")

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("HX applicationWillTerminate ====")

    }
}

// [START ios_10_message_handling]

extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    return [[.alert, .sound]]
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo
      
      // nhan notification ve khi an app
      if  userInfo["idUser"] is String && userInfo["type"] is String {
          let type = userInfo["type"] as! String
          let userID = userInfo["idUser"] as! String
          if type == "notification"{
              print("post")
              NotificationCenter.default
                  .post(name: NSNotification.Name("handle.notification"),
                        object: nil,
                        userInfo: ["value": userID])
              
          }
      }
            else{
          return
      }
  }
}

// [END ios_10_message_handling]

extension AppDelegate: MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
      print("Device id: \(UIDevice.current.identifierForVendor?.uuidString ?? "")")
      let deviceid = UIDevice.current.identifierForVendor?.uuidString ?? ""
      AuthenViewModel.shared.sendDeviceInfo(deviceid: deviceid, token: fcmToken ?? "")
    let dataDict: [String: String] = ["token": fcmToken ?? ""]
      Self.fcmToken = fcmToken
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }

  // [END refresh_token]
}
