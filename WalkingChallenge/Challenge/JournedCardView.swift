//
//  StylizedJourneyView.swift
//  WalkingChallenge
//
//  Created by Mohsin on 24/02/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class JourneyCardView: StylizedJourneyView {
  private var imgImage: UIImageView = UIImageView(frame: .zero)
  private var lblName: UILabel = UILabel(typography: .bodyBold)
  private var lblChallengeTimelineLabel: UILabel = UILabel(typography: .smallRegular)

  func layout() {
    addSubviews([imgImage, lblName, lblChallengeTimelineLabel])

    guard let gear = UIImage(named: Assets.NotificationsSelected) else {
      fatalError("missing asset \(Assets.NotificationsSelected)")
    }

    // TODO(compnerd) figure out the correct size for the image
    let szImageSize: CGFloat = Style.Size.s128
    imgImage.image = gear
    imgImage.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Style.Padding.p8)
      $0.height.equalTo(szImageSize)
      $0.width.equalTo(szImageSize)
      $0.centerX.equalToSuperview()
    }

    layoutPersonalDetails(false) // Toggle this to show and hide image
    layoutChallengeDetails()
  }

  private func layoutPersonalDetails(_ imageRequired: Bool) {
    imgImage.isHidden = !imageRequired

    lblName.snp.makeConstraints {
      $0.top.equalTo(imageRequired ? imgImage.snp.bottom : imgImage.snp.top).offset(Style.Padding.p16)
      $0.left.equalToSuperview().inset(Style.Padding.p16)
      $0.right.equalToSuperview().inset(Style.Padding.p16)
    }
  }

  private func layoutChallengeDetails() {
    lblChallengeTimelineLabel.text = Strings.ProfileCard.challengeTimeline
    lblChallengeTimelineLabel.numberOfLines = 0
    lblChallengeTimelineLabel.textColor = Style.Colors.FoundationGrey
    lblChallengeTimelineLabel.snp.makeConstraints {
      $0.top.equalTo(lblName.snp.bottom).offset(Style.Padding.p8)
      $0.left.equalTo(lblName.snp.left)
      $0.right.equalTo(lblName.snp.right)
      $0.bottom.equalToSuperview().inset(Style.Padding.p24)
    }
  }
}

extension JourneyCardView: CardView {
  static let identifier: String = "JourneyCard"

  func render(_ context: Any) {
    guard let data = context as? JourneyCard else { return }

    lblName.text = data.title
    lblChallengeTimelineLabel.text = data.timeline
  }
}

struct JourneyCard: Card {
  let renderer: String = JourneyCardView.identifier

  // TODO(compnerd) provide a constructor to populate this
  let title: String = "Journey"
  let timeline: String = "Your Journey begins in 25 days on Feb 1, 2019!"
}
