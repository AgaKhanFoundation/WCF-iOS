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

class LoginViewController: UIViewController {
  let titleLabel = UILabel(.header)
  let desciptionLabel = UILabel(.body)
  let btnLogin: LoginButton =
      LoginButton(readPermissions: [.publicProfile, .email, .userFriends,
                                    .custom("user_location")])

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureLabels()
    configureView()
  }

  // MARK: - Configure

  private func configureLabels() {
    titleLabel.text = Strings.Login.title
    desciptionLabel.text = Strings.Login.desciption

    titleLabel.textAlignment = .center
    desciptionLabel.textAlignment = .center
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    view.addSubviews([titleLabel, desciptionLabel, btnLogin])

    titleLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.centerY.equalToSuperview().offset(-Style.Padding.p48)
    }

    desciptionLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p24)
    }

    btnLogin.delegate = self
    btnLogin.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(desciptionLabel.snp.bottom).offset(Style.Padding.p24)
    }
  }
}

extension LoginViewController: LoginButtonDelegate {
  func loginButtonDidCompleteLogin(_ loginButton: LoginButton,
                                   result: LoginResult) {
    switch result {
    case .success(_, _, _):
      AppController.shared.login()
      break
    case .cancelled:
      break
    case .failed(let error):
      alert(message: "Error logging in \(error)", style: .cancel)
      break
    }
  }

  func loginButtonDidLogOut(_ loginButton: LoginButton) {
    // Left blank on purpose since the user shouldn't be logged in on this view
    // controller
  }
}
