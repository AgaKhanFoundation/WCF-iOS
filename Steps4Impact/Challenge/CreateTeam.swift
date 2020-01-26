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

class CreateTeamViewController: ViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate { // swiftlint:disable:this line_length

  private let teamNameLabel = UILabel(typography: .title)
  private let teamNameTextField = UITextField(.bodyRegular)
  private let seperatorView = UIView()

  private let uploadTeamPhotoLabel = UILabel(typography: .rowTitleRegular)
  private let teamPhotoImageView: UIImageView = {
    let imageview = UIImageView()
    imageview.layer.cornerRadius = 64
    imageview.layer.borderWidth = 1
    imageview.layer.borderColor = UIColor.lightGray.cgColor
    imageview.clipsToBounds = true
    imageview.contentMode = .center
    imageview.image = Assets.uploadImageIcon.image
    return imageview
  }()
  private var imagePicker = UIImagePickerController()
  private let uploadImageButton: UIButton = {
    let button = UIButton(type: .custom)
    button.addTarget(self, action: #selector(uploadImageButtonTapped), for: .touchUpInside)
    button.setTitle(Strings.Challenge.CreateTeam.uploadImageButtonText, for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    button.layer.backgroundColor = .none
    return button
  }()

  private let teamVisibilityTitleLabel = UILabel(typography: .bodyRegular)
  private var teamVisibilitySwitch = UISwitch()
  private var teamVisibilitySwitchStatusLabel = UILabel(typography: .bodyRegular)
  private let visibilityBodyLabel = UILabel(typography: .smallRegular, color: .gray)
  private let activityView = UIActivityIndicatorView(style: .gray)

  private var teamName: String = ""
  private let stackView = UIStackView()

  private var event: Event?

  override func configureView() { // swiftlint:disable:this function_body_length
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

    teamNameLabel.text = Strings.Challenge.CreateTeam.formTitle
    view.addSubview(teamNameLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p32)
    }

    teamNameTextField.delegate = self
    teamNameTextField.placeholder = Strings.Challenge.CreateTeam.formPlaceholder
    teamNameTextField.addTarget(self, action: #selector(teamNameChanged(_:)), for: .editingChanged)
    view.addSubview(teamNameTextField) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(teamNameLabel.snp.bottom).offset(Style.Padding.p16)
    }

    seperatorView.backgroundColor = Style.Colors.FoundationGreen
    view.addSubview(seperatorView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(teamNameTextField.snp.bottom)
      $0.height.equalTo(1)
    }

    uploadTeamPhotoLabel.text = Strings.Challenge.CreateTeam.uploadTeamPhotoLabelText
    view.addSubview(uploadTeamPhotoLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(seperatorView.snp.bottom).offset(Style.Padding.p32)
    }

    view.addSubview(teamPhotoImageView) {
      $0.top.equalTo(uploadTeamPhotoLabel.snp.bottom).offset(Style.Padding.p16)
      $0.height.width.equalTo(Style.Size.s128)
      $0.centerX.equalToSuperview()
    }

    view.addSubview(uploadImageButton) {
      $0.top.equalTo(teamPhotoImageView.snp.bottom).offset(Style.Padding.p12)
      $0.width.equalTo(Style.Size.s128)
      $0.height.equalTo(Style.Size.s40)
      $0.centerX.equalToSuperview()
    }

    teamVisibilitySwitch.isOn = true
    teamVisibilitySwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
    view.addSubview(teamVisibilitySwitch) {
      $0.top.equalTo(uploadImageButton.snp.bottom).offset(Style.Padding.p16)
      $0.trailing.equalToSuperview().inset(Style.Padding.p32)
    }

    teamVisibilitySwitchStatusLabel.text = Strings.Challenge.CreateTeam.teamVisibilitySwitchStatusPublic
    teamVisibilitySwitchStatusLabel.textAlignment = .left
    view.addSubview(teamVisibilitySwitchStatusLabel) {
      $0.top.equalTo(uploadImageButton.snp.bottom).offset(Style.Padding.p20)
      $0.trailing.equalToSuperview().inset(Style.Size.s75)
      $0.width.equalTo(Style.Size.s64)
    }

    teamVisibilityTitleLabel.text = Strings.Challenge.CreateTeam.teamVisibilityTitleText
    view.addSubview(teamVisibilityTitleLabel) {
      $0.top.equalTo(uploadImageButton.snp.bottom).offset(Style.Size.s16)
      $0.leading.equalToSuperview().offset(Style.Size.s32)
    }

    visibilityBodyLabel.text = Strings.Challenge.CreateTeam.visibilityBodyOn
    view.addSubview(visibilityBodyLabel) {
      $0.top.equalTo(teamVisibilityTitleLabel.snp.bottom).offset(Style.Padding.p16)
      $0.trailing.equalToSuperview().inset(Style.Size.s32)
      $0.leading.equalToSuperview().offset(Style.Size.s32)
    }

    onBackground {
      AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
        guard let participant = Participant(json: result.response),
          let eventId = participant.currentEvent?.id
          else { return }

        AKFCausesService.getEvent(event: eventId) { (result) in
          self.event = Event(json: result.response)
        }
      }
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
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
  func switchStateDidChange(_ sender: UISwitch) {
    if sender.isOn == true {
      visibilityBodyLabel.text = Strings.Challenge.CreateTeam.visibilityBodyOn
      teamVisibilitySwitchStatusLabel.text = Strings.Challenge.CreateTeam.teamVisibilitySwitchStatusPublic
    } else {
      visibilityBodyLabel.text = Strings.Challenge.CreateTeam.visibilityBodyOff
      teamVisibilitySwitchStatusLabel.text = Strings.Challenge.CreateTeam.teamVisibilitySwitchStatusPrivate
    }
  }

  @objc
  func uploadImageButtonTapped() {
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
      print("Button capture")

      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = false

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
      teamPhotoImageView.contentMode = .scaleAspectFill
      teamPhotoImageView.image = image
      dismiss(animated: true, completion: nil)
    }
  }

  @objc
  func createTapped() {
    activityView.startAnimating()
    navigationItem.rightBarButtonItem?.isEnabled = false
    teamNameTextField.isEnabled = false

    AKFCausesService.createTeam(name: teamName.trimmingCharacters(in: .whitespaces),
                                lead: Facebook.id) { [weak self] (result) in
                                  onMain {
                                    guard let `self` = self else { return }
                                    self.activityView.stopAnimating()
                                    self.teamNameTextField.isEnabled = true
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
                                          // swiftlint:disable:next line_length
                                          self.navigationController?.setViewControllers([CreateTeamSuccessViewController(for: self.event, teamName: self.teamName.trimmingCharacters(in: .whitespaces))],
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
    alert.title = Strings.Challenge.CreateTeam.errorTitle
    alert.body = Strings.Challenge.CreateTeam.errorBody
    alert.add(.okay())
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }
}
