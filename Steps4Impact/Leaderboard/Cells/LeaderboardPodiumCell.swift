//
//  LeaderboardPodiumCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/24/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit

struct LeaderboardPodiumContext: CellContext {
  var identifier: String = LeaderboardPodiumCell.identifier
  var count: Int = 0
  var data = [Leaderboard]()
}

class LeaderboardPodiumCell: ConfigurableTableViewCell {
  static var identifier: String = "LeaderboardPodiumCell"
  let stackView: UIStackView = {
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
    for i in 0..<podiumCellContext.count {

      let teamNameLabel = TeamNameLabel()
      let teamDistanceLabel = TeamDistanceLabel()
      let rankView = RankView(rank: i+1)
      let podiumView = UIView(frame: .zero)

      podiumView.addSubview(rankView) {
        $0.top.equalToSuperview().offset(Style.Padding.p12 + CGFloat(i * 30))
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
        if i == podiumCellContext.count-1 {
          $0.bottom.equalToSuperview().inset(Style.Padding.p12)
        }
      }
      if i == 1 && podiumCellContext.count == 3 {
        let lastIndex = stackView.arrangedSubviews.count-1
        let firstPodiumView = stackView.arrangedSubviews[lastIndex]
        stackView.insertArrangedSubview(podiumView, at: 0)
        stackView.addArrangedSubview(firstPodiumView)
      } else {
        stackView.addArrangedSubview(podiumView)
      }

      teamNameLabel.text = podiumCellContext.data[i].name
      teamDistanceLabel.text = "\(podiumCellContext.data[i].distance ?? 0) mi"
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

  let rankLabel: UILabel = {
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
