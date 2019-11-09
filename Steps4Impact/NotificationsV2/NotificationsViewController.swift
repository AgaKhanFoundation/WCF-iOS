/**
 * Copyright © 2019 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

import UIKit

class NotificationsViewController: TableViewController {
  private lazy var plistURL: URL? = {
    do {
      var documentURL = try FileManager.default.url(
        for: .documentDirectory, in: .userDomainMask,
        appropriateFor: nil, create: false)
      return documentURL.appendingPathComponent("notifications.plist")
    } catch {
      print(error)
    }
    return nil
  }()

  override func commonInit() {
    super.commonInit()

    title = Strings.Notifications.title
    dataSource = NotificationsDataSource()
    fetchSavedNotifications()

    _ = NotificationCenter.default.addObserver(
    forName: .receivedNotification, object: nil, queue: nil) { [weak self] (notification) in
      self?.didReceive(notification: notification.userInfo)
    }
  }

  private func didReceive(notification userInfo: [AnyHashable: Any]?) {
    guard let aps = userInfo?["aps"] as? [AnyHashable: Any],
      let alert = aps["alert"] as? [AnyHashable: Any],
      let title = alert["title"] as? String,
      let body = alert["body"] as? String else { return }
    guard let dataSource = dataSource as? NotificationsDataSource else { return }
    let notification = NotificationV2(title: title, body: body)
    dataSource.notifications.insert(notification, at: 0)
    saveToPlist(notification: notification)
    reload()
  }

  private func readFromPlist() -> [NotificationV2] {
    guard let plistURL = plistURL else { return [] }
    var plistData: [String]?
    do {
      let data = try Data(contentsOf: plistURL)
      plistData = try PropertyListSerialization.propertyList(
        from: data, format: nil) as? [String]
    } catch {
      print("Error reading plist: ", error)
    }
    guard let data = plistData else { return [] }
    return data.compactMap { return NotificationV2.instance(from: $0) }
  }

  private func saveToPlist(notification: NotificationV2) {
    guard let plistURL = plistURL, let dataSource = dataSource as? NotificationsDataSource else { return }
    do {
      let plistData = try PropertyListSerialization.data(
        fromPropertyList: dataSource.notifications.compactMap { $0.jsonString() },
        format: .xml, options: 0)
      try plistData.write(to: plistURL)
    } catch {
      print("Error writing plist: ", error)
    }
  }

  private func fetchSavedNotifications() {
    guard let dataSource = dataSource as? NotificationsDataSource else { return }
    dataSource.notifications = readFromPlist()
    reload()
  }
}

struct NotificationV2: Codable {
  var title: String
  var body: String

  func jsonString() -> String? {
    let jsonEncoder = JSONEncoder()
    do {
      let object = try jsonEncoder.encode(self)
      return String(data: object, encoding: .utf8)
    } catch {
      return nil
    }
  }

  static func instance(from jsonString: String) -> NotificationV2? {
    let jsonDecoder = JSONDecoder()
    guard let jsonData = jsonString.data(using: .utf8) else { return nil }
    do {
      return try jsonDecoder.decode(NotificationV2.self, from: jsonData)
    } catch {
      return nil
    }
  }
}

class NotificationsDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []
  var notifications = [NotificationV2]()

  func configure() {
    guard notifications.count > 0 else {
      configureNoNotificationCells()
      return
    }
    var notificationCells = [InfoCellContext]()
    for notification in notifications {
      notificationCells.append(
        InfoCellContext(title: notification.title, body: notification.body)
      )
    }
    cells = [notificationCells]
  }

  private func configureNoNotificationCells() {
    cells = [[
      InfoCellContext(
        title: Strings.Notifications.title,
        body: Strings.Notifications.youHaveNoNotifications)
      ]]
  }
}
