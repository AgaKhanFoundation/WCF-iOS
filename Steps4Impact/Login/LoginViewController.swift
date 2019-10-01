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
import SafariServices
import NotificationCenter

class LoginViewController: UIViewController {
  let imgLogo: UIImageView = UIImageView(image: Assets.logo.image)
  let imgImage: UIImageView =
      UIImageView(image: Assets.onboardingLoginPeople.image)
  let btnLogin: FBLoginButton = FBLoginButton(permissions: [.publicProfile])
  let btnTermsAndConditions: Button = Button(style: .link)

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    imgLogo.contentMode = .scaleAspectFit
    view.addSubview(imgLogo) { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p32)
      make.height.width.equalTo(Style.Size.s128)
    }

    imgImage.contentMode = .scaleAspectFit
    view.addSubview(imgImage) { (make) in
      make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p32)
      make.top.equalTo(imgLogo.snp.bottom).offset(Style.Padding.p32)
    }

    btnLogin.delegate = self
    view.addSubview(btnLogin) { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      make.top.equalTo(imgImage.snp.bottom).offset(Style.Padding.p32)
    }

    btnTermsAndConditions.title = Strings.Login.conditions
    btnTermsAndConditions.addTarget(self,
                                    action: #selector(viewTermsAndConditions),
                                    for: .touchUpInside)
    view.addSubview(btnTermsAndConditions) { (make) in
      make.bottom.equalToSuperview().inset(Style.Padding.p32)
      make.centerX.equalToSuperview()
    }
  }

  @objc
  private func viewTermsAndConditions() {
    let view: SFSafariViewController =
      SFSafariViewController(url: URL(string: "https://www.akfusa.org/website-private-policy")!)
    present(view, animated: true, completion: nil)
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

    AKFCausesService.shared.createParticipant(fbid: FacebookService.shared.id)

    onBackground {
      let group: DispatchGroup = DispatchGroup()

      group.enter()
      AKFCausesService.shared.getParticipant(fbid: FacebookService.shared.id) { (result) in
        if let participant = Participant(json: result.response), participant.currentEvent == nil {
          group.enter()
          AKFCausesService.shared.getEvents { (result) in
            if let events: [Event] = result.response?.arrayValue?.compactMap({ (json) in Event(json: json) }),
                let eid = events.first?.id {
              group.enter()
              // TODO(compnerd) do not hard code the distance here (we should push this to the backend to provide)
              AKFCausesService.shared.joinEvent(fbid: FacebookService.shared.id, eventID: eid, miles: 500) { (_) in
                group.leave()
              }
            }
            group.leave()
          }
        }
        group.leave()
      }
      group.wait()

      NotificationCenter.default.post(name: .eventChanged, object: nil)
    }

    AppController.shared.login()
  }

  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    fatalError("user logged in without a session?")
  }
}
