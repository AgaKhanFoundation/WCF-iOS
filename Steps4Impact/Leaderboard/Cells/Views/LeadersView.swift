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

class LeadersView: View {
  private let firstPlace: RankingView = {
    let view = RankingView()
    view.setColor(rank: 0)
    return view
  }()
  private let secondPlace: RankingView = {
    let view = RankingView()
    view.setColor(rank: 1)
    return view
  }()
  private let thirdPlace: RankingView = {
    let view = RankingView()
    view.setColor(rank: 2)
    return view
  }()
  override func commonInit() {
    super.commonInit()
    addSubview(firstPlace) {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.height.equalTo(Style.Size.s128)
      $0.width.equalTo(Style.Size.s128)
    }
    addSubview(secondPlace) {
      $0.top.equalTo(firstPlace.snp.bottom).offset(-Style.Padding.p64)
      $0.right.equalTo(firstPlace.snp.left).offset(Style.Padding.p40)
      $0.height.equalTo(Style.Size.s128)
      $0.width.equalTo(Style.Size.s128)
    }
    addSubview(thirdPlace) {
      $0.top.equalTo(firstPlace.snp.bottom).offset(-Style.Padding.p32)
      $0.left.equalTo(firstPlace.snp.right).offset(-Style.Padding.p40)
      $0.height.equalTo(Style.Size.s128)
      $0.width.equalTo(Style.Size.s128)
    }
  }
  func configure(context: LeaderboardCardCellContext) {
    let teams = context.teams
    var isUserTeam = false
    for rank in 0..<teams.count {
      if context.userTeam != nil && teams[rank] == context.userTeam {
        isUserTeam = true
      }
      switch rank {
      case 0:
        firstPlace.configure(context: RankingContext(
          rank: 1,
          name: teams[rank].name ?? Strings.Leaderboard.blank,
          dist: "\(teams[rank].calculateDist())",
          isUserTeam: isUserTeam))
      case 1:
        secondPlace.configure(context: RankingContext(
          rank: 2,
          name: teams[rank].name ?? Strings.Leaderboard.blank,
          dist: "\(teams[rank].calculateDist())",
          isUserTeam: isUserTeam))
      default:
        thirdPlace.configure(context: RankingContext(
          rank: 3,
          name: teams[rank].name ?? Strings.Leaderboard.blank,
          dist: "\(teams[rank].calculateDist())",
          isUserTeam: isUserTeam))
      }
    }
  }
}
