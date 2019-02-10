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

class ChallengeCardView: StylizedCardView {
  private var lblTitle: UILabel = UILabel(frame: .zero)
  private var lblDistance: UILabel = UILabel(frame: .zero)
  private var prgDistance: UIProgressView =
      UIProgressView(progressViewStyle: .default)
  private var lblDays: UILabel = UILabel(frame: .zero)
  private var prgDays: UIProgressView =
      UIProgressView(progressViewStyle: .default)
  private var btnJoinChallenge: UIButton = UIButton(type: .system)

  internal func layout() {
    addSubviews([lblTitle, prgDistance, lblDistance, prgDays, lblDays,
                 btnJoinChallenge])

    lblTitle.text = Strings.ChallengeCard.title
    lblTitle.textColor = .black
    lblTitle.font = lblTitle.font.withSize(16)
    lblTitle.snp.makeConstraints {
      $0.left.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalToSuperview().inset(Style.Padding.p16)
    }

    layoutDetails()

    btnJoinChallenge.setTitle(Strings.ChallengeCard.joinChallenge, for: .normal)
    btnJoinChallenge.snp.makeConstraints {
      $0.top.equalTo(prgDays.snp.bottom)
      $0.left.equalTo(prgDays.snp.left)
      $0.bottom.equalToSuperview().inset(Style.Padding.p8)
    }
  }

  private func layoutDetails() {
    prgDistance.layer.cornerRadius = Style.Size.s16
    prgDistance.layer.masksToBounds = true
    prgDistance.snp.makeConstraints {
      $0.top.equalTo(lblTitle.snp.bottom).offset(Style.Padding.p16)
      $0.left.equalToSuperview().offset(Style.Padding.p16)
      $0.height.greaterThanOrEqualTo(prgDistance.layer.cornerRadius * 2)
      $0.width.equalTo(prgDays.snp.width)
    }

    lblDistance.text = "0 / 0 mi"
    lblDistance.snp.makeConstraints {
      $0.centerY.equalTo(prgDistance.snp.centerY)
      $0.left.equalTo(prgDistance.snp.right).offset(Style.Padding.p16)
      $0.right.equalToSuperview().inset(Style.Padding.p16)
      $0.width.equalTo(lblDays.snp.width)
    }

    prgDays.layer.cornerRadius = Style.Size.s16
    prgDays.layer.masksToBounds = true
    prgDays.snp.makeConstraints {
      $0.top.equalTo(prgDistance.snp.bottom).offset(Style.Padding.p16)
      $0.left.equalToSuperview().offset(Style.Padding.p16)
      $0.height.greaterThanOrEqualTo(prgDays.layer.cornerRadius * 2)
      $0.width.equalTo(prgDistance.snp.width)
    }

    lblDays.text = "0 / 0 days"
    lblDays.snp.makeConstraints {
      $0.centerY.equalTo(prgDays.snp.centerY)
      $0.left.equalTo(prgDays.snp.right).offset(Style.Padding.p16)
      $0.right.equalToSuperview().inset(Style.Padding.p16)
      $0.width.equalTo(lblDistance.snp.width)
    }
  }
}

extension ChallengeCardView: CardView {
  static let identifier: String = "Challenge"

  func render(_ context: Any) {
    guard let data = context as? ChallengeCard else { return }
    _ = data
  }
}

struct ChallengeCard: Card {
  let renderer: String = ChallengeCardView.identifier
}
