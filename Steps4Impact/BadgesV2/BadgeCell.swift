//
//  BadgeCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/9/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit

class BadgeCell: UICollectionViewCell {

  let dateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()

  var badge : Badge? {
    didSet {

      if let badge = badge {

        var isDateAvailable : Bool = false
        var formattedDateString : String = ""
        if let date = badge.date {
          isDateAvailable = true
          formattedDateString = dateFormatter.string(from: date)
        }
        badgeImageView.isHidden = false
        badgeLabel.isHidden = false
        finalMedalImageView.isHidden = true
        finalMedalLabel.isHidden = true
        switch badge.badgeType {
        case .steps:
          badgeLabel.text = #"\#(badge.stepsCompleted) steps completed \#(isDateAvailable ? "on \(formattedDateString)" : "")"#
          break
        case .streak:
          badgeLabel.text = #"\#(badge.streak) days streak completed \#(isDateAvailable ? "on \(formattedDateString)" : "")"#
          break
        case .personalProgress:
          badgeLabel.text = #"Completed \#(badge.personalProgress) miles \#(isDateAvailable ? "on \(formattedDateString)" : "")"#
          break
        case .teamProgress:
          badgeLabel.text = "Team completed \(badge.teamProgress)% of journey"
          break
        case .finalMedal:
          badgeImageView.isHidden = true
          badgeLabel.isHidden = true
          finalMedalImageView.isHidden = false
          finalMedalLabel.isHidden = false
          finalMedalLabel.text = "\(badge.finalMedalAchieved.rawValue) Level Badge"
          break
        default:
          badgeLabel.text = ""
          break
        }

      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  let badgeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "badge_icon")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = UIColor(hex: 0x00A85D).cgColor
    imageView.layer.cornerRadius = 36
    return imageView
  }()

  let finalMedalImageView: UIImageView = {
     let imageView = UIImageView()
     imageView.image = UIImage(named: "badge_icon")
     imageView.contentMode = .scaleAspectFit
     imageView.translatesAutoresizingMaskIntoConstraints = false
     imageView.layer.borderWidth = 1
    imageView.layer.borderColor = UIColor(hex: 0x00A85D).cgColor
     imageView.layer.cornerRadius = 75
     return imageView
   }()

    let finalMedalLabel: UILabel = {
      let label = UILabel()
      label.textAlignment = .center
      label.sizeToFit()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.numberOfLines = 0
      label.textColor = UIColor(hex: 0x363F44)
      label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
      return label
    }()

  let badgeLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.sizeToFit()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.textColor = UIColor(hex: 0x363F44)
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    return label
  }()

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {

    backgroundColor = .white

    addSubview(badgeImageView)

    badgeImageView.widthAnchor.constraint(equalToConstant: 72).isActive = true
    badgeImageView.heightAnchor.constraint(equalToConstant: 72).isActive = true
    badgeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    badgeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true

    addSubview(badgeLabel)

    badgeLabel.widthAnchor.constraint(equalToConstant: self.frame.width-12).isActive = true
    badgeLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -6).isActive = true
    badgeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    badgeLabel.topAnchor.constraint(equalTo: self.badgeImageView.bottomAnchor, constant: 9).isActive = true

    addSubview(finalMedalImageView)

    finalMedalImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    finalMedalImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    finalMedalImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    finalMedalImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true

    addSubview(finalMedalLabel)

    finalMedalLabel.widthAnchor.constraint(equalToConstant: self.frame.width-32).isActive = true
    finalMedalLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10).isActive = true
    finalMedalLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    finalMedalLabel.topAnchor.constraint(equalTo: self.finalMedalImageView.bottomAnchor, constant: 10).isActive = true

    badgeImageView.isHidden = false
    badgeLabel.isHidden = false
    finalMedalImageView.isHidden = true
    finalMedalLabel.isHidden = true

  }


}
