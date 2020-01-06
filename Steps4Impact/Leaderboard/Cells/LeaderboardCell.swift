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

import Foundation
import UIKit

struct LeaderboardContext: CellContext {
  let identifier: String = LeaderboardCell.identifier
  let rank: Int
  let teamName: String
  let teamDistance: Int
  let isMyTeam: Bool

  init(rank: Int = 0, teamName: String = "", teamDistance: Int = 0, isMyTeam: Bool = false) {
    self.rank = rank
    self.teamName = teamName
    self.teamDistance = teamDistance
    self.isMyTeam = isMyTeam
  }
}

class LeaderboardCell: ConfigurableTableViewCell {
  static var identifier: String = "LeaderboardCell"

  private let rankLabel: UILabel = {
    let label = UILabel(typography: .rowTitleRegular, color: Style.Colors.FoundationGrey)
    label.textAlignment = .left
    return label
  }()
  private let teamNameLabel: UILabel = {
    let label = UILabel(typography: .rowTitleRegular, color: Style.Colors.FoundationGrey)
    label.textAlignment = .left
    return label
  }()
  private let teamDistanceLabel: UILabel = {
    let label = UILabel(typography: .bodyRegular, color: Style.Colors.grey)
    label.textAlignment = .right
    return label
  }()
  private let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = Style.Colors.Seperator
    return view
  }()

  override func commonInit() {
    super.commonInit()

    contentView.addSubview(rankLabel) {
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.width.equalTo(Style.Size.s40)
      $0.height.equalTo(Style.Size.s24)
      $0.centerY.equalToSuperview()
    }

    contentView.addSubview(teamNameLabel) {
      $0.leading.equalTo(rankLabel.snp.trailing).offset(Style.Padding.p8)
      $0.bottom.equalToSuperview().inset(Style.Padding.p20)
      $0.centerY.equalToSuperview()

    }
    contentView.addSubview(teamDistanceLabel) {
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.leading.equalTo(teamNameLabel.snp.trailing).offset(Style.Padding.p16)
      $0.width.equalTo(Style.Size.s64)
      $0.height.equalTo(Style.Size.s24)
      $0.centerY.equalToSuperview()
    }
    contentView.addSubview(lineView) {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(0.5)
    }
  }

  func configure(context: CellContext) {
    guard let cellContext = context as? LeaderboardContext else { return }

    if cellContext.isMyTeam {
      rankLabel.textColor = .green
      teamNameLabel.textColor = .green
      teamDistanceLabel.textColor = .green
    } else {
      rankLabel.textColor = Style.Colors.FoundationGrey
      teamNameLabel.textColor = Style.Colors.FoundationGrey
      teamDistanceLabel.textColor = Style.Colors.grey
    }
    rankLabel.text = "\(cellContext.rank)."
    teamNameLabel.text = "\(cellContext.teamName)"
    teamDistanceLabel.text = "\(cellContext.teamDistance) mi"
  }
}
