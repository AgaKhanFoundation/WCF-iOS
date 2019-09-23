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

class InviteSupportersViewController: ViewController {
  private var lblGetSupported: UILabel = UILabel(typography: .bodyBold)
  private var btnInviteSupporters: Button = Button(style: .primary)

  override func configureView() {
    super.configureView()

    title = Strings.InviteSupporters.title

    lblGetSupported.text = Strings.InviteSupporters.getSupported
    view.addSubview(lblGetSupported) { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      make.top.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p32)
    }

    btnInviteSupporters.title = Strings.InviteSupporters.inviteSupporters
    btnInviteSupporters.addTarget(self, action: #selector(invite),
                                  for: .touchUpInside)
    view.addSubview(btnInviteSupporters) { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      make.top.equalTo(lblGetSupported.snp.bottom).offset(Style.Padding.p32)
    }
  }

  @objc
  private func invite() {
    AppController.shared.shareTapped(viewController: self,
                                     shareButton: btnInviteSupporters,
                                     string: Strings.InviteSupporters.request)

  }
}
