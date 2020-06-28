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

  weak var headerCellReference: TeamSettingsHeaderCell?
  private let activityView = UIActivityIndicatorView(style: .gray)

  private let imagePicker = UIImagePickerController()
  override func commonInit() {
    super.commonInit()

    title = Strings.TeamSettings.title

    dataSource = TeamSettingsDataSource()
    (dataSource as? TeamSettingsDataSource)?.delegate = self

    _ = NotificationCenter.default.addObserver(forName: .teamChanged,
                                               object: nil, queue: nil) { [weak self] (_) in
                                                self?.reload()
    }

    view.addSubview(activityView) {
      $0.centerX.centerY.equalToSuperview()
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
    if let cell = cell as? TeamSettingsHeaderCell {
      cell.delegate = self
    }
  }
}

extension TeamSettingsViewController: SettingsActionCellDelegate {
  func settingsActionCellTapped(context: Context?, button: UIButton) {
    guard let context = context as? TeamSettingsContext else { return }
    switch context {
    case .invite:
      let ds = dataSource as? TeamSettingsDataSource
      let context = ds?.cells[safe: 0]?[safe: 0] as? TeamSettingsHeaderCellContext
      let teamName = context?.team
      AppController.shared.shareTapped(
        viewController: self,
        shareButton: button,
        string: Strings.Share.item(teamName: teamName ?? ""))
    case .editname:
      AKFCausesService.getParticipant(fbid: User.id) { (result) in
        guard
          let participant = Participant(json: result.response),
          let team = participant.team,
          let teamId = team.id
          else { return }

        let alert = TextAlertViewController()
        alert.title = Strings.TeamSettings.editTeamName
        alert.body = Strings.TeamSettings.editTeamNameMessage
        alert.value = team.name
        alert.add(.init(title: Strings.TeamSettings.update, handler: {
          guard let newName = alert.value else { return }
          AKFCausesService.editTeamName(teamId: teamId, name: newName) { (result) in
            guard !result.isSuccess else { return }
            NotificationCenter.default.post(name: .teamChanged, object: nil)
          }
        }))
        alert.add(.cancel())
        AppController.shared.present(alert: alert, in: self, completion: nil)
      }
    case .delete:
      AKFCausesService.getParticipant(fbid: User.id) { (result) in
        guard let participant = Participant(json: result.response) else { return }
        guard let teamId = participant.team?.id else { return }

        let alert: AlertViewController = AlertViewController()
        alert.title = Strings.TeamSettings.deleteTeam
        alert.body = Strings.TeamSettings.deleteTeamBody
        alert.add(AlertAction.cancel())
        alert.add(AlertAction(title: "Delete", style: .destructive, shouldDismiss: false) { [weak self] in
          AKFCausesService.deleteTeam(team: teamId) { (_) in
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
      if team?.creator == User.id && team?.members.count ?? 0 > 1 {
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

extension TeamSettingsViewController: TeamSettingsHeaderCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func editImageButtonPressed(cell: TeamSettingsHeaderCell) {
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
      print("Button capture")

      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = false
      headerCellReference = cell
      present(imagePicker, animated: true, completion: nil)
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    print("\(info)")
    if let image = info[.originalImage] as? UIImage {
      if let cell = headerCellReference {
        cell.teamImageView.contentMode = .scaleAspectFill
        cell.teamImageView.image = image
        activityView.startAnimating()
        guard let imageData = image.jpegData(compressionQuality: 0.25), let teamName = cell.teamLabel.text else { return }
        AZSClient.uploadImage(data: imageData, teamName: teamName) { (error, success) in
          if let err = error {
            print("Image cannot be uploaded: \(err)")
            self.showErrorAlert()
            onMain {
              self.activityView.stopAnimating()
            }
          } else {
            onMain {
              self.activityView.stopAnimating()
            }
          }
        }
      }
      dismiss(animated: true, completion: nil)
    }
  }

  private func showErrorAlert() {
    let alert = AlertViewController()
    alert.title = Strings.Challenge.CreateTeam.errorTitle
    alert.body = Strings.Challenge.CreateTeam.errorBody
    alert.add(.okay())
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }
}

