//
//  ConfigurationTableViewController.swift
//  WalkingChallenge
//
//  Created by Karim Abdul on 4/30/17.
//  Copyright © 2017 AKDN. All rights reserved.
//

import Foundation
import FacebookLogin
import UIKit
import SnapKit

fileprivate class FitBitCell: UITableViewCell, IdentifiedUITableViewCell {
  static let identifier: String = "FitBitCell"

  internal var picture: UIImageView = UIImageView()
  internal var name: UILabel = UILabel(.header)
  internal var time: UILabel = UILabel(.body)
  internal var team: UILabel = UILabel(.body)
  internal var raised: UILabel = UILabel(.body)
  internal var distance: UILabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([picture, name, time, team, raised, distance])

    picture.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.size.equalTo(Style.Size.s56)
    }

    name.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalTo(picture.snp.right).offset(Style.Padding.p8)
    }

    time.textColor = Style.Colors.grey
    time.snp.makeConstraints { (make) in
      make.top.equalTo(name.snp.bottom)
      make.left.equalTo(name.snp.left)
    }

    team.snp.makeConstraints { (make) in
      make.top.equalTo(time.snp.bottom).offset(Style.Padding.p12)
      make.left.equalTo(time.snp.left)
    }

    raised.snp.makeConstraints { (make) in
      make.top.equalTo(team.snp.bottom)
      make.left.equalTo(team.snp.left)
    }

    distance.snp.makeConstraints { (make) in
      make.top.equalTo(raised.snp.top)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.bottom.equalToSuperview()
    }
  }
}

private enum TableSection: Int {
  case device = 0
  case accountSettings
  case teams
  case helpAndSupport
}

struct FitBitInfo {
  let title: String
  let image: UIImage!
  let deviceName: String
  let deviceDescription: String
}

struct SettingsInfo {
  let title: String
  let values: [SettingsnValue]
}

struct SettingsnValue {
  let configValue: String
}

class SettingsSectionDataSource {

  var fitBitInfo: FitBitInfo = FitBitInfo(title: "Tet", image: nil, deviceName: "Test", deviceDescription: "Test")

  // swiftlint:disable line_length
  var settingsInfo: [SettingsInfo] = [
    SettingsInfo(title: Strings.Settings.accountSettings,
                  values: [SettingsnValue.init(configValue: Strings.Settings.editProfile),SettingsnValue.init(configValue: Strings.Settings.changeEmailAddress),SettingsnValue.init(configValue: Strings.Settings.notificationsAndReminders)]),
    SettingsInfo(title: Strings.Settings.teams, values: [SettingsnValue.init(configValue: Strings.Settings.changeTeams)]),
    SettingsInfo(title: Strings.Settings.helpAndSupport, values: [SettingsnValue.init(configValue: Strings.Settings.faq),SettingsnValue.init(configValue: Strings.Settings.contactUs)])
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
    if section == 0 {
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
    case 0:
      // swiftlint:disable force_cast
      let fitBitInfo = dataSource?.fitBitInfo
      cell = tableView.dequeueReusableCell(withIdentifier: FitBitCell.identifier, for: indexPath)
      (cell as! FitBitCell).name.text = fitBitInfo?.deviceName
      (cell as! FitBitCell).distance.text = fitBitInfo?.deviceName
      (cell as! FitBitCell).time.text = fitBitInfo?.deviceName
      (cell as! FitBitCell).team.text = fitBitInfo?.deviceName
      (cell as! FitBitCell).raised.text = fitBitInfo?.deviceName
      // swiftlint:enable force_cast
      break
    default:
      let configure = dataSource?.settingsInfo[safe: indexPath.section - 1]
      let justValue = configure?.values[indexPath.row]
      cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
      cell.textLabel?.text = justValue?.configValue
      break
    }
    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      let headerTitle = dataSource?.fitBitInfo
      return headerTitle?.title
    } else {
      let headerTitle = dataSource?.settingsInfo[section - 1]
      return headerTitle?.title
    }
  }
}

class SettingsViewController: UIViewController {
  fileprivate var configDataSource = SettingsDataSource()
  private var configurationTableView: UITableView = UITableView(frame: CGRect.zero, style:UITableViewStyle.grouped)

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
    configurationTableView.estimatedRowHeight = 50 //This is an arbitrary number
    configurationTableView.rowHeight = UITableViewAutomaticDimension
    configurationTableView.allowsSelection = true
    configurationTableView.register(UITableViewCell.self,
                                    forCellReuseIdentifier: "testCell")
    configurationTableView.register(FitBitCell.self,
                                    forCellReuseIdentifier: FitBitCell.identifier)
    view.addSubview(configurationTableView)
    configurationTableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}
