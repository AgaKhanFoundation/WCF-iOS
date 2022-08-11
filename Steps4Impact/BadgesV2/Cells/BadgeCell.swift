//
//  BadgeCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/9/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit

struct Badge: CellContext {
  var identifier: String = BadgeCell.identifier
  var stepsCompleted: Int = 0
  var streak: Int = 0
  var teamProgress: Int = 0
  var personalProgress: Int = 0
  var finalMedalAchieved: FinalMedalType = .unknown
  var date: Date?
  var badgeType: BadgeType = .unknown
}

protocol BadgeCellDelegate: AnyObject {
  func badgeCellTapped()
}

class BadgeCell: ConfigurableCollectionViewCell {
  static var identifier: String = "BadgeCell"

  func configure(context: CellContext) {
    guard let badge = context as? Badge else { return }
    var isDateAvailable: Bool = false
    var formattedDateString: String = ""
    if let date = badge.date {
      isDateAvailable = true
      formattedDateString = dateFormatter.string(from: date)
    }

    badgeImageView.alpha = 1
    badgeLabel.alpha = 1
    finalMedalImageView.alpha = 0
    finalMedalLabel.alpha = 0

    switch badge.badgeType {
    case .steps:                                  // swiftlint:disable:next line_length
      badgeLabel.text = #"\#(badge.stepsCompleted) steps completed \#(isDateAvailable ? "on \(formattedDateString)" : "")"#
      badgeImageView.image = BadgesAssets.steps(count: badge.stepsCompleted).image
    case .streak:                                 // swiftlint:disable:next line_length
      badgeLabel.text = #"\#(badge.streak) days streak completed \#(isDateAvailable ? "on \(formattedDateString)" : "")"#
      badgeImageView.image = BadgesAssets.dailyStreak(count: badge.streak).image
    case .personalProgress:                       // swiftlint:disable:next line_length
      badgeLabel.text = #"Completed \#(badge.personalProgress) miles \#(isDateAvailable ? "on \(formattedDateString)" : "")"#
      badgeImageView.image = BadgesAssets.personalProgress(miles: badge.personalProgress).image
    case .teamProgress:
      badgeLabel.text = "Team completed \(badge.teamProgress)% of journey"
      badgeImageView.image = BadgesAssets.teamProgress(progress: badge.teamProgress).image
    case .finalMedal:
      badgeImageView.alpha = 0
      badgeLabel.alpha = 0
      finalMedalImageView.alpha = 1
      finalMedalLabel.alpha = 1
      finalMedalLabel.text = "\(badge.finalMedalAchieved.rawValue) Level Badge"
      finalMedalImageView.image = BadgesAssets.finalMedal(level: badge.finalMedalAchieved.rawValue).image
    default:
      badgeLabel.text = ""
    }
  }

  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()

  weak var delegate: BadgeCellDelegate?

  let badgeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Assets.badgeIcon.image
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 36
    return imageView
  }()

  let finalMedalImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Assets.badgeIcon.image
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 75
    return imageView
  }()

  let finalMedalLabel: UILabel = {
    let label = UILabel(typography: .headerTitle)
    label.textAlignment = .center
    label.sizeToFit()
    label.numberOfLines = 0
    label.textColor = UIColor(hex: 0x363F44)
    return label
  }()

  let badgeLabel: UILabel = {
    let label = UILabel(typography: .footnote)
    label.textAlignment = .center
    label.sizeToFit()
    label.numberOfLines = 0
    label.textColor = UIColor(hex: 0x363F44)
    return label
  }()

  override func commonInit() {
    super.commonInit()
    contentView.addSubview(badgeImageView) {
      $0.width.height.equalTo(72)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(Style.Padding.p24)
    }
    contentView.addSubview(badgeLabel) {
      $0.top.equalTo(badgeImageView.snp.bottom).offset(Style.Padding.p8)
      $0.bottom.equalToSuperview().inset(Style.Padding.p8)
      $0.leading.equalToSuperview().offset(Style.Padding.p4)
      $0.trailing.equalToSuperview().inset(Style.Padding.p4)
    }
    contentView.addSubview(finalMedalImageView) {
      $0.width.height.equalTo(150)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(Style.Padding.p48)
    }
    contentView.addSubview(finalMedalLabel) {
      $0.top.equalTo(finalMedalImageView.snp.bottom).offset(Style.Padding.p12)
      $0.bottom.equalToSuperview().inset(Style.Padding.p12)
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
    }
    badgeImageView.alpha = 1
    badgeLabel.alpha = 1
    finalMedalImageView.alpha = 0
    finalMedalLabel.alpha = 0
  }
}
