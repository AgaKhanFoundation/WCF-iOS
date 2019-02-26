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
import Foundation

class FundraisingCardView: StylizedCardView {
  private var lblTitle: UILabel = UILabel(typography: .bodyBold)
  private var prgProgress: UIProgressView =
      UIProgressView(progressViewStyle: .default)
  private var lblProgress: UILabel = UILabel(frame: .zero)
  private var btnInviteSuppoters: UIButton = UIButton(type: .system)
  private var btnViewSupporters: UIButton = UIButton(type: .system)

  internal func layout() {
    lblTitle.text = Strings.FundraisingCard.title
    addSubview(lblTitle)
    lblTitle.snp.makeConstraints {
      $0.left.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalToSuperview().inset(Style.Padding.p16)
    }

    addSubview(prgProgress)
    prgProgress.layer.cornerRadius = Style.Size.s16
    prgProgress.layer.masksToBounds = true
    prgProgress.snp.makeConstraints {
      $0.top.equalTo(lblTitle.snp.bottom).offset(Style.Padding.p16)
      $0.left.equalToSuperview().offset(Style.Padding.p16)
      $0.height.equalTo(prgProgress.layer.cornerRadius * 2.0)
    }

    addSubview(lblProgress)
    lblProgress.text = "$0 / $0"
    lblProgress.snp.makeConstraints {
      $0.right.equalToSuperview().inset(Style.Padding.p16)
      $0.left.equalTo(prgProgress.snp.right).offset(Style.Padding.p16)
      $0.centerY.equalTo(prgProgress.snp.centerY)
    }

    addSubview(btnInviteSuppoters)
    btnInviteSuppoters.setTitle(Strings.FundraisingCard.inviteSupporters,
                                for: .normal)
    btnInviteSuppoters.snp.makeConstraints {
      $0.top.equalTo(prgProgress.snp.bottom)
      $0.left.equalTo(prgProgress.snp.left)
    }

    addSubview(btnViewSupporters)
    btnViewSupporters.setTitle(Strings.FundraisingCard.viewSupporters,
                               for: .normal)
    btnViewSupporters.snp.makeConstraints {
      $0.top.equalTo(btnInviteSuppoters.snp.bottom).offset(Style.Padding.p8)
      $0.right.equalToSuperview().inset(Style.Padding.p16)
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
    }
  }
}

extension FundraisingCardView: CardView {
  static let identifier: String = "Fundraising"

  func render(_ context: Any) {
    guard let data = context as? FundraisingCard else { return }
    _ = data
  }
}

struct FundraisingCard: Card {
  let renderer: String = FundraisingCardView.identifier
}
