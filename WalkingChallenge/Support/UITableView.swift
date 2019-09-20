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

extension UITableView {
  func configure<V>(with viewController: V) where V: UITableViewDataSource & UITableViewDelegate {
    backgroundColor = steps4impact.Style.Colors.Background
    estimatedRowHeight = steps4impact.Style.Padding.p40
    rowHeight = UITableView.automaticDimension
    separatorStyle = .none
    delegate = viewController
    dataSource = viewController
    registerAllCells()
  }

  func registerAllCells() {
    register(EmptyCell.self, forCellReuseIdentifier: EmptyCell.identifier)
    register(DisclosureCell.self, forCellReuseIdentifier: DisclosureCell.identifier)
    register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)
    register(ProfileCardCell.self, forCellReuseIdentifier: ProfileCardCell.identifier)
    register(ConnectedActivityCell.self, forCellReuseIdentifier: ConnectedActivityCell.identifier)
    register(EmptyActivityCell.self, forCellReuseIdentifier: EmptyActivityCell.identifier)
    register(SettingsProfileCell.self, forCellReuseIdentifier: SettingsProfileCell.identifier)
    register(SettingsTitleCell.self, forCellReuseIdentifier: SettingsTitleCell.identifier)
    register(SettingsDisclosureCell.self, forCellReuseIdentifier: SettingsDisclosureCell.identifier)
    register(SettingsSwitchCell.self, forCellReuseIdentifier: SettingsSwitchCell.identifier)
    register(SettingsActionCell.self, forCellReuseIdentifier: SettingsActionCell.identifier)
    register(TeamSettingsHeaderCell.self, forCellReuseIdentifier: TeamSettingsHeaderCell.identifier)
    register(TeamSettingsMemberCell.self, forCellReuseIdentifier: TeamSettingsMemberCell.identifier)
    register(TeamNeededCell.self, forCellReuseIdentifier: TeamNeededCell.identifier)
    register(JoinTeamCell.self, forCellReuseIdentifier: JoinTeamCell.identifier)
    register(ConnectSourceCell.self, forCellReuseIdentifier: ConnectSourceCell.identifier)
  }

  func reloadOnMain() {
    onMain {
      self.reloadData()
    }
  }

  func dequeueAndConfigureReusableCell(dataSource: TableViewDataSource?,
                                       indexPath: IndexPath) -> ConfigurableTableViewCell {
    guard
      let cellContext = dataSource?.cell(for: indexPath),
      let cell = dequeueReusableCell(
        withIdentifier: cellContext.identifier,
        for: indexPath) as? ConfigurableTableViewCell
    else {
      assertionFailure("Trying to dequeue a cell that was not registered")
      return EmptyCell()
    }

    cell.configure(context: cellContext)
    return cell
  }
}
