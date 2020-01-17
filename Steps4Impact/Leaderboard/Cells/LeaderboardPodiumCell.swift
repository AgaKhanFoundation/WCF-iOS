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

struct LeaderboardPodiumContext: CellContext {
  let identifier: String = LeaderboardPodiumCell.identifier
  let count: Int
  let data: [Leaderboard]

  init(count: Int = 0, data: [Leaderboard] = []) {
    self.count = count
    self.data = data
  }
}

class LeaderboardPodiumCell: ConfigurableTableViewCell {
  static var identifier: String = "LeaderboardPodiumCell"

  private let stackView: UIStackView = {
    let stack = UIStackView(frame: .zero)
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .fillEqually
    return stack
  }()

  override func commonInit() {
    super.commonInit()
    contentView.addSubview(stackView) {
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
  }

  func configure(context: CellContext) {
    guard let podiumCellContext = context as? LeaderboardPodiumContext else { return }
    for view in stackView.arrangedSubviews {
      view.removeFromSuperview()
    }

    for index in 0..<podiumCellContext.count {

      let teamNameLabel = TeamNameLabel()
      let teamDistanceLabel = TeamDistanceLabel()
      let rankView = RankView(rank: index+1)
      let podiumView = UIView(frame: .zero)

      podiumView.addSubview(rankView) {
        $0.top.equalToSuperview().offset(Style.Padding.p12 + CGFloat(index * 30))
        $0.centerX.equalToSuperview()
        $0.width.height.equalTo(90)
      }
      podiumView.addSubview(teamNameLabel) {
        $0.top.equalTo(rankView.snp.bottom).offset(Style.Padding.p4)
        $0.leading.equalToSuperview().offset(Style.Padding.p4)
        $0.trailing.equalToSuperview().inset(Style.Padding.p4)
      }
      podiumView.addSubview(teamDistanceLabel) {
        $0.top.equalTo(teamNameLabel.snp.bottom).offset(Style.Padding.p4)
        $0.leading.equalToSuperview().offset(Style.Padding.p4)
        $0.trailing.equalToSuperview().inset(Style.Padding.p4)
        if index == podiumCellContext.count-1 {
          $0.bottom.equalToSuperview().inset(Style.Padding.p12)
        }
      }
      if index == 1 && podiumCellContext.count == 3 {
        let lastIndex = stackView.arrangedSubviews.count-1
        let firstPodiumView = stackView.arrangedSubviews[lastIndex]
        stackView.insertArrangedSubview(podiumView, at: 0)
        stackView.addArrangedSubview(firstPodiumView)
      } else {
        stackView.addArrangedSubview(podiumView)
      }

      teamNameLabel.text = podiumCellContext.data[index].name
      teamDistanceLabel.text = "\(podiumCellContext.data[index].miles ?? 0) mi"
    }
  }
}

class TeamNameLabel: UILabel {
  init() {
    super.init(frame: .zero)
    self.font = Style.Typography.bodyRegular.font
    self.textColor = Style.Colors.black
    self.numberOfLines = 0
    self.textAlignment = .center
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class TeamDistanceLabel: UILabel {
  init() {
    super.init(frame: .zero)
    self.font = Style.Typography.smallRegular.font
    self.textColor = Style.Colors.grey
    self.numberOfLines = 0
    self.textAlignment = .center
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class RankView: UIView {

  private let rankLabel: UILabel = {
    let label = UILabel(typography: .headerTitle)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()

  init(rank: Int) {
    super.init(frame: .zero)
    self.addSubview(rankLabel) {
      $0.top.left.right.bottom.equalToSuperview()
    }
    rankLabel.text = "\(rank)"
    self.layer.cornerRadius = 45
    switch rank {
    case 1:
      self.backgroundColor = Style.Colors.EarthyGold
    case 2:
      self.backgroundColor = Style.Colors.FoundationGrey
    case 3:
      self.backgroundColor = Style.Colors.RubineRed
    default:
      self.backgroundColor = Style.Colors.EarthyGold
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
