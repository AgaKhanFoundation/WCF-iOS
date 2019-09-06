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
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
  let imgLogo: UIImageView =
      UIImageView(image: UIImage(cgImage: Assets.AKFLogo.image!.cgImage!,
                                 scale: 4.0, orientation: .up))
  let lblTitle: UILabel = UILabel(typography: .onboarding)
  let imgImage: UIImageView =
      UIImageView(image: Assets.LoginPeople.image)
  let btnLogin: LoginButton =
    LoginButton(readPermissions: [.publicProfile, .custom("user_location")])
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
      make.top.equalTo(topLayoutGuide.snp.bottom).offset(Style.Size.s24)
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
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton,
                                   result: LoginResult) {
    switch result {
    case .success:
      AKFCausesService.createParticipant(fbid: Facebook.id)
      AppController.shared.login()
    case .cancelled:
      break
    case .failed(let error):
      alert(message: "Error logging in \(error)", style: .cancel)
    }
  }

  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    fatalError("user logged in without a session?")
  }
}
