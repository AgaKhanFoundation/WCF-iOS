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
import UIKit

class WelcomeViewController : UIViewController {                                // swiftlint:disable:this colon
  private let lblTitle: UILabel =
      UILabel(typography: .headerTitle)
  private let imgImage: UIImageView =
      UIImageView(image: UIImage(imageLiteralResourceName: Assets.LoginPeople))
  private let lblThanks: UILabel =
      UILabel(typography: .bodyRegular, color: Style.Colors.green)
  private let btnContinue: UIButton =
      UIButton(type: .roundedRect)
  private let btnSkip: UIButton =
      UIButton(type: .system)

  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }

  private func layout() {                                                       // swiftlint:disable:this function_body_length line_length
    self.view.backgroundColor = .white

    self.view.addSubviews([lblTitle, imgImage, lblThanks, btnContinue, btnSkip])

    lblTitle.text = Strings.Welcome.title
    lblTitle.textColor = Style.Colors.green
    lblTitle.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(Style.Size.s64)
      make.left.equalToSuperview().offset(Style.Size.s24)
      make.right.equalToSuperview().inset(Style.Size.s24)
    }

    imgImage.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(Style.Size.s16)
      make.right.equalToSuperview().inset(Style.Size.s16)
      make.centerY.equalToSuperview()

      // TODO(compnerd) figure out how to make this scale instead
      make.height.equalTo(221)
    }

    lblThanks.text = Strings.Welcome.thanks
    lblThanks.textAlignment = .center
    lblThanks.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(imgImage.snp.bottom).offset(Style.Size.s48)
    }

    btnContinue.layer.borderColor = Style.Colors.green.cgColor
    btnContinue.layer.borderWidth = 1
    btnContinue.layer.cornerRadius = 4
    btnContinue.setTitle(Strings.Welcome.continue, for: .normal)
    btnContinue.setTitleColor(Style.Colors.green, for: .normal)
    btnContinue.titleLabel?.font = Style.Typography.subtitleBold.font
    btnContinue.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(Style.Size.s32)
      make.right.equalToSuperview().inset(Style.Size.s32)
      make.height.equalTo(Style.Size.s40)
    }
    btnContinue.addTarget(self, action: #selector(`continue`),
                          for: .touchUpInside)

    let attributes: [NSAttributedString.Key:Any] = [                            // swiftlint:disable:this colon
      .underlineStyle:NSUnderlineStyle.single.rawValue,                         // swiftlint:disable:this colon
      .foregroundColor:Style.Colors.black,                                      // swiftlint:disable:this colon
      .font:Style.Typography.smallRegular.font!                                 // swiftlint:disable:this colon
    ]
    btnSkip.setAttributedTitle(NSAttributedString(string: Strings.Welcome.skip,
                                                  attributes: attributes),
                               for: .normal)
    btnSkip.snp.makeConstraints { (make) in
      make.top.equalTo(btnContinue.snp.bottom).offset(Style.Size.s16)
      make.bottom.equalToSuperview().inset(Style.Size.s48)
      make.centerX.equalToSuperview()
    }
    btnSkip.addTarget(self, action: #selector(skip), for: .touchUpInside)
  }

  @objc
  func skip(sender: UIButton!) {
    AppController.shared.transition(to: .navigation)
  }

  @objc
  func `continue`(sender: UIButton!) {
    AppController.shared.transition(to: .onboarding)
  }
}
