//
//  LeaderboardCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/24/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit

struct LeaderboardContext: CellContext {
  var identifier: String = LeaderboardCell.identifier
  var rank: Int = 0
  var teamName: String = ""
  var teamDistance: Int = 0
  var isMyTeam: Bool = false
}

class LeaderboardCell: ConfigurableTableViewCell {
  static var identifier: String = "LeaderboardCell"
  var rankLabel: UILabel = {
    let label = UILabel(typography: .rowTitleRegular, color: Style.Colors.FoundationGrey)
    label.textAlignment = .left
    return label
  }()
  var teamNameLabel: UILabel = {
    let label = UILabel(typography: .rowTitleRegular, color: Style.Colors.FoundationGrey)
    label.textAlignment = .left
    return label
  }()
  var teamDistanceLabel: UILabel = {
    let label = UILabel(typography: .bodyRegular, color: Style.Colors.grey)
    label.textAlignment = .right
    return label
  }()
  let lineView: UIView = {
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
