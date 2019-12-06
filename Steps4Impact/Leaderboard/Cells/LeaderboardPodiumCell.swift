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
  var firstTeamName: String = ""
  var firstTeamDistance: Int = 0
  var secondTeamName: String = ""
  var secondTeamDistance: Int = 0
  var thirdTeamName: String = ""
  var thirdTeamDistance: Int = 0
}

class LeaderboardPodiumCell: ConfigurableTableViewCell {
  static var identifier: String = "LeaderboardPodiumCell"

  let firstTeamNameLabel: UILabel = {
    let label = UILabel(typography: .smallRegular)
    label.textColor = Style.Colors.black
    label.textAlignment = .center
    return label
  }()
  let firstTeamDistanceLabel: UILabel = {
    let label = UILabel(typography: .footnote)
    label.textColor = Style.Colors.green
    label.textAlignment = .center
    return label
  }()
  let firstOval: UIView = {
    let view = UIView(frame: .zero)
    view.layer.cornerRadius = 45
    view.backgroundColor = Style.Colors.EarthyGold
    return view
  }()
  let firstPodiumView = UIView(frame: .zero)

  let secondTeamNameLabel: UILabel = {
    let label = UILabel(typography: .smallRegular)
    label.textColor = Style.Colors.black
    label.textAlignment = .center
    return label
  }()
  let secondTeamDistanceLabel: UILabel = {
    let label = UILabel(typography: .footnote)
    label.textColor = Style.Colors.green
    label.textAlignment = .center
    return label
  }()
  let secondOval: UIView = {
    let view = UIView(frame: .zero)
    view.layer.cornerRadius = 45
    view.backgroundColor = Style.Colors.FoundationGrey
    return view
  }()
  let secondPodiumView = UIView(frame: .zero)

  let thirdTeamNameLabel: UILabel = {
    let label = UILabel(typography: .smallRegular)
    label.textColor = Style.Colors.black
    label.textAlignment = .center
    return label
  }()
  let thirdTeamDistanceLabel: UILabel = {
    let label = UILabel(typography: .footnote)
    label.textColor = Style.Colors.green
    label.textAlignment = .center
    return label
  }()
  let thirdOval: UIView = {
    let view = UIView(frame: .zero)
    view.layer.cornerRadius = 45
    view.backgroundColor = Style.Colors.RubineRed
    return view
  }()
  let thirdPodiumView = UIView(frame: .zero)

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

    firstPodiumView.addSubview(firstOval) {
      $0.top.equalToSuperview().offset(Style.Padding.p8)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(90)
    }
    firstPodiumView.addSubview(firstTeamNameLabel) {
      $0.top.equalTo(firstOval.snp.bottom).offset(Style.Padding.p4)
      $0.leading.equalToSuperview().offset(Style.Padding.p4)
      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
    }
    firstPodiumView.addSubview(firstTeamDistanceLabel) {
      $0.top.equalTo(firstTeamNameLabel.snp.bottom).offset(Style.Padding.p4)
      $0.leading.equalToSuperview().offset(Style.Padding.p4)
      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
    }
    secondPodiumView.addSubview(secondOval) {
      $0.top.equalToSuperview().offset(Style.Padding.p48)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(90)
    }
    secondPodiumView.addSubview(secondTeamNameLabel) {
      $0.top.equalTo(secondOval.snp.bottom).offset(Style.Padding.p4)
      $0.leading.equalToSuperview().offset(Style.Padding.p4)
      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
    }
    secondPodiumView.addSubview(secondTeamDistanceLabel) {
      $0.top.equalTo(secondTeamNameLabel.snp.bottom).offset(Style.Padding.p4)
      $0.leading.equalToSuperview().offset(Style.Padding.p4)
      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
    }
    thirdPodiumView.addSubview(thirdOval) {
      $0.top.equalToSuperview().offset(Style.Padding.p64)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(90)
    }
    thirdPodiumView.addSubview(thirdTeamNameLabel) {
      $0.top.equalTo(thirdOval.snp.bottom).offset(Style.Padding.p4)
      $0.leading.equalToSuperview().offset(Style.Padding.p4)
      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
    }
    thirdPodiumView.addSubview(thirdTeamDistanceLabel) {
      $0.top.equalTo(thirdTeamNameLabel.snp.bottom).offset(Style.Padding.p4)
      $0.leading.equalToSuperview().offset(Style.Padding.p4)
      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
      $0.bottom.equalToSuperview().inset(Style.Padding.p4)
    }

    stackView.addArrangedSubviews(secondPodiumView,firstPodiumView,thirdPodiumView)

    contentView.addSubview(stackView) {
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
  }

  func configure(context: CellContext) {
    guard let podiumCellContext = context as? LeaderboardPodiumContext else { return }

    firstTeamNameLabel.text = podiumCellContext.firstTeamName
    firstTeamDistanceLabel.text = "\(podiumCellContext.firstTeamDistance) mi"
    secondTeamNameLabel.text = podiumCellContext.secondTeamName
    secondTeamDistanceLabel.text = "\(podiumCellContext.secondTeamDistance) mi"
    thirdTeamNameLabel.text = podiumCellContext.thirdTeamName
    thirdTeamDistanceLabel.text = "\(podiumCellContext.thirdTeamDistance) mi"

  }
}
