/**
* Copyright © 2020 Aga Khan Foundation
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
import GoogleSignIn
import AuthenticationServices

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
  
  private var currentAppleNonce: String?
  
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
    
    googleLoginButton.addTarget(self,
                                action: #selector(googleLoginButtonTapped),
                                for: .touchUpInside)
    
    // Setup Notifications for Google Sign In since it doesn't have a completion block.
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleGoogleSignInSuccess(notification:)),
                                           name: .googleSignInSuccess,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleGoogleSignInFailure(notification:)),
                                           name: .googleSigninFailure,
                                           object: nil)
    
    
    appleLoginButton.addTarget(self,
                               action: #selector(appleLoginButtonTapped),
                               for: .touchUpInside)
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
  
  deinit {
    NotificationCenter.default.removeObserver(self)
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
  private func linkAKFBackend(fbid: String) -> Bool {
    var linked: Bool = false
    AKFCausesService.getParticipant(fbid: fbid) { [weak self] (result) in
      guard result.isSuccess else {
        AKFCausesService.createParticipant(fbid: fbid) { [weak self] (result) in
          guard result.isSuccess else {
            self?.alert(message: "Sign In failed. Please try again")
            return
          }
        }
      }
      linked = true
    }
    return linked
  }

  private func addParticipantToDefaultEventIfNeeded(fbid: String) {
    AKFCausesService.getParticipant(fbid: fbid) { (result) in
      guard let participant = Participant(json: result.response) else { return }
      guard participant.currentEvent == nil else { return }
      
      AKFCausesService.getEvents { (result) in
        let events = result.response?.arrayValue?.compactMap { Event(json: $0) }
        guard let event = events?.first, let eventID = event.id else { return }
        
        AKFCausesService.joinEvent(fbid: fbid, eventID: eventID, steps: event.defaultStepCount) { _ in
          NotificationCenter.default.post(name: .eventChanged, object: nil)
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
  private func handleFirebaseErrors(error: Error?) {
    guard let error = error else {
      showFirebaseLoginErrorAlert(body: "Unknown Error")
      return
    }
    
    // There could be multiple errors why Firebase doesn't link the user's social cred account
    // List is here: https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Enums/FIRAuthErrorCode
    // Common one Firebase discusses is accounts with MFA turned on
    // TODO(samisuteria): Handle MFA related errors
    showFirebaseLoginErrorAlert(body: error.localizedDescription)
  }
  
  private func linkFirebase(_ credential: AuthCredential) {
    Auth.auth().signIn(with: credential) { [weak self] (result: AuthDataResult?, error: Error?) in
      guard let `self` = self else { return }
      
      guard error == nil else {
        self.handleFirebaseErrors(error: error)
        return
      }
      
      guard let result = result else {
        // This shouldn't happen if error == nil and we don't have a way to recover except trying again.
        self.showFirebaseLoginErrorAlert(body: "Unknown Error")
        return
      }
      
      if self.linkAKFBackend(fbid: result.user.uid) {
        onMain {
          AppController.shared.login()
        }
        self.addParticipantToDefaultEventIfNeeded(fbid: result.user.uid)
      }
    }
  }
  
  @objc
  private func handleGoogleSignInSuccess(notification: Foundation.Notification) {
    guard let credentials = notification.object as? AuthCredential else {
      // This shouldn't happen at this point
      handleFirebaseErrors(error: nil)
      return
    }
    
    linkFirebase(credentials)
  }
  
  @objc
  private func handleGoogleSignInFailure(notification: Foundation.Notification) {
    handleFirebaseErrors(error: notification.object as? Error)
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
  
  @objc
  private func googleLoginButtonTapped() {
    GIDSignIn.sharedInstance()?.presentingViewController = self
    GIDSignIn.sharedInstance()?.signIn()
  }
  
  @objc
  private func appleLoginButtonTapped() {
    if #available(iOS 13, *) {
      let appleHelper = AppleSignInHelper(delegate: self, presentationContextProvider: self)
      appleHelper.startSignInWithAppleFlow()
      currentAppleNonce = appleHelper.currentNonce
    } else {
      let alert = AlertViewController()
      alert.title = "Error"
      alert.body = "Apple Sign In is only available on iOS 13 and above."
      alert.add(.okay())
      AppController.shared.present(alert: alert, in: self, completion: nil)
    }
  }
}

@available(iOS 13.0, *)
extension LoginV2ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return AppController.shared.window ?? UIWindow()
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard
      let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
      let nonce = currentAppleNonce,
      let appleIDToken = appleIDCredential.identityToken,
      let idTokenString = String(data: appleIDToken, encoding: .utf8)
    else {
      let alert = AlertViewController()
      alert.title = "Error"
      alert.body = "Unable to Sign in with Apple"
      alert.add(.okay())
      AppController.shared.present(alert: alert, in: self, completion: nil)
      return
    }
    
    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
    linkFirebase(credential)
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    let alert = AlertViewController()
    alert.title = "Error"
    alert.body = "Unable to Sign in with Apple: \(error.localizedDescription)"
    alert.add(.okay())
    AppController.shared.present(alert: alert, in: self, completion: nil)
  }
}
