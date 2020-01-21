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
import NotificationCenter

class SettingsViewController: TableViewController {
  override func commonInit() {
    super.commonInit()

    title = Strings.Settings.title
    dataSource = SettingsDataSource()

    _ = NotificationCenter.default.addObserver(forName: .teamChanged,
                                               object: nil, queue: nil) { [weak self] (_) in
      self?.reload()
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func tableView(_ tableView: UITableView,
                          willDisplay cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    if let cell = cell as? SettingsActionCell {
      cell.delegate = self
    }
    if let cell = cell as? AppInfoCell {
      cell.delegate = self
    }
  }

  override func handle(context: Context) {
    guard let context = context as? SettingsDataSource.SettingsContext else { return }
    switch context {
    case .connectSource:
      navigationController?.pushViewController(ConnectSourceViewController(), animated: true)
    case .createAKFProfile:
      navigationController?.pushViewController(AKFLoginViewController(), animated: true)
    case .viewTeam:
      navigationController?.pushViewController(TeamSettingsViewController(), animated: true)
    case .leaveTeam:
      leaveTeam()
    case .logout:
      logout()
    case .deleteAccount:
      deleteAccount()
    case .personalMileCommitment:
      updatePersonalMileCommitment()
    }
  }

  private func logout() {
    let loginManager = LoginManager()
    loginManager.logOut()
    AppController.shared.transition(to: .login)
  }

  private func leaveTeam() {
    let alert: AlertViewController = AlertViewController()
    alert.title = Strings.TeamSettings.leave
    alert.body = Strings.TeamSettings.leaveBody
    alert.add(AlertAction(title: "Cancel", style: .secondary))
    alert.add(AlertAction(title: "Leave", style: .destructive, shouldDismiss: false) { [weak self] in
      AKFCausesService.leaveTeam(fbid: Facebook.id) { (_) in
        NotificationCenter.default.post(name: .teamChanged, object: nil)
        onMain {
          alert.dismiss(animated: true, completion: nil)
        }
        self?.reload()
      }
    })
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }

  private func deleteAccount() {
    let alert = AlertViewController()
    alert.title = Strings.Settings.delete
    alert.body = Strings.Settings.deleteBody
    alert.add(AlertAction.cancel())
    alert.add(AlertAction(title: "Delete", style: .destructive, shouldDismiss: false) { [weak self] in
      AKFCausesService.deleteParticipant(fbid: Facebook.id) { (_) in
        onMain {
          alert.dismiss(animated: true, completion: nil)
        }
        self?.logout()
      }
    })
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }

  private func updatePersonalMileCommitment() {
    AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
      guard let participant = Participant(json: result.response) else { return }
      if let _ = participant.currentEvent {
        let alert = TextAlertViewController()
        alert.title = "Personal mile commitment"
        alert.value = "\(participant.currentEvent?.commitment?.miles ?? 0)"
        alert.suffix = "Miles"
        alert.add(.init(title: "Save", style: .primary, shouldDismiss: false) {
          if let cid = participant.currentEvent?.commitment?.id {
            AKFCausesService.setCommitment(cid, toSteps: (Int(alert.value ?? "0") ?? 0) * 2000) { (result) in
              alert.dismiss(animated: true) {
                if !result.isSuccess {
                  let alert: AlertViewController = AlertViewController()
                  alert.title = "Update Failed"
                  alert.body = "Could not update commitment.  Please try again later."
                  alert.add(.okay())
                  onMain {
                    AppController.shared.present(alert: alert, in: self, completion: nil)
                  }
                  return
                }

                NotificationCenter.default.post(name: .commitmentChanged, object: nil)
                onMain {
                  self.reload()
                }
              }
            }
          }
        })
        alert.add(.cancel())
        AppController.shared.present(alert: alert, in: self, completion: nil)
      } else {
        let alert = AlertViewController()
        alert.title = "No Event Available"
        alert.body = "Can't update commitment when there is no event available"
        alert.add(.okay({
          alert.dismiss(animated: true, completion: nil)
        }))
        AppController.shared.present(alert: alert, in: self, completion: nil)
      }
    }
  }
}

extension SettingsViewController: SettingsActionCellDelegate {
  func settingsActionCellTapped(context: Context?, button: UIButton) {
    guard let context = context else { return }
    handle(context: context)
  }
}

extension SettingsViewController: AppInfoCellDelegate {
  func appInfoCellToggleStaging() {
    let alert = AlertViewController()
    alert.title = "Switch Server"
    alert.body = "Switch to \(UserInfo.isStaging ? "Production" : "Staging")?\nApp will logout if you continue."
    alert.add(.okay({ [weak self] in
      UserInfo.isStaging = !UserInfo.isStaging
      self?.logout()
    }))
    alert.add(.cancel())
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }
}
