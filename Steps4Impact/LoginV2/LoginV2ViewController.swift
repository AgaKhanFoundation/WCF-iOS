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
import SnapKit
import FBSDKLoginKit
import FirebaseAuth
import SafariServices

class LoginV2ViewController: ViewController {
  private let logoImageView = UIImageView(asset: .logo)
  private let onboardingImageView = UIImageView(asset: .onboardingLoginPeople)
  private let signInLabel = UILabel(typography: .bodyBold)
  private let appleLoginButton = UIButton(asset: .squareApple)
  private let facebookLoginButton = UIButton(asset: .squareFacebook)
  private let googleLoginButton = UIButton(asset: .squareGoogle)
  private let termsAndConditionsButton = Button(style: .link)
  
  private let stackView = UIStackView(axis: .vertical,
                                      spacing: Style.Padding.p32,
                                      alignment: .center)
  
  private let buttonStackView = UIStackView(axis: .horizontal,
                                            spacing: Style.Padding.p32,
                                            alignment: .center)
  
  override func commonInit() {
    super.commonInit()
    
    [logoImageView, onboardingImageView]
      .forEach { $0.contentMode = .scaleAspectFit }
    
    logoImageView.isUserInteractionEnabled = true
    logoImageView.addGestureRecognizer(UILongPressGestureRecognizer(
      target: self,
      action: #selector(logoLongPressed)))
    
    signInLabel.text = Strings.Login.title
    termsAndConditionsButton.title = Strings.Login.conditions
    termsAndConditionsButton.addTarget(self,
                                       action: #selector(viewTermsAndConditions),
                                       for: .touchUpInside)
    
    facebookLoginButton.addTarget(self,
                                  action: #selector(facebookLoginButtonTapped),
                                  for: .touchUpInside)
    
    // TODO(samisuteria): Add google and apple in a future PR
    googleLoginButton.isHidden = true
    appleLoginButton.isHidden = true
  }
  
  override func configureView() {
    super.configureView()
    
    logoImageView.snp.makeConstraints {
      $0.height.width.equalTo(Style.Size.s128)
    }
    
    stackView.addArrangedSubviews(
      logoImageView,
      onboardingImageView,
      signInLabel,
      buttonStackView,
      termsAndConditionsButton
    )
    
    buttonStackView.addArrangedSubviews(
      facebookLoginButton,
      googleLoginButton,
      appleLoginButton
    )
    
    view.addSubview(stackView) {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p32)
      $0.leading.trailing.bottom.equalToSuperview().inset(Style.Padding.p32)
    }
  }
  
  // MARK: - Actions
  
  @objc
  private func logoLongPressed() {
    let alert = AlertViewController()
    alert.title = "Switch Server"
    alert.body = "Switch to \(UserInfo.isStaging ? "Production" : "Staging")?"
    alert.add(.okay({
      UserInfo.isStaging.toggle()
    }))
    alert.add(.cancel())
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }
  
  @objc
  private func viewTermsAndConditions() {
    let safariViewController = SFSafariViewController(
      url: URL(string: "https://www.akfusa.org/website-private-policy")!)
    present(safariViewController, animated: true, completion: nil)
  }
}

// AKF-WCBackend
extension LoginV2ViewController {
  private func linkAKFBackend(fbid: String) {
    AKFCausesService.createParticipant(fbid: fbid) { [weak self] (_) in
      onMain {
        AppController.shared.login()
      }
      self?.addParticipantToDefaultEventIfNeeded(fbid: fbid)
    }
  }
  
  private func addParticipantToDefaultEventIfNeeded(fbid: String) {
    AKFCausesService.getParticipant(fbid: fbid) { (result) in
      if let participant = Participant(json: result.response), participant.currentEvent == nil {
        AKFCausesService.getEvents { (result) in
          let events = result.response?.arrayValue?.compactMap { Event(json: $0) }

          if let event = events?.first, let eventID = event.id {
            AKFCausesService.joinEvent(fbid: fbid, eventID: eventID, steps: event.defaultStepCount) { _ in
              NotificationCenter.default.post(name: .eventChanged, object: nil)
            }
          }
        }
      }
    }
  }
}

// Firebase
extension LoginV2ViewController {
  private func showFirebaseLoginErrorAlert(body: String) {
    let alert = AlertViewController()
    alert.title = "Error"
    alert.body = "Error while trying to login: \(body)"
    alert.add(.okay())
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }
}

// Social Logins
extension LoginV2ViewController {
  private func linkFirebase(_ credential: AuthCredential) {
    Auth.auth().signIn(with: credential) { [weak self] (result: AuthDataResult?, error: Error?) in
      guard let `self` = self else { return }
      
      guard let error = error else {
        if let result = result {
          // User is signed in
          self.linkAKFBackend(fbid: result.user.uid)
        } else {
          // This shouldn't happen and we don't have a way to recover except trying again.
          self.showFirebaseLoginErrorAlert(body: "Unknown Error")
        }
        
        return
      }
      
      // Don't handle errors
      // TODO(samisuteria): Handle MFA related errors
      self.showFirebaseLoginErrorAlert(body: error.localizedDescription)
    }
  }
  
  @objc
  private func facebookLoginButtonTapped() {
    let loginManager = LoginManager()
    loginManager.logIn(permissions: [.publicProfile], viewController: self) { [weak self] (result) in
      guard let `self` = self else { return }
      switch result {
      case .success(granted: _, declined: _, token: let accessToken):
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        self.linkFirebase(credential)
        print(credential)
      case .failed(let error):
        let alert = AlertViewController()
        alert.title = "Error"
        alert.body = "Got an error while trying to login with Facebook: \(error)."
        alert.add(.okay())
        AppController.shared.present(alert: alert, in: self, completion: nil)
      case .cancelled:
        let alert = AlertViewController()
        alert.title = "Cancelled"
        alert.body = "Its okay if you don't want to use Facebook."
        alert.add(.okay())
        AppController.shared.present(alert: alert, in: self, completion: nil)
      }
    }
  }
}
