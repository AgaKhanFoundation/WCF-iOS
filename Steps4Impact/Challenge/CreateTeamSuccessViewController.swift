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

class CreateTeamSuccessViewController: ViewController {
  private let checkmarkImageView = UIImageView(image: Assets.checkmark.image)
  private let titleLabel = UILabel(typography: .bodyRegular)
  private let lblNextSteps: UILabel = UILabel(typography: .bodyRegular)
  private let inviteButton = Button(style: .primary)
  private let btnContinue: Button = Button(style: .secondary)

  private let event: Event?

  public init(for event: Event?) {
    self.event = event
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func configureView() {
    super.configureView()

    title = Strings.Challenge.CreateTeam.title

    checkmarkImageView.contentMode = .scaleAspectFit

    titleLabel.text = Strings.Challenge.CreateTeam.successTitle
    titleLabel.textAlignment = .center

    lblNextSteps.text = "Next, invite friends to join. You have \((event?.teamLimit ?? 1) - 1) spots remaining on your team."
    lblNextSteps.textAlignment = .center

    inviteButton.title = "Invite Friends to Join"
    inviteButton.addTarget(self, action: #selector(inviteButtonTapped), for: .touchUpInside)

    btnContinue.title = Strings.Challenge.CreateTeam.continue
    btnContinue.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: Assets.close.image,
      style: .plain,
      target: self,
      action: #selector(closeButtonTapped))

    view.addSubview(checkmarkImageView) {
      $0.height.width.equalTo(100)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p32)
    }

    view.addSubview(titleLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(checkmarkImageView.snp.bottom).offset(Style.Padding.p32)
    }

    view.addSubview(lblNextSteps) { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      make.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p32)
    }

    // TODO(samisuteria) add image upload and visibility toggle

    let stack: UIStackView = UIStackView()
    stack.axis = .vertical
    stack.spacing = Style.Padding.p8
    stack.distribution = .fillEqually
    stack.addArrangedSubviews(inviteButton, btnContinue)

    view.addSubview(stack) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(lblNextSteps.snp.bottom).offset(Style.Padding.p24)
    }
  }

  @objc
  func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }

  @objc
  func inviteButtonTapped() {
    AppController.shared.shareTapped(
      viewController: self,
      shareButton: inviteButton,
      string: Strings.Share.item)
  }

  @objc
  private func continueTapped() {
    self.dismiss(animated: true)
  }
}
