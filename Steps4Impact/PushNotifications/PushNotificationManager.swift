//
//  PushNotificationsManager.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 5/9/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class PushNotificationManager: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
  
  static let shared = PushNotificationManager()
  private override init() {}
  
  let gcmMessageIDKey = "gcm.message_id"
  func registerForPushNotifications() {
    // For iOS 10 display notification (sent via APNS)
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    // For iOS 10 data message (sent via FCM)
    Messaging.messaging().delegate = self
    UIApplication.shared.registerForRemoteNotifications()
    updateFirestorePushTokenIfNeeded()
  }
  
  func updateFirestorePushTokenIfNeeded() {
    guard let fcmToken = Messaging.messaging().fcmToken else { return }
    
    AKFCausesService.getFCMToken(fbId: User.id) { (result) in
      if result.isSuccess {
        if let responseToken = result.response?["fcm_token"]?.stringValue, responseToken != fcmToken {
          AKFCausesService.setFCMToken(fbId: User.id, token: fcmToken) { (result) in
            print(result)
          }
        }
        return
      }
      AKFCausesService.createFCMToken(fbId: User.id, token: fcmToken) { (result) in
        print(result)
      }
    }
  }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
      
    updateFirestorePushTokenIfNeeded()
  }
  
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    // Change this to your preferred presentation option
    completionHandler([.alert])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    completionHandler()
  }
}
