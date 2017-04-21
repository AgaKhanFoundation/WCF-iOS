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

import SnapKit
import FBSDKLoginKit

func setButtonTitle(button: UIButton, title: String) {
  let content: UITableViewCell = UITableViewCell()
  content.textLabel?.text = title
  content.accessoryType = .disclosureIndicator
  content.isUserInteractionEnabled = false

  button.addSubview(content)
  content.snp.makeConstraints { (make) in
    make.edges.equalToSuperview()
  }
}

class ConfigurationViewController: UIViewController {
  let logoutButton = FBSDKLoginButton()

  internal let lblDevice: UILabel = UILabel(.section)

  internal let lblAccountSettings: UILabel = UILabel(.section)
  internal let btnEditProfile: UIButton = UIButton(type: .system)
  internal let btnChangeEmailAddress: UIButton = UIButton(type: .system)
  internal let btnNotificationsAndReminders: UIButton = UIButton(type: .system)

  internal let lblTeams: UILabel = UILabel(.section)
  internal var btnSwitchTeams: UIButton = UIButton(type: .system)

  internal let lblHelpSupport: UILabel = UILabel(.section)
  internal let btnFAQs: UIButton = UIButton(type: .system)
  internal let btnContactUs: UIButton = UIButton(type: .system)

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureView()
  }

  private func configureNavigation() {
    title = Strings.NavBarTitles.configuration
  }

  private func configureDevice(_ top: inout ConstraintItem) {
    view.addSubview(lblDevice)
    lblDevice.text = Strings.Settings.device
    lblDevice.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblDevice.snp.bottom
  }

  private func configureAccountSettings(_ top: inout ConstraintItem) {
    view.addSubview(lblAccountSettings)
    lblAccountSettings.text = Strings.Settings.accountSettings
    lblAccountSettings.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblAccountSettings.snp.bottom

    view.addSubview(btnEditProfile)
    btnEditProfile.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    setButtonTitle(button: btnEditProfile, title: Strings.Settings.editProfile)
    top = btnEditProfile.snp.bottom

    view.addSubview(btnChangeEmailAddress)
    btnChangeEmailAddress.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    setButtonTitle(button: btnChangeEmailAddress,
                   title: Strings.Settings.changeEmailAddress)
    top = btnChangeEmailAddress.snp.bottom

    view.addSubview(btnNotificationsAndReminders)
    btnNotificationsAndReminders.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    setButtonTitle(button: btnNotificationsAndReminders,
                   title: Strings.Settings.notificationsAndReminders)
    top = btnNotificationsAndReminders.snp.bottom
  }

  private func configureTeams(_ top: inout ConstraintItem) {
    view.addSubview(lblTeams)
    lblTeams.text = Strings.Settings.teams
    lblTeams.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblTeams.snp.bottom

    view.addSubview(btnSwitchTeams)
    btnSwitchTeams.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    setButtonTitle(button: btnSwitchTeams, title: Strings.Settings.changeTeams)
    top = btnSwitchTeams.snp.bottom
  }

  private func configureHelpSupport(_ top: inout ConstraintItem) {
    view.addSubview(lblHelpSupport)
    lblHelpSupport.text = Strings.Settings.helpAndSupport
    lblHelpSupport.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblHelpSupport.snp.bottom

    view.addSubview(btnFAQs)
    btnFAQs.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    setButtonTitle(button: btnFAQs, title: Strings.Settings.faq)
    top = btnFAQs.snp.bottom

    view.addSubview(btnContactUs)
    btnContactUs.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    setButtonTitle(button: btnContactUs, title: Strings.Settings.contactUs)
    top = btnContactUs.snp.bottom
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top = topLayoutGuide.snp.bottom

    configureDevice(&top)
    configureAccountSettings(&top)
    configureTeams(&top)
    configureHelpSupport(&top)

    view.addSubview(logoutButton)
    logoutButton.delegate = self
    logoutButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-Style.Padding.p12)
    }
  }
}

extension ConfigurationViewController: FBSDKLoginButtonDelegate {
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    AppController.shared.logout()
  }

  func loginButton(_ loginButton: FBSDKLoginButton!,
                   didCompleteWith result: FBSDKLoginManagerLoginResult!,
                   error: Error!) {
    // Left blank because the user should be logged in when reaching this point
  }
}
