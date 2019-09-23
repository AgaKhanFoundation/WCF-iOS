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

import SnapKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
  let imgLogo: UIImageView =
      UIImageView(image: UIImage(cgImage: Assets.AKFLogo.image!.cgImage!,
                                 scale: 4.0, orientation: .up))
  let lblTitle: UILabel = UILabel(typography: .onboarding)
  let imgImage: UIImageView =
      UIImageView(image: Assets.onboardingLoginPeople.image)
  let btnLogin: FBLoginButton = FBLoginButton(permissions: [.publicProfile])
  let lblTermsAndConditions: UILabel = UILabel(typography: .footnote)

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    view.addSubviews([imgLogo, lblTitle, imgImage, btnLogin,
                      lblTermsAndConditions])

    imgLogo.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide).offset(Style.Size.s24)
    }

    lblTitle.text = Strings.Application.name
    lblTitle.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(imgLogo.snp.bottom).offset(Style.Size.s16)
    }

    imgImage.contentMode = .scaleAspectFit
    imgImage.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(Style.Size.s32)
      make.right.equalToSuperview().inset(Style.Size.s32)
      make.top.equalTo(lblTitle).offset(Style.Size.s56)
      make.bottom.equalTo(btnLogin).inset(Style.Size.s56)
    }

    btnLogin.delegate = self
    btnLogin.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(Style.Size.s40)
      make.right.equalToSuperview().inset(Style.Size.s40)
      make.height.equalTo(Style.Size.s48)
    }

    lblTermsAndConditions.text = Strings.Login.conditions
    lblTermsAndConditions.textColor = Style.Colors.grey
    lblTermsAndConditions.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(Style.Size.s32)
    }
  }
}

extension LoginViewController: LoginButtonDelegate {
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    if let error = error {
      alert(message: "Error logging in \(error)", style: .cancel)
      return
    }

    guard let result = result else { return }
    if result.isCancelled { return }

    AKFCausesService.createParticipant(fbid: Facebook.id)

    onBackground {
      let group: DispatchGroup = DispatchGroup()

      group.enter()
      AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
        if let participant = Participant(json: result.response), participant.event == nil {
          group.enter()
          AKFCausesService.getEvents { (result) in
            if let events: [Event] = result.response?.arrayValue?.compactMap({ (json) in Event(json: json) }),
                let eid = events.first?.id {
              group.enter()
              AKFCausesService.joinEvent(fbid: Facebook.id, eventID: eid) { (_) in
                group.leave()
              }
            }
            group.leave()
          }
        }
        group.leave()
      }
      group.wait()

      // NOTE(compnerd) this forces the reload since the event information
      // needs to be populated and may not have been present when the view was
      // loaded.  Unfortunately, we do not have a good way to get to the actual
      // controller, so hardcode the expected path.
      onMain {
        (AppController.shared.navigation.viewControllers?.first as? TableViewController)?.reload()
      }
    }

    AppController.shared.login()
  }

  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    fatalError("user logged in without a session?")
  }
}
