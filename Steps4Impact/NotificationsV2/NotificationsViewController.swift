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
import RxSwift

class NotificationsViewController: TableViewController {
  override func commonInit() {
    super.commonInit()
    title = Strings.Notifications.title
    dataSource = NotificationsDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Check the notification permission and then add or remove the persmission cell from tableView if needed.
    if let dataSource = dataSource as? NotificationsDataSource {
      dataSource.handleNotificationPermissionCell { [weak self] (shouldReload) in
        if shouldReload {
          self?.tableView.reloadOnMain()
        }
      }
    }
  }
  
  override func reload() {
    dataSource?.reload { [weak self] in
      self?.tableView.reloadOnMain()
    }
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    if let cell = cell as? NotificationPermissionCell {
      cell.delegate = self
    }
  }
}

class NotificationsDataSource: TableViewDataSource {
  let cache = Cache.shared
  var cells: [[CellContext]] = []
  var disposeBag = DisposeBag()
  
  let notificationPermissionCellContext = NotificationPermissionCellContext(title: Strings.NotificationsPermission.title,
                                                                            description: Strings.NotificationsPermission.message,
                                                                            disclosureText: Strings.NotificationsPermission.discloreText)
  
  init() {
    cache.participantRelay.subscribeOnNext { [weak self] (participant: Participant?) in
      guard let fbId = participant?.fbid, let eventId = participant?.currentEvent?.id else { return }
      
      AKFCausesService.getNotifications(fbId: fbId, eventId: eventId) { (result) in
        self?.configure()
      }
    }.disposed(by: disposeBag)
  }
  
  func reload(completion: @escaping () -> Void) {
    configure()
    completion()
  }
  
  func handleNotificationPermissionCell(completion: ((Bool) -> Void)?) {
    // Checking if notification permission cell is already included in the cells array
    if let firstCell = cells.first, firstCell is [NotificationPermissionCellContext] {
      // Check if user is registered for remote notifications
      if UIApplication.shared.isRegisteredForRemoteNotifications {
        // remove the permission cell as the user has registered for push notification
        cells.remove(at: 0)
        completion?(true)
      }
    } else if !UIApplication.shared.isRegisteredForRemoteNotifications, canShowPrompt() {
      cells.insert([notificationPermissionCellContext], at: 0)
      completion?(true)
    }
    completion?(false)
  }
  
  func canShowPrompt() -> Bool {
    if let waitingDate = UserInfo.waitingDate {
      let currentDate = Date()
      if currentDate.compare(waitingDate) == .orderedAscending {
        return false
      }
    }
    return true
  }
  
  func configure() {
    cells = [[]]
    if !UIApplication.shared.isRegisteredForRemoteNotifications, canShowPrompt() {
      self.cells.insert([notificationPermissionCellContext], at: 0)
    }
  }
  
  private func testData() -> [NotificationCellInfo] {
    [
      NotificationCellInfo(title: "FirstName LastName has joined your team",
                           date: Date(), isRead: false, isFirst: true),
      NotificationCellInfo(title: "You have been removed from [Team Name] Team.",
                           date: Date(timeIntervalSinceNow: -10*60), isRead: false),
      NotificationCellInfo(title: "Challenge [name of challenge] has ended.",
                           date: Date(timeIntervalSinceNow: -1*60*60)),
      NotificationCellInfo(title: "FirstName LastName has joined the team.",
                           date: Date(timeIntervalSinceNow: -1*24*60*60)),
      NotificationCellInfo(title: "Abigal Gates is going to Nike run club with 80 others.",
                           date: Date(timeIntervalSinceNow: -7*24*60*60)),
      NotificationCellInfo(title: "Last notification from long ago",
                           date: Date(timeIntervalSinceNow: -35*24*60*60)),
      NotificationCellInfo(title: "Notification from so long ago",
                           date: Date(timeIntervalSinceNow: -100*24*60*60), isLast: true)
    ]
  }
}
extension NotificationsViewController: NotificationPermissionCellDelegate {
  func turnOnNotifictions() {
     guard let url = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    
    UIApplication.shared.open(url, options: [:]) { (success) in
      guard !success else {
        return
      }
    }
  }
  
  func close() {
    if let firstCell = dataSource?.cells.first, firstCell is [NotificationPermissionCellContext] {
      let currentDate = Date()
      let calendar = Calendar.current

      // add 1 day to the date:
      if let newDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
        UserInfo.waitingDate = newDate
      }
      dataSource?.cells.remove(at: 0)
      tableView.reloadOnMain()
    }
  }
}
