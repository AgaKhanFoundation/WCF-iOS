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
import NotificationCenter

extension NSNotification.Name {
  static let teamChanged: NSNotification.Name =
    NSNotification.Name(rawValue: "steps4impact.team-changed")
  static let eventChanged: NSNotification.Name =
    NSNotification.Name(rawValue: "steps4impact.event-changed")
  static let commitmentChanged: NSNotification.Name =
    NSNotification.Name(rawValue: "steps4impact.commitment-changed")
}

class DashboardViewController: TableViewController {
  override func commonInit() {
    super.commonInit()

    title = Strings.Dashboard.title
    dataSource = DashboardDataSource()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: Assets.gear.image,
      style: .plain,
      target: self,
      action: #selector(settingsButtonTapped))

    // setup event handlers
    _ = NotificationCenter.default.addObserver(forName: .teamChanged,
                                               object: nil, queue: nil) { [weak self] (_) in
      self?.reload()
    }
    _ = NotificationCenter.default.addObserver(forName: .eventChanged,
                                               object: nil, queue: nil) { [weak self] (_) in
      self?.reload()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.askForPushNotificationIfNeeded()
  }
  
  private func askForPushNotificationIfNeeded() {
    let pushManager = PushNotificationManager()
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      DispatchQueue.main.async {
        if settings.authorizationStatus == .authorized {
          pushManager.updateFirestorePushTokenIfNeeded()
        }
        guard settings.authorizationStatus == .notDetermined else {
          return
        }
        let controller = UIAlertController(
          title: Strings.NotificationsPermission.title,
          message: Strings.NotificationsPermission.message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(
          title: Strings.NotificationsPermission.proceed, style: .default,
          handler: { (_) in
            pushManager.registerForPushNotifications()
        }))
        controller.addAction(UIAlertAction(
          title: Strings.NotificationsPermission.cancel,
          style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
      }
    }
    
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    if let cell = cell as? ProfileCardCell {
      cell.delegate = self
    }
    if let cell = cell as? EmptyActivityCell {
      cell.delegate = self
    }
    if let cell = cell as? DisclosureCell {
      cell.delegate = self
    }
  }

  // MARK: - Actions

  @objc
  func settingsButtonTapped() {
    navigationController?.pushViewController(SettingsViewController(), animated: true)
  }
}

extension DashboardViewController: ProfileCardCellDelegate {
  func profileDisclosureTapped() {
    let badgeVC = BadgesCollectionViewController()
    navigationController?.pushViewController(badgeVC, animated: true)
  }
}

extension DashboardViewController: EmptyActivityCellDelegate {
  func emptyActivityCellConnectTapped() {
    navigationController?.pushViewController(ConnectSourceViewController(),
                                             animated: true)
  }
}

extension DashboardViewController: DisclosureCellDelegate {
  func disclosureCellTapped(context: Context?) {
    guard let context = context as? DashboardDataSource.DashboardContext else { return }
    switch context {
    case .inviteSupporters:
      navigationController?.pushViewController(InviteSupportersViewController(), animated: true)
    }
  }
}
