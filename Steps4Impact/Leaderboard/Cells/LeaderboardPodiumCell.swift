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
//  var firstTeamName: String = ""
//  var firstTeamDistance: Int = 0
//  var secondTeamName: String = ""
//  var secondTeamDistance: Int = 0
//  var thirdTeamName: String = ""
//  var thirdTeamDistance: Int = 0

  var count: Int = 0
  var data = [DemoLeaderboard]()

}

class LeaderboardPodiumCell: ConfigurableTableViewCell {
  static var identifier: String = "LeaderboardPodiumCell"
//
//  let firstTeamNameLabel = TeamNameLabel()
//  let firstTeamDistanceLabel = TeamDistanceLabel()
//  let firstRankView = RankView(rank: 1)
//  let firstPodiumView = UIView(frame: .zero)
//
//  let secondTeamNameLabel = TeamNameLabel()
//  let secondTeamDistanceLabel = TeamDistanceLabel()
//  let secondRankView = RankView(rank: 2)
//  let secondPodiumView = UIView(frame: .zero)
//
//  let thirdTeamNameLabel = TeamNameLabel()
//  let thirdTeamDistanceLabel = TeamDistanceLabel()
//  let thirdRankView = RankView(rank: 3)
//  let thirdPodiumView = UIView(frame: .zero)

//  let secondTeamNameLabel: UILabel = {
//    let label = UILabel(typography: .smallRegular)
//    label.textColor = Style.Colors.black
//    label.textAlignment = .center
//    return label
//  }()
//  let secondTeamDistanceLabel: UILabel = {
//    let label = UILabel(typography: .footnote)
//    label.textColor = Style.Colors.green
//    label.textAlignment = .center
//    return label
//  }()
//  let secondOval: UIView = {
//    let view = UIView(frame: .zero)
//    view.layer.cornerRadius = 45
//    view.backgroundColor = Style.Colors.FoundationGrey
//    return view
//  }()
//  let secondPodiumView = UIView(frame: .zero)
//
//  let thirdTeamNameLabel: UILabel = {
//    let label = UILabel(typography: .smallRegular)
//    label.textColor = Style.Colors.black
//    label.textAlignment = .center
//    return label
//  }()
//  let thirdTeamDistanceLabel: UILabel = {
//    let label = UILabel(typography: .footnote)
//    label.textColor = Style.Colors.green
//    label.textAlignment = .center
//    return label
//  }()
//  let thirdOval: UIView = {
//    let view = UIView(frame: .zero)
//    view.layer.cornerRadius = 45
//    view.backgroundColor = Style.Colors.RubineRed
//    return view
//  }()
//  let thirdPodiumView = UIView(frame: .zero)

  let stackView: UIStackView = {
    let stack = UIStackView(frame: .zero)
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .fillEqually
    return stack
  }()

