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

class Notifications: UIViewController {

  private let tableView = UITableView()
  private let lblTitle: UILabel = UILabel(typography: .headerTitle)
  private let noNotificationsView = UIView()
  private let noNotificationsLabel = UILabel(typography: .subtitleRegular)

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)
    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)
    self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    self.lblTitle.text = Strings.Notifications.title
    self.lblTitle.textColor = .black
    self.lblTitle.backgroundColor = .clear

    self.view.addSubview(self.lblTitle)
    self.lblTitle.snp.makeConstraints { (make) in
      make.top.equalTo(self.topLayoutGuide.snp.bottom)
      make.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    self.view.addSubview(self.tableView)
    self.tableView.snp.makeConstraints { (make) in
      make.top.equalTo(self.lblTitle.snp.bottom).offset(Style.Padding.p16)
      make.bottom.equalToSuperview().inset(Style.Padding.p16)
      make.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.register(NotificationTableViewCell.self,
                            forCellReuseIdentifier: NotificationTableViewCell.CellIdentifier)
    self.tableView.separatorStyle = .none
    self.tableView.layer.cornerRadius = Style.Size.s8
    self.tableView.layer.masksToBounds = false
    self.tableView.layer.shadowColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1.0000000000)
    self.tableView.layer.shadowOffset = .zero
    self.tableView.layer.shadowOpacity = 0.5
    self.tableView.layer.shadowRadius = Style.Size.s8
  }

  private func noNotificationsViewSetup() {
    self.view.addSubview(self.noNotificationsView)
    self.noNotificationsView.backgroundColor = .red
    self.noNotificationsView.layer.cornerRadius = Style.Size.s8
    self.noNotificationsView.layer.masksToBounds = false
    self.noNotificationsView.layer.shadowColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1.0000000000)
    self.noNotificationsView.layer.shadowOffset = .zero
    self.noNotificationsView.layer.shadowOpacity = 0.5
    self.noNotificationsView.layer.shadowRadius = Style.Size.s8
    self.noNotificationsView.snp.makeConstraints { (make) in
      make.top.equalTo(self.lblTitle.snp.bottom).offset(Style.Padding.p16)
      make.bottom.equalToSuperview().inset(Style.Padding.p16)
      make.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    self.noNotificationsLabel.text = Strings.Notifications.noNotificationsLabelText
    self.noNotificationsView.addSubview(self.noNotificationsLabel)
    self.noNotificationsLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.noNotificationsView).offset(Style.Padding.p16)
      make.left.right.equalToSuperview().inset(Style.Padding.p24)
    }
  }
}

extension Notifications: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //TODO: update with data
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                   for: indexPath) as? NotificationTableViewCell else {
      return UITableViewCell()
    }

    return cell
  }
}

extension Notifications: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
}
