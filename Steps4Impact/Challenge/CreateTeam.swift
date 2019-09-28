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

class CreateTeamViewController: ViewController {
  private let label = UILabel(typography: .title)
  private let textField = UITextField(.bodyRegular)
  private let seperatorView = UIView()
  private let activityView = UIActivityIndicatorView(style: .gray)
  private var teamName: String = ""

  private var event: Event?

  override func configureView() {
    super.configureView()
    title = Strings.Challenge.CreateTeam.title
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: Assets.close.image,
      style: .plain,
      target: self,
      action: #selector(closeButtonTapped))
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: Strings.Challenge.CreateTeam.create,
      style: .plain,
      target: self,
      action: #selector(createTapped))
    navigationItem.rightBarButtonItem?.isEnabled = false

    label.text = Strings.Challenge.CreateTeam.formTitle
    textField.placeholder = Strings.Challenge.CreateTeam.formPlaceholder
    textField.addTarget(self, action: #selector(teamNameChanged(_:)), for: .editingChanged)
    seperatorView.backgroundColor = Style.Colors.FoundationGreen

    view.addSubview(label) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p32)
    }

    view.addSubview(textField) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(label.snp.bottom).offset(Style.Padding.p16)
    }

    view.addSubview(seperatorView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(textField.snp.bottom)
      $0.height.equalTo(1)
    }

    view.addSubview(activityView) {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(seperatorView.snp.bottom).offset(Style.Padding.p24)
    }

    onBackground {
      AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
        guard let participant = Participant(json: result.response),
              let event = participant.currentEvent else {
          return
        }

        AKFCausesService.getEvent(event: event.id!) { (result) in
          self.event = Event(json: result.response)
        }
      }
    }
  }

  @objc
  func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }

  @objc
  func teamNameChanged(_ sender: UITextField) {
    guard let newValue = sender.text else { return }
    teamName = newValue

    navigationItem.rightBarButtonItem?.isEnabled = teamName.count > 3
  }

  @objc
  func createTapped() {
    activityView.startAnimating()
    navigationItem.rightBarButtonItem?.isEnabled = false
    textField.isEnabled = false

    AKFCausesService.createTeam(name: teamName, lead: Facebook.id) { [weak self] (result) in
      onMain {
        guard let `self` = self else { return }
        self.activityView.stopAnimating()
        self.textField.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true

        guard let teamID = Team(json: result.response)?.id else {
          self.showErrorAlert()
          return
        }

        AKFCausesService.joinTeam(fbid: Facebook.id, team: teamID) { [weak self] (result) in
          onMain {
            guard let `self` = self else { return }
            switch result {
            case .success:
              self.navigationController?.setViewControllers([CreateTeamSuccessViewController(for: self.event)],
                                                            animated: true)
              NotificationCenter.default.post(name: .teamChanged, object: nil)
            case .failed:
              // If creating a team is successful but joining fails - delete it.
              AKFCausesService.deleteTeam(team: teamID)
              self.showErrorAlert()
            }
          }
        }
      }
    }
  }

  private func showErrorAlert() {
    let alert = AlertViewController()
    alert.title = Strings.Challenge.CreateTeam.ErrorAlert.title
    alert.body = Strings.Challenge.CreateTeam.ErrorAlert.body
    alert.add(.okay())
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }
}
