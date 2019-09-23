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

class RankingView: View {
  private let circularView: View = {
    let view = View()
    view.layer.cornerRadius = Style.Size.s32
    return view
  }()
  private let placeLbl: UILabel = UILabel(typography: .headerTitle, color: Style.Colors.white)
  private let teamLbl: UILabel = {
    let lbl = UILabel(typography: .smallRegular)
    lbl.textAlignment = .center
    lbl.numberOfLines = 2
    lbl.text = Strings.Leaderboard.blank
    return lbl
  }()
  private let distLbl: UILabel = {
    let lbl = UILabel(typography: .footnote, color: Style.Colors.grey)
    lbl.textAlignment = .center
    lbl.numberOfLines = 2
    lbl.text = Strings.Leaderboard.blank
    return lbl
  }()

  override func commonInit() {
    super.commonInit()

    addSubview(circularView) {
      $0.top.centerX.equalToSuperview()
      $0.height.width.equalTo(Style.Size.s64)
    }

    circularView.addSubview(placeLbl) {
      $0.centerX.centerY.equalToSuperview()
    }

    addSubview(teamLbl) {
      $0.leading.equalToSuperview().offset(Style.Padding.p8)
      $0.trailing.equalToSuperview().offset(-Style.Padding.p8)
      $0.top.equalTo(circularView.snp.bottom).offset(Style.Padding.p2)
      $0.height.lessThanOrEqualTo(Style.Size.s32)
    }

    addSubview(distLbl) {
      $0.leading.equalToSuperview().offset(Style.Padding.p8)
      $0.trailing.equalToSuperview().offset(-Style.Padding.p8)
      $0.top.equalTo(teamLbl.snp.bottom).offset(Style.Padding.p2)
      $0.height.lessThanOrEqualTo(Style.Size.s16)
    }
  }
  func configure(context: RankingContext) {
    placeLbl.text = "\(context.rank)"
    teamLbl.text = context.name
    distLbl.text = context.dist + " mi"
  }
}

extension RankingView {
  func setColor(rank: Int) {
    if rank == 0 {
      circularView.backgroundColor = Style.Colors.EarthyGold
    } else if rank == 1 {
      circularView.backgroundColor = Style.Colors.Silver
    } else {
      circularView.backgroundColor = #colorLiteral(red: 0.7843137255, green: 0.4078431373, blue: 0.1921568627, alpha: 1) // #c86831
    }
  }
}
