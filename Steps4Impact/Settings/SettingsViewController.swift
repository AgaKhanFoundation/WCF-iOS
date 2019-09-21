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
import FacebookLogin

class SettingsViewController: TableViewController {
  override func commonInit() {
    super.commonInit()

    title = Strings.Settings.title
    dataSource = SettingsDataSource()
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    if let cell = cell as? SettingsActionCell {
      cell.delegate = self
    }
  }

  override func handle(context: Context) {
    guard let context = context as? SettingsDataSource.SettingsContext else { return }
    switch context {
    case .connectSource:
      navigationController?.pushViewController(ConnectSourceViewController(), animated: true)
    case .viewTeam:
      navigationController?.pushViewController(TeamSettingsViewController(), animated: true)
    case .logout:
      logout()
    case .deleteAccount:
      guard let dataSource = dataSource as? SettingsDataSource else { return }
      let alert = AlertViewController()
      alert.title = Strings.Settings.delete
      alert.isDismissable = false
      AppController.shared.present(alert: alert, in: self) {
        dataSource.deleteAccount { [weak self] in
          self?.logout()
          alert.dismiss(animated: true, completion: nil)
        }
      }
    }
  }

  func logout() {
    let loginManager = LoginManager()
    loginManager.logOut()
    AppController.shared.transition(to: .login)
  }
}

extension SettingsViewController: SettingsActionCellDelegate {
  func settingsActionCellTapped(context: Context?) {
    guard let context = context else { return }
    handle(context: context)
  }
}
