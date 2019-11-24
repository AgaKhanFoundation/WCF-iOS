//
//  CurrentMilestoneCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/17/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

struct MilestoneContext: CellContext {
  var identifier: String = MilestoneCell.identifier
  var sequence = 0
  var distance = 0
  var name = ""
  var flagName = ""
  var journeyMap = ""
  var description = ""
  var title = ""
  var subTitle = ""
  var media = ""
  var content = ""
  var status: MilestoneStatus = .notCompleted
}

class MilestoneCell: ConfigurableTableViewCell {

  static let identifier: String = "MilestoneCell"

  let circle: UIView = {
    var view = UIView(frame: .zero)
    view.layer.cornerRadius = Style.Size.s12
    return view
  }()

  let verticalBar: UIView = {
    var view = UIView(frame: .zero)
    view.frame.size.width = Style.Padding.p2
    return view
  }()

  let milestoneCountLabel: UILabel = {
    var label = UILabel(typography: .smallRegular)
    return label
  }()

  let milestoneNameButton: UIButton = {
    var button = UIButton()
    button.contentHorizontalAlignment = .left
    button.titleLabel?.font = UIFont.systemFont(ofSize: Style.Size.s16, weight: .regular)
    return button
  }()

  override func commonInit() {
    super.commonInit()

    contentView.addSubview(circle) {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.width.height.equalTo(Style.Size.s24)
    }
    contentView.addSubview(milestoneCountLabel) {
      $0.top.equalToSuperview()
      $0.leading.equalTo(circle.snp.trailing).offset(Style.Padding.p12)
      $0.trailing.equalToSuperview().inset(Style.Padding.p12)
      $0.height.equalTo(Style.Size.s24)
    }
    contentView.addSubview(milestoneNameButton) {
      $0.top.equalTo(milestoneCountLabel.snp.bottom).offset(Style.Padding.p4)
      $0.leading.equalTo(circle.snp.trailing).offset(Style.Padding.p12)
      $0.trailing.equalToSuperview().inset(Style.Padding.p12)
      $0.height.equalTo(Style.Size.s24)
      $0.bottom.equalToSuperview().inset(Style.Size.s64)
    }
    contentView.addSubview(verticalBar) {
      $0.top.bottom.equalToSuperview()
      $0.centerX.equalTo(circle)
      $0.width.equalTo(Style.Padding.p2)
    }
    contentView.bringSubviewToFront(circle)
  }

  func configure(context: CellContext) {

    guard let milestone = context as? MilestoneContext else { return }

    switch milestone.status {
    case .notCompleted:
      circle.backgroundColor = Style.Colors.Seperator
      verticalBar.backgroundColor = Style.Colors.Seperator
      milestoneCountLabel.textColor = Style.Colors.FoundationGrey
      milestoneNameButton.setTitleColor(Style.Colors.black, for: .normal)
    case .completed:
      circle.backgroundColor = Style.Colors.FoundationGreen
      verticalBar.backgroundColor = Style.Colors.FoundationGreen
      milestoneCountLabel.textColor = Style.Colors.black
      milestoneNameButton.setTitleColor(Style.Colors.blue, for: .normal)
    case .current:
      circle.backgroundColor = Style.Colors.FoundationGreen
      verticalBar.backgroundColor = Style.Colors.FoundationGreen
      milestoneCountLabel.textColor = Style.Colors.black
      milestoneNameButton.setTitleColor(Style.Colors.blue, for: .normal)
    }

    if milestone.sequence == 0 {
      milestoneCountLabel.text = "Start"
      milestoneNameButton.isHidden = true
    } else {
      milestoneNameButton.isHidden = false
      milestoneCountLabel.text = "Milestone \(milestone.sequence)/8"
    }

    if milestone.sequence == 8 {
      verticalBar.isHidden = true
    } else {
      verticalBar.isHidden = false
    }
    milestoneNameButton.setTitle("\(milestone.name)", for: .normal)
  }
}
