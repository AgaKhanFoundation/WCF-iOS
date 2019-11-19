//
//  MilestoneCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/17/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit
import SnapKit

struct CurrentMilestoneContext : CellContext {
  var identifier: String = CurrentMilestoneCell.identifier
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
  var status : MilestoneStatus = .current
  var progress : CGFloat = 0.0
}

class CurrentMilestoneCell: ConfigurableTableViewCell {

  static let identifier: String = "CurrentMilestoneCell"

  let circle : UIView = {
    var view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 12
    return view
  }()

  let verticalBar : UIView = {
    var view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.frame.size.width = 2
    return view
  }()

  let verticalProgressBar : UIView = {
    var view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.frame.size.width = 2
    return view
  }()

  let progressCircle : UIView = {
    var view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 12
    view.layer.applySketchShadow(color: Style.Colors.FoundationGreen, alpha: 0.5, x: 0, y: 0, blur: 8, spread: 0)
    return view
  }()

  let milestoneCountLabel : UILabel = {
    var label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    return label
  }()

  let milestoneNameButton : UIButton = {
    var button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.contentHorizontalAlignment = .left
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    return button
  }()

  let containerRectangle = CardViewV2()

  let journeyMapImageView : UIImageView = {
    let imagevIew = UIImageView()
    imagevIew.translatesAutoresizingMaskIntoConstraints = false
    imagevIew.contentMode = .scaleAspectFill
    imagevIew.clipsToBounds = true
    return imagevIew
  }()

  override func commonInit() {
    super.commonInit()

    circle.backgroundColor = Style.Colors.FoundationGreen
    verticalBar.backgroundColor = Style.Colors.Seperator
    containerRectangle.backgroundColor = Style.Colors.white

    milestoneCountLabel.text = "Milestone 1/10"
    milestoneNameButton.setTitle("Karachi, Pakistan", for: .normal)
    milestoneCountLabel.textColor = Style.Colors.black
    milestoneNameButton.setTitleColor(Style.Colors.blue, for: .normal)
    journeyMapImageView.image = UIImage(named: "journey_map_test")

    contentView.addSubview(circle) {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.width.height.equalTo(Style.Size.s24)
    }
    containerRectangle.addSubview(milestoneCountLabel) {
      $0.top.equalToSuperview().offset(Style.Padding.p4)
      $0.leading.equalToSuperview().offset(Style.Padding.p12)
      $0.trailing.equalToSuperview().inset(Style.Padding.p12)
      $0.height.equalTo(Style.Size.s24)
    }
    containerRectangle.addSubview(milestoneNameButton) {
      $0.top.equalTo(milestoneCountLabel.snp.bottom).offset(Style.Padding.p2)
      $0.leading.equalToSuperview().offset(Style.Padding.p12)
      $0.trailing.equalToSuperview().inset(Style.Padding.p12)
      $0.height.equalTo(Style.Size.s24)
    }
    containerRectangle.addSubview(journeyMapImageView) {
      $0.top.equalTo(milestoneNameButton.snp.bottom).offset(Style.Padding.p8)
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
      $0.leading.equalToSuperview().offset(Style.Padding.p12)
      $0.trailing.equalToSuperview().inset(Style.Padding.p12)
      $0.height.width.equalTo(Style.Size.s128)
    }
    contentView.addSubview(containerRectangle) {
      $0.top.equalToSuperview()
      $0.leading.equalTo(circle.snp.trailing).offset(Style.Padding.p8)
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
    }
    contentView.addSubview(verticalBar) {
      $0.top.bottom.equalToSuperview()
      $0.centerX.equalTo(circle.snp.centerX)
      $0.width.equalTo(Style.Padding.p2)
    }
    contentView.addSubview(progressCircle) {
      $0.top.equalToSuperview().offset(0)
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.width.height.equalTo(Style.Size.s24)
    }
    contentView.addSubview(verticalProgressBar) {
      $0.top.equalToSuperview()
      $0.centerX.equalTo(circle.snp.centerX)
      $0.width.equalTo(Style.Padding.p2)
      $0.bottom.equalTo(progressCircle.snp.top)
    }
    contentView.bringSubviewToFront(circle)
  }

  func configure(context: CellContext) {

    guard let currentMilestone = context as? CurrentMilestoneContext else { return }

    let progressForCell = contentView.frame.height * (currentMilestone.progress/100)

    progressCircle.alpha = 0

    circle.backgroundColor = Style.Colors.FoundationGreen
    verticalBar.backgroundColor = Style.Colors.Seperator

    progressCircle.backgroundColor = Style.Colors.white
    verticalProgressBar.backgroundColor = Style.Colors.FoundationGreen

    if currentMilestone.sequence == 0 {
      milestoneCountLabel.text = "Start"
      milestoneNameButton.isHidden = true
    } else {
      milestoneNameButton.isHidden = false
      milestoneCountLabel.text = "Milestone \(currentMilestone.sequence)/8"
    }

    if currentMilestone.sequence == 8 {
      verticalBar.isHidden = true
    } else {
      verticalBar.isHidden = false
    }
    milestoneNameButton.setTitle("\(currentMilestone.name)", for: .normal)
    
    progressCircle.alpha = 1
    UIView.animate(withDuration: 1) {
      self.progressCircle.snp.remakeConstraints { (make) in
        make.top.equalToSuperview().offset(progressForCell)
        make.leading.equalToSuperview().offset(Style.Padding.p16)
        make.width.height.equalTo(Style.Size.s24)
      }
      self.contentView.layoutSubviews()
    }
  }
}
