//
//  JourneyMilesCardView.swift
//  WalkingChallenge
//
//  Created by Mohsin on 10/05/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class JourneyMilesCardView: StylizedJourneyView {
  private var lblName: UILabel = UILabel(typography: .bodyBold)
  private var lblChallengeTimelineLabel: UILabel = UILabel(typography: .smallRegular)
  private var imgImage: UIImageView = UIImageView(frame: .zero)
  private var lblWalkMiles: UILabel = UILabel(typography: .smallRegular)
  private var btnViewMileStones: UIButton = UIButton(type: .system)

  var showMileStone: (() -> Void)?

  func layout() {
    self.contentView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: Style.Size.s8)

    addSubviews([lblName, lblChallengeTimelineLabel, imgImage, lblWalkMiles, btnViewMileStones])

    btnViewMileStones.titleLabel?.numberOfLines = 2
    btnViewMileStones.titleLabel?.lineBreakMode = .byWordWrapping
    btnViewMileStones.addTarget(self, action: #selector(showMileStones), for: .touchUpInside)

    lblName.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Style.Padding.p16)
      $0.left.equalToSuperview().inset(Style.Padding.p16)
      $0.right.equalToSuperview().inset(Style.Padding.p16)
    }

    lblChallengeTimelineLabel.snp.makeConstraints {
      $0.top.equalTo(lblName.snp.bottom).offset(Style.Padding.p8)
      $0.left.equalTo(lblName.snp.left)
      $0.right.equalToSuperview().inset(Style.Padding.p16)
    }

    let szImageSize: CGFloat = Style.Size.s128
    imgImage.snp.makeConstraints {
      $0.top.equalTo(lblChallengeTimelineLabel.snp.bottom).inset(Style.Padding.p8)
      $0.height.equalTo(szImageSize)
      $0.width.equalTo(szImageSize)
      $0.centerX.equalToSuperview()
    }

    lblWalkMiles.snp.makeConstraints {
      $0.top.equalTo(imgImage.snp.bottom).offset(Style.Padding.p12)
      $0.left.equalTo(lblName.snp.left)
      $0.right.equalToSuperview().inset(Style.Padding.p8)
    }

    btnViewMileStones.snp.makeConstraints {
      $0.top.equalTo(lblWalkMiles.snp.bottom).offset(Style.Padding.p8)
      $0.left.equalTo(lblName.snp.left)
      $0.right.equalTo(lblChallengeTimelineLabel.snp.right)
      $0.bottom.equalToSuperview().inset(Style.Padding.p12)
    }

  }

  @objc func showMileStones() {
    showMileStone?()
  }

  private func assignValues(data: JourneyCardMiles) {
    guard let gear = UIImage(named: Assets.NotificationsSelected) else {
      fatalError("missing asset \(Assets.NotificationsSelected)")
    }

    imgImage.image = gear

    lblName.text = data.title
    lblChallengeTimelineLabel.text = data.timeline
    lblWalkMiles.text = data.walkMiles

    btnViewMileStones.setTitleColor(.blue, for: .normal)
    var viewMileStone = "\(data.viewMileStone) v"
    if data.expand {
      viewMileStone = "\n\(data.timeline)"
      btnViewMileStones.setTitleColor(.black, for: .normal)
    }

    btnViewMileStones.setTitle(viewMileStone, for: .normal)
  }
}

extension JourneyMilesCardView: CardView {
  static let identifier: String = "JourneyCard"

  func render(_ context: Any) {
    guard let data = context as? JourneyCardMiles else { return }

    assignValues(data: data)
  }
}

struct JourneyCardMiles: Card {
  let renderer: String = JourneyCardView.identifier

  let title: String = "Journey"
  let timeline: String = "1 out of 10 milestones completed"
  let walkMiles: String = "365 miles left to walk untill your team's next milestone!"
  let viewMileStone: String = "View Milestones"
  var expand: Bool = false
  let miles: [MilestoneCard] = [MilestoneCard(), MilestoneCard(), MilestoneCard(), MilestoneCard()]

  mutating func expandMile(_ expand: Bool) {
    self.expand = expand
  }
}
