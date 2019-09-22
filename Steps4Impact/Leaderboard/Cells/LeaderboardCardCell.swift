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

struct LeaderboardCardCellContext: CellContext {
  let identifier: String = LeaderboardCardCell.identifier
  let teams: [Team]
  let userTeam: Team?
}

struct RankingContext: Context {
  let rank: Int
  let name: String
  let dist: String
  let isUserTeam: Bool
}

class LeaderboardCardCell: ConfigurableTableViewCell {
  static let identifier = "LeaderboardCardCell"
  private let cardView = CardViewV2()
  private let leadersView = LeadersView()
  private let content = View()
  private let leaderboardView = LeaderboardView()
  override func commonInit() {
    super.commonInit()
    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }
    cardView.addSubview(content) {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalToSuperview()
      $0.height.equalTo(650)
    }
    content.addSubview(leadersView) {
      $0.leading.trailing.top.equalToSuperview().inset(Style.Padding.p8)
      $0.height.equalTo(216)
    }
    content.addSubview(leaderboardView) {
      $0.leading.trailing.bottom.equalToSuperview().inset(Style.Padding.p8)
      $0.top.equalTo(leadersView.snp.bottom)
    }
    cardView.addSubview(UIView(frame: .zero)) {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(content.snp.bottom)
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  func configure(context: CellContext) {
    guard let context = context as? LeaderboardCardCellContext else { return }
    leadersView.configure(context: context)
    leaderboardView.configure(context: context)
  }
}