  override func commonInit() {
    super.commonInit()
    contentView.backgroundColor = Style.Colors.grey

//    firstPodiumView.addSubview(firstRankView) {
//      $0.top.equalToSuperview().offset(Style.Padding.p8)
//      $0.centerX.equalToSuperview()
//      $0.width.height.equalTo(90)
//    }
//    firstPodiumView.addSubview(firstTeamNameLabel) {
//      $0.top.equalTo(firstRankView.snp.bottom).offset(Style.Padding.p4)
//      $0.leading.equalToSuperview().offset(Style.Padding.p4)
//      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
//    }
//    firstPodiumView.addSubview(firstTeamDistanceLabel) {
//      $0.top.equalTo(firstTeamNameLabel.snp.bottom).offset(Style.Padding.p4)
//      $0.leading.equalToSuperview().offset(Style.Padding.p4)
//      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
//    }
//    secondPodiumView.addSubview(secondRankView) {
//      $0.top.equalToSuperview().offset(Style.Padding.p48)
//      $0.centerX.equalToSuperview()
//      $0.width.height.equalTo(90)
//    }
//    secondPodiumView.addSubview(secondTeamNameLabel) {
//      $0.top.equalTo(secondRankView.snp.bottom).offset(Style.Padding.p4)
//      $0.leading.equalToSuperview().offset(Style.Padding.p4)
//      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
//    }
//    secondPodiumView.addSubview(secondTeamDistanceLabel) {
//      $0.top.equalTo(secondTeamNameLabel.snp.bottom).offset(Style.Padding.p4)
//      $0.leading.equalToSuperview().offset(Style.Padding.p4)
//      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
//    }
//    thirdPodiumView.addSubview(thirdRankView) {
//      $0.top.equalToSuperview().offset(Style.Padding.p64)
//      $0.centerX.equalToSuperview()
//      $0.width.height.equalTo(90)
//    }
//    thirdPodiumView.addSubview(thirdTeamNameLabel) {
//      $0.top.equalTo(thirdRankView.snp.bottom).offset(Style.Padding.p4)
//      $0.leading.equalToSuperview().offset(Style.Padding.p4)
//      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
//    }
//    thirdPodiumView.addSubview(thirdTeamDistanceLabel) {
//      $0.top.equalTo(thirdTeamNameLabel.snp.bottom).offset(Style.Padding.p4)
//      $0.leading.equalToSuperview().offset(Style.Padding.p4)
//      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
//      $0.bottom.equalToSuperview().inset(Style.Padding.p4)
//    }
//    stackView.addArrangedSubviews(secondPodiumView,firstPodiumView,thirdPodiumView)
//    contentView.addSubview(stackView) {
//      $0.top.bottom.leading.trailing.equalToSuperview()
//    }

//    for i in 0..<3 {
//      firstPodiumView.addSubview(fi) {
//        $0.top.equalToSuperview().offset(Style.Padding.p8 + CGFloat(i * 30))
//        $0.centerX.equalToSuperview()
//        $0.width.height.equalTo(90)
//      }
//      firstPodiumView.addSubview(firstTeamNameLabel) {
//        $0.top.equalTo(firstOval.snp.bottom).offset(Style.Padding.p4)
//        $0.leading.equalToSuperview().offset(Style.Padding.p4)
//        $0.trailing.equalToSuperview().inset(Style.Padding.p4)
//      }
//      firstPodiumView.addSubview(firstTeamDistanceLabel) {
//        $0.top.equalTo(firstTeamNameLabel.snp.bottom).offset(Style.Padding.p4)
//        $0.leading.equalToSuperview().offset(Style.Padding.p4)
//        $0.trailing.equalToSuperview().inset(Style.Padding.p4)
//      }
//      stackView.addArrangedSubview(firstPodiumView)
//    }
    contentView.addSubview(stackView) {
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
  }

  func configure(context: CellContext) {
    guard let podiumCellContext = context as? LeaderboardPodiumContext else { return }

//    firstTeamNameLabel.text = podiumCellContext.firstTeamName
//    firstTeamDistanceLabel.text = "\(podiumCellContext.firstTeamDistance) mi"
//    secondTeamNameLabel.text = podiumCellContext.secondTeamName
//    secondTeamDistanceLabel.text = "\(podiumCellContext.secondTeamDistance) mi"
//    thirdTeamNameLabel.text = podiumCellContext.thirdTeamName
//    thirdTeamDistanceLabel.text = "\(podiumCellContext.thirdTeamDistance) mi"
    for view in stackView.arrangedSubviews {
      view.removeFromSuperview()
    }
    for i in 0..<podiumCellContext.count {

      let teamNameLabel = TeamNameLabel()
      let teamDistanceLabel = TeamDistanceLabel()
      let rankView = RankView(rank: i+1)
      let podiumView = UIView(frame: .zero)

      podiumView.addSubview(rankView) {
        $0.top.equalToSuperview().offset(Style.Padding.p12 + CGFloat(i * 20))
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
       // $0.bottom.greaterThanOrEqualToSuperview().inset(Style.Padding.p12)
        if i == podiumCellContext.count-1 {
          $0.bottom.equalToSuperview().inset(Style.Padding.p12)
        }
      }
//      teamNameLabel.text = podiumCellContext.data[i].name
//      teamDistanceLabel.text = "\(String(describing: podiumCellContext.data[i].distance)) mi"

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



//   contentView.addSubview(stackView) {
//      $0.top.bottom.leading.trailing.equalToSuperview()
//      $0.height.equalTo((stackView.arrangedSubviews.count-1 * 20) + 100)
//    }

//    if podiumCellContext.count == 2 {
//      let lastIndex = stackView.arrangedSubviews.count-1
//      let secondPodiumView = stackView.arrangedSubviews[lastIndex]
//      stackView.removeArrangedSubview(secondPodiumView)
//
//    }
  }
}

//class PodiumView: UIView {
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//  }
//
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//}

class TeamNameLabel: UILabel {
  init() {
    super.init(frame: .zero)
    self.font = Style.Typography.smallRegular.font
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
    self.font = Style.Typography.footnote.font
    self.textColor = Style.Colors.green
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
