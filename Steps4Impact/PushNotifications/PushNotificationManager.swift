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
  
  let gcmMessageIDKey = "gcm.message_id"
  func registerForPushNotifications() {
    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: {_, _ in })
      // For iOS 10 data message (sent via FCM)
      Messaging.messaging().delegate = self
    } else {
      let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      UIApplication.shared.registerUserNotificationSettings(settings)
    }
    UIApplication.shared.registerForRemoteNotifications()
    updateFirestorePushTokenIfNeeded()
  }
  
  func updateFirestorePushTokenIfNeeded() {
    guard let fcmToken = Messaging.messaging().fcmToken else { return }
    
    AKFCausesService.getFCMToken(fbId: Facebook.id) { (result) in
      if result.isSuccess {
        // TODO: check FCM Token, if different then call PATCH
        AKFCausesService.setFCMToken(fbId: Facebook.id, token: fcmToken) { (result) in
          print(result)
        }
        return
      }
      AKFCausesService.createFCMToken(fbId: Facebook.id, token: fcmToken) { (result) in
        print(result)
      }
    }
  }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
      
    updateFirestorePushTokenIfNeeded()
  }
  
  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    print("Message Date: ", remoteMessage.appData)
  }
  
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    
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
