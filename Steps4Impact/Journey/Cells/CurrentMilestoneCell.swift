//
//  MilestoneCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/17/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit
import SnapKit

struct CurrentMilestoneContext: CellContext {
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
  var status: MilestoneStatus = .current
  var progress: CGFloat = 0.0
}

class CurrentMilestoneCell: ConfigurableTableViewCell {

  static let identifier: String = "CurrentMilestoneCell"
  weak var delegate: MilestoneNameButtonDelegate?

  let circle: UIView = {
    var view = UIView(frame: .zero)
    view.layer.cornerRadius = Style.Size.s12
    view.backgroundColor = Style.Colors.FoundationGreen
    return view
  }()

  let verticalBar: UIView = {
    var view = UIView(frame: .zero)
    view.frame.size.width = Style.Padding.p2
    view.backgroundColor = Style.Colors.Seperator
    return view
  }()

  let verticalProgressBar: UIView = {
    var view = UIView(frame: .zero)
    view.frame.size.width = Style.Padding.p2
    return view
  }()

  let progressCircle: UIView = {
    var view = UIView(frame: .zero)
    view.layer.cornerRadius = Style.Size.s12
    view.layer.applySketchShadow(color: Style.Colors.FoundationGreen, alpha: 0.5, x: 0, y: 0, blur: 8, spread: 0)
    return view
  }()

  let milestoneCountLabel: UILabel = {
    var label = UILabel(typography: .smallRegular)
    label.textColor = Style.Colors.black
    return label
  }()

  let milestoneNameButton: UIButton = {
    var button = UIButton()
    button.contentHorizontalAlignment = .left
    button.setTitleColor(Style.Colors.blue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: Style.Size.s16, weight: .regular)
    return button
  }()

  let containerRectangle = CardViewV2()

  let journeyMapImageView = WebImageView()
//  let journeyMapImageView: UIImageView = {
//    let imagevIew = UIImageView()
//    imagevIew.contentMode = .scaleAspectFill
//    imagevIew.image = Assets.journeyEmpty.image
//    imagevIew.clipsToBounds = true
//    return imagevIew
//  }()

  override func commonInit() {
    super.commonInit()
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

    initContentView()
  }

  private func initContentView() {
    contentView.addSubview(containerRectangle) {
      $0.top.equalToSuperview()
      $0.leading.equalTo(circle.snp.trailing).offset(Style.Padding.p8)
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
    }
    contentView.addSubview(verticalBar) {
      $0.top.bottom.equalToSuperview()
      $0.centerX.equalTo(circle)
      $0.width.equalTo(Style.Padding.p2)
    }
    contentView.addSubview(progressCircle) {
      $0.top.equalToSuperview().offset(0)
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.width.height.equalTo(Style.Size.s24)
    }
    contentView.addSubview(verticalProgressBar) {
      $0.top.equalToSuperview()
      $0.centerX.equalTo(circle)
      $0.width.equalTo(Style.Padding.p2)
      $0.bottom.equalTo(progressCircle.snp.top)
    }
    milestoneNameButton.addTarget(self, action: #selector(milestoneNameButtonPressed), for: .touchUpInside)
    contentView.bringSubviewToFront(circle)
  }

  func configure(context: CellContext) {

    guard let currentMilestone = context as? CurrentMilestoneContext else { return }

    let progressForCell = contentView.frame.height * (currentMilestone.progress/100)
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
    milestoneNameButton.tag = currentMilestone.sequence
    // swiftlint:disable:next line_length
    journeyMapImageView.fadeInImage(
      imageURL: URL(string: currentMilestone.journeyMap),
      placeHolderImage: Assets.journeyEmpty.image
    )

    UIView.animate(withDuration: 1) {
      self.progressCircle.snp.remakeConstraints { (make) in
        make.top.equalToSuperview().offset(progressForCell)
        make.leading.equalToSuperview().offset(Style.Padding.p16)
        make.width.height.equalTo(Style.Size.s24)
      }
      self.contentView.layoutSubviews()
    }
  }

  @objc func milestoneNameButtonPressed(button: UIButton) {

    delegate?.milestoneNameButtonTapped(sequence: button.tag)
  }
}
