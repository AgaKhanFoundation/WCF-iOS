//
//  Notification.swift
//  Steps4Impact
//
//  Created by Faisal Ali on 1/21/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import UIKit

struct Notification {
  let identifier: Int
  let notificationId: Int
  let message: String
  let messageDate: Date
  let priority: Int
  let eventId: Int
  let expiryDate: Date
  var readFlag: Bool

  init?(json: JSON?) {
    guard let json = json else { return nil }
    guard let identifier = json["id"]?.intValue,
      let notificationId = json["notification_id"]?.intValue,
      let message = json["message"]?.stringValue,
      let priority = json["priority"]?.intValue,
      let eventId = json["event_id"]?.intValue,
      let readFlag = json["read_flag"]?.boolVaue,
      let messageDateStr = json["message_date"]?.stringValue,
      let expiryDateStr = json["expiry_date"]?.stringValue else { return nil }
    let dateFormatter = ISO8601DateFormatter()
    guard let messageDate = dateFormatter.date(from: messageDateStr),
      let expiryDate = dateFormatter.date(from: expiryDateStr) else { return nil }
    self.identifier = identifier
    self.notificationId = notificationId
    self.message = message
    self.messageDate = messageDate
    self.priority = priority
    self.eventId = eventId
    self.expiryDate = expiryDate
    self.readFlag = readFlag
  }

  var formattedMessageDate: String {
    let difference = Date().timeIntervalSince(messageDate)
    switch difference {
    case 0..<60:
      return "Now"
    case 60..<3600:
      return "\(Int(difference)/60)m"
    case 3600..<86400:
      return "\(Int(difference)/3600)h"
    case 86400..<604800:
      return "\(Int(difference)/86400)d"
    default:
      return "\(Int(difference)/604800)w"
    }
  }

  var backgroundColor: UIColor {
    return readFlag ? .read : .unread
  }

  var context: NotificationContext {
    return readFlag ? .none : .markRead(identifier: identifier)
  }
}
