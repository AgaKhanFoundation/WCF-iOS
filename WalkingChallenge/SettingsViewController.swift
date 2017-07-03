/**
 * Copyright © 2017 Aga Khan Foundation
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

import Foundation
import FacebookLogin
import UIKit
import SnapKit

fileprivate class PedometerCell: UITableViewCell {
  static let identifier: String = "PedometerCell"

  internal var devicePicture: UIImageView = UIImageView()
  internal var deviceName: UILabel = UILabel(.header)
  internal var deviceDescription: UILabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([devicePicture, deviceName, deviceDescription])

    devicePicture.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.size.equalTo(Style.Size.s56)
      make.bottom.equalToSuperview().inset(Style.Padding.p12)
    }

    deviceName.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalTo(devicePicture.snp.right).offset(Style.Padding.p8)
    }

    deviceDescription.textColor = Style.Colors.grey
    deviceDescription.snp.makeConstraints { (make) in
      make.top.equalTo(deviceName.snp.bottom)
      make.left.equalTo(deviceName.snp.left)
    }
  }
}

private enum TableSection: Int {
  case device
  case accountSettings
  case teams
  case helpAndSupport
}

struct SettingsInfo {
  let title: String
  let values: [SettingsValue]
}

struct SettingsValue {
  let configValue: String
}

class SettingsSectionDataSource {
  let pedometerSource = UserInfo.pedometerSource
  // swiftlint:disable line_length
  var settingsInfo: [SettingsInfo] = [
    SettingsInfo(title: Strings.Settings.accountSettings,
                  values: [
                    SettingsValue.init(configValue: Strings.Settings.editProfile),
                    SettingsValue.init(configValue: Strings.Settings.changeEmailAddress),
                    SettingsValue.init(configValue: Strings.Settings.notificationsAndReminders)]),
                    SettingsInfo(title: Strings.Settings.teams, values: [SettingsValue.init(configValue: Strings.Settings.changeTeams)]),
                    SettingsInfo(title: Strings.Settings.helpAndSupport,
                                 values: [SettingsValue.init(configValue: Strings.Settings.faq),
                                          SettingsValue.init(configValue: Strings.Settings.contactUs)])
    ]
  // swiftlint:enable Line Length
}

fileprivate class SettingsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  internal var dataSource: SettingsSectionDataSource?
  override init() {
    super.init()
    self.dataSource = SettingsSectionDataSource()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == TableSection.device.rawValue {
      return 1
    } else {
      let configuration = dataSource?.settingsInfo[section - 1]
      return (configuration?.values.count)!
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return (dataSource?.settingsInfo.count)!+1
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell

    switch indexPath.section {
    case TableSection.device.rawValue:
      let pedometerSource = dataSource?.pedometerSource
      cell = tableView.dequeueReusableCell(withIdentifier: PedometerCell.identifier, for: indexPath)
      if let cell = cell as? PedometerCell {
        cell.deviceName.text = pedometerSource?.rawValue
        cell.deviceDescription.text = pedometerSource?.rawValue
        cell.devicePicture.backgroundColor = UIColor.brown
      }
      break
    default:
      let configure = dataSource?.settingsInfo[safe: indexPath.section - 1]
      let justValue = configure?.values[indexPath.row]
      cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
      cell.textLabel?.text = justValue?.configValue
      break
    }
    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    return cell
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == TableSection.device.rawValue {
      return Strings.Settings.device
    } else {
      let headerTitle = dataSource?.settingsInfo[section - 1]
      return headerTitle?.title
    }
  }
}

class SettingsViewController: UIViewController, LoginButtonDelegate {
  fileprivate var configDataSource = SettingsDataSource()
  private var configurationTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
  internal let btnLogout: LoginButton = LoginButton(readPermissions: [])

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    self.title = Strings.Settings.title
    configureSettingsTableView()
  }

  private func configureSettingsTableView() {
    configurationTableView.dataSource = configDataSource
    configurationTableView.delegate = configDataSource
    configurationTableView.estimatedRowHeight = 50
    configurationTableView.rowHeight = UITableViewAutomaticDimension
    configurationTableView.allowsSelection = true
    configurationTableView.register(UITableViewCell.self,
                                    forCellReuseIdentifier: "SettingsCell")
    configurationTableView.register(PedometerCell.self,
                                    forCellReuseIdentifier: PedometerCell.identifier)
    view.addSubview(configurationTableView)
    configurationTableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    configurationTableView.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: configurationTableView.bounds.size.width, height:50))
    configurationTableView.tableFooterView?.addSubview(btnLogout)
    btnLogout.delegate = self
    btnLogout.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(Style.Padding.p8)
      make.right.equalToSuperview().offset(-Style.Padding.p8)
    }
  }

  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    AppController.shared.logout()
  }

  func loginButtonDidCompleteLogin(_ loginButton: LoginButton,
                                   result: LoginResult) {
    // Left blank because the user should be logged in when reaching this point
  }
}
