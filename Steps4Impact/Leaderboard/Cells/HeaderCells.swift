//
//  LeaderboardHeaderCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/27/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit

struct LeaderboardHeaderCellContext: CellContext {
  var identifier: String = LeaderboardHeaderCell.identifier
  var teamTitle: String = "Team Name"
  var distanceTitle: String = "Miles"
}

class LeaderboardHeaderCell: ConfigurableTableViewCell {
  func configure(context: CellContext) {
    guard let context = context as? LeaderboardHeaderCellContext else { return }
    headerNameTitleLabel.text = context.teamTitle
    headerDistanceTitleLabel.text = context.distanceTitle
  }

  static var identifier: String = "LeaderboardHeaderCell"

  let headerNameTitleLabel: UILabel = {
    let label = UILabel(typography: .rowTitleSemiBold, color: Style.Colors.black)
    label.textAlignment = .left
    return label
  }()

  let headerDistanceTitleLabel: UILabel = {
    let label = UILabel(typography: .rowTitleSemiBold, color: Style.Colors.black)
    label.textAlignment = .center
    return label
  }()

  let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = Style.Colors.Seperator
    return view
  }()

  override func commonInit() {
    super.commonInit()

    contentView.addSubview(headerNameTitleLabel) {
      $0.leading.equalToSuperview().offset(Style.Padding.p64)
      $0.height.equalTo(Style.Size.s32)
      $0.centerY.equalToSuperview()
    }
    contentView.addSubview(headerDistanceTitleLabel) {
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.leading.equalTo(headerNameTitleLabel.snp.trailing).offset(Style.Padding.p16)
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
}

struct ExpandCollapseCellContext: CellContext {
  var identifier: String = ExpandCollapseCell.identifier
  var titletext: String = "Expand"
}

class ExpandCollapseCell: ConfigurableTableViewCell {
  func configure(context: CellContext) {
    guard let context = context as? ExpandCollapseCellContext else { return }
    titleLabel.text = context.titletext
  }

  static var identifier: String = "ExpandCollapseCell"

  let titleLabel: UILabel = {
    let label = UILabel(typography: .bodyRegular, color: Style.Colors.grey)
    label.textAlignment = .center
    return label
  }()

  let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = Style.Colors.Seperator
    return view
  }()

  override func commonInit() {
    super.commonInit()

    contentView.addSubview(titleLabel) {
      $0.trailing.leading.equalToSuperview()
      $0.top.equalToSuperview().offset(Style.Padding.p4)
      $0.bottom.equalToSuperview().inset(Style.Padding.p4)
      $0.height.equalTo(Style.Size.s32)
      $0.centerY.equalToSuperview()
    }

    contentView.addSubview(lineView) {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(0.5)
    }
  }
}
