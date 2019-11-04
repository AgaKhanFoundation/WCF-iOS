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

class TeamSettingsViewController: TableViewController {
  override func commonInit() {
    super.commonInit()

    title = Strings.TeamSettings.title

    dataSource = TeamSettingsDataSource()
    (dataSource as? TeamSettingsDataSource)?.delegate = self

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
    if let cell = cell as? TeamSettingsMemberCell {
      cell.delegate = self
    }
  }
}

extension TeamSettingsViewController: SettingsActionCellDelegate {
  func settingsActionCellTapped(context: Context?, button: UIButton) {
    guard let context = context as? TeamSettingsContext else { return }
    switch context {
    case .invite:
      AppController.shared.shareTapped(
          viewController: self,
          shareButton: button,
          string: Strings.Share.item)
    case .editname:
      AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
        guard let participant = Participant(json: result.response) else { return }
        guard participant.team != nil else { return }
        let alert = UIAlertController(title: Strings.TeamSettings.editTeamName,
                                      message: Strings.TeamSettings.editTeamNameMessage,
                                      preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: Strings.TeamSettings.update, style: .default) { (_) in
          let textField = alert.textFields![0] as UITextField
          let newName = textField.text!
          AKFCausesService.editTeamName(team: (participant.team?.id)!, name: newName) { (_) in
            onMain {
              alert.dismiss(animated: true, completion: nil)
              self.navigationController?.popViewController(animated: true)
              NotificationCenter.default.post(name: .teamChanged, object: nil)
            }
          }
        }
        alert.addTextField { (textField) in
          textField.text = "Enter Team Name"
        }
        alert.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
      }
    case .delete:
      AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
        guard let participant = Participant(json: result.response) else { return }
        guard participant.team != nil else { return }

        let alert: AlertViewController = AlertViewController()
        alert.title = Strings.TeamSettings.deleteTeam
        alert.body = Strings.TeamSettings.deleteTeamBody
        alert.add(AlertAction.cancel())
        alert.add(AlertAction(title: "Delete", style: .destructive, shouldDismiss: false) { [weak self] in
          AKFCausesService.deleteTeam(team: (participant.team?.id)!) { (_) in
            onMain {
              alert.dismiss(animated: true, completion: nil)
              self?.navigationController?.popViewController(animated: true)
              NotificationCenter.default.post(name: .teamChanged, object: nil)
            }
          }
        })
        AppController.shared.present(alert: alert, in: self, completion: nil)
      }
    }
  }
}


extension TeamSettingsViewController: TeamSettingsMemberCellDelegate {
  func removeTapped(context: Context?, button: UIButton) {
    guard let context = context as? TeamMembersContext else { return }
    switch context {
    case .remove(let fbid, let name):
      let alert: AlertViewController = AlertViewController()
      alert.title = "Remove \(name)"
      alert.body = "\(name) will be permanently removed from your team"
      alert.add(AlertAction.cancel())
      alert.add(AlertAction(title: "Remove", style: .destructive, shouldDismiss: false) {
        AKFCausesService.leaveTeam(fbid: fbid) { (result) in
          if !result.isSuccess {
            alert.dismiss(animated: true) {
              let alert: AlertViewController = AlertViewController()
              alert.title = "Remove Failed"
              alert.body = "Could not remove \(name).  Please try again later."
              alert.add(AlertAction.okay())
              onMain {
                AppController.shared.present(alert: alert, in: self, completion: nil)
              }
            }

            return
          }

          onMain {
            alert.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .teamChanged, object: nil)
          }
        }
      })
      AppController.shared.present(alert: alert, in: self, completion: nil)
    }
  }
}

extension TeamSettingsViewController: TeamSettingsDataSourceDelegate {
  func updated(team: Team?) {
    onMain {
      if team?.creator == Facebook.id && team?.members.count ?? 0 > 1 {
        self.navigationItem.rightBarButtonItem =
          UIBarButtonItem(title: Strings.TeamSettings.edit, style: .plain,
                          target: self, action: #selector(self.editTapped))
      } else {
        self.navigationItem.rightBarButtonItem = nil
      }
    }
  }

  @objc
  private func editTapped() {
    guard let data = dataSource as? TeamSettingsDataSource else { return }
    onMain {
      self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(title: Strings.TeamSettings.done, style: .plain,
                        target: self, action: #selector(self.doneTapped))
    }
    data.editing = true
    data.configure()
    tableView.reloadOnMain()
  }

  @objc
  private func doneTapped() {
    guard let data = dataSource as? TeamSettingsDataSource else { return }
    onMain {
      self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(title: Strings.TeamSettings.edit, style: .plain,
                        target: self, action: #selector(self.editTapped))
    }
    data.editing = false
    data.configure()
    tableView.reloadOnMain()
  }
}
