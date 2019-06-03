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
import Foundation
import SnapKit

class NotificationView : UITableViewCell {
  static let identifier: String = "NotificationCell"

  private var lblMessage: UILabel =
      UILabel(typography: .subtitleRegular, color: Style.Colors.FoundationGrey)
  private var lblDate: UILabel =
      UILabel(typography: .footnote, color: Style.Colors.Silver)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    self.backgroundColor = Style.Colors.green

    self.addSubview(lblMessage)
    lblMessage.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Style.Padding.p8)
      $0.left.right.equalToSuperview().inset(Style.Padding.p40)
    }

    self.addSubview(lblDate)
    lblDate.snp.makeConstraints {
      $0.left.equalTo(lblMessage)
      $0.top.equalTo(lblMessage.snp.bottom).offset(Style.Padding.p4)
      $0.bottom.equalToSuperview().inset(Style.Padding.p8)
    }
  }

  func render(_ context: Any) {
    guard let data = context as? Notification else { return }
    lblMessage.text = data.message
    // FIXME(compnerd) render this according to the UX style
    lblDate.text = data.date.description
  }
}

struct Notification {
  var renderer: String { return NotificationView.identifier }

  var date: Date
  var message: String
}

class Notifications: UIViewController {
  private let lblTitle: UILabel = UILabel(typography: .headerTitle)
  private let tblNotifications: UITableView = UITableView(frame: .zero)
  private let uvwNotificationsBackground: UIView = UIView(frame: .zero)
  private var arrNotifications: [Notification] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)
    self.navigationController?.navigationBar.setValue(true,
                                                      forKey: "hidesShadow")

    layout()
  }

  private func configureNotificationsBackground() {
    let label: UILabel = UILabel(typography: .subtitleRegular)
    label.text = Strings.Notifications.youHaveNoNotifications

    let image: UIImageView =
      UIImageView(image: UIImage(cgImage: UIImage(imageLiteralResourceName: Assets.NotificationsUnselected).cgImage!,
                                 scale: 0.75, orientation: .up))

    uvwNotificationsBackground.addSubview(image)
    image.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview()
    }
    uvwNotificationsBackground.addSubview(label)
    label.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(image.snp.bottom).offset(Style.Padding.p16)
      $0.bottom.equalToSuperview()
    }

    tblNotifications.addSubview(uvwNotificationsBackground)
    uvwNotificationsBackground.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.left.right.equalToSuperview().inset(Style.Padding.p48)
    }
  }

  private func layout() {
    view.backgroundColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)

    lblTitle.text = Strings.Notifications.title
    lblTitle.textColor = .black
    lblTitle.backgroundColor = .clear

    view.addSubview(lblTitle)
    lblTitle.snp.makeConstraints {
      $0.top.equalTo(topLayoutGuide.snp.bottom)
      $0.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    tblNotifications.allowsSelection = false
    tblNotifications.backgroundColor = Style.Colors.white
    tblNotifications.dataSource = self
    tblNotifications.delegate = self
    tblNotifications.separatorStyle = .none

    view.addSubview(tblNotifications)
    tblNotifications.snp.makeConstraints {
      $0.top.equalTo(lblTitle.snp.bottom).offset(Style.Padding.p16)
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
      $0.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    configureNotificationsBackground()

    tblNotifications.register(NotificationView.self,
                              forCellReuseIdentifier: NotificationView.identifier)

    // FIXME(compnerd) load the notifications
    if arrNotifications.count > 0 {
      uvwNotificationsBackground.isHidden = true
    }
    tblNotifications.reloadData()
  }
}

extension Notifications: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return arrNotifications.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let notification = arrNotifications[safe: indexPath.section] else {
      return UITableViewCell()
    }

    let cell: UITableViewCell =
        tableView.dequeueReusableCell(withIdentifier: notification.renderer,
                                      for: indexPath)
    guard let view = cell as? NotificationView else { return UITableViewCell() }
    view.render(notification)
    return cell
  }
}

extension Notifications: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    return Style.Padding.p16
  }

  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    return UIView(frame: .zero)
  }
}
