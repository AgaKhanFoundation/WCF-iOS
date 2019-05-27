//
//  MilestoneDetailCardView.swift
//  WalkingChallenge
//
//  Created by Mohsin on 11/05/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class MilestoneDetailCardView: StylizedJourneyView {

  private var stackView: UIStackView = UIStackView()
  private var whiteView: UIView = UIView()
  private var whiteView2: UIView = UIView()
  private var lblLines: UILabel = UILabel(typography: .subtitleRegular)
  private var lblLines2: UILabel = UILabel(typography: .subtitleRegular)
  private var lblRow: UILabel = UILabel(typography: .subtitleRegular)
  private var imgFlag: UIImageView = UIImageView(frame: .zero)
  private var lblName: UILabel = UILabel(typography: .subtitleRegular)
  private var lblDetails: UILabel = UILabel(typography: .smallRegular)
  private var lblMiles: UILabel = UILabel(typography: .smallRegular)
  private var lblDate: UILabel = UILabel(typography: .smallRegular)
  private var lblSeparator: UILabel = UILabel(typography: .smallRegular)
  private let (width, height) = (18, 25)

  func layout() {
    addSubviews([stackView, imgFlag, lblName, lblDetails, lblDate, lblMiles, lblSeparator])
    whiteView.addSubview(lblLines)
    whiteView2.addSubview(lblLines2)

    lblRow.textColor = Style.Colors.green
    lblRow.textAlignment = .center
    lblLines2.backgroundColor = Style.Colors.FoundationGrey
    lblLines.backgroundColor = lblLines2.backgroundColor
    lblSeparator.backgroundColor = lblLines2.backgroundColor

    stackView.axis  = .vertical
    stackView.distribution  = .fill
    stackView.alignment = .fill
    stackView.spacing   = 1

    stackView.addArrangedSubview(whiteView)
    stackView.addArrangedSubview(lblRow)
    stackView.addArrangedSubview(whiteView2)
    addSubview(stackView)

    guard let gear = UIImage(named: Assets.NotificationsSelected) else {
      fatalError("missing asset \(Assets.NotificationsSelected)")
    }
    imgFlag.image = gear

    lblDetails.textColor = Style.Colors.grey
    lblDate.textColor = lblDetails.textColor

    setLayoutOfRows()
    setContentLayout()
  }

  private func setLayoutOfRows() {
    whiteView.snp.makeConstraints {
      $0.width.equalTo(width)
      $0.height.equalTo(height)
    }

    lblRow.snp.makeConstraints {
      $0.width.height.equalTo(whiteView.snp.width)
    }

    whiteView2.snp.makeConstraints {
      $0.width.equalTo(whiteView.snp.width)
      $0.height.equalTo(height*2)
    }

    lblLines.snp.makeConstraints {
      $0.width.equalTo(1)
      $0.top.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }

    lblLines2.snp.makeConstraints {
      $0.width.equalTo(1)
      $0.top.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }

    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.equalTo(20)
    }
  }

  private func setContentLayout() {
    imgFlag.snp.makeConstraints {
      $0.left.equalTo(stackView.snp.right).offset(10)
      $0.top.equalTo(height)
      $0.width.height.equalTo(20)
    }

    lblName.snp.makeConstraints {
      $0.left.equalTo(imgFlag.snp.right).offset(3)
      $0.centerY.equalTo(imgFlag)
    }

    lblDetails.snp.makeConstraints {
      $0.top.equalTo(lblName.snp.bottom).offset(5)
      $0.left.equalTo(imgFlag.snp.left)
    }

    lblMiles.snp.makeConstraints {
      $0.right.equalToSuperview().inset(10)
      $0.top.equalTo(lblName.snp.top)
    }

    lblDate.snp.makeConstraints {
      $0.right.equalTo(lblMiles.snp.right)
      $0.top.equalTo(lblMiles.snp.bottom).offset(10)
    }

    lblSeparator.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.left.equalTo(imgFlag.snp.left)
      $0.right.equalTo(lblDate.snp.right)
      $0.bottom.equalToSuperview().inset(0)
    }
  }

  func hideFirstLayer(_ hide: Bool) {
    lblLines.isHidden = hide
  }

  func showLastRoundedCorner(_ isLast: Bool) {
    self.contentView
      .roundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: isLast == true ? Style.Size.s8 : 0)
    self.lblSeparator.isHidden = isLast
  }
}

extension MilestoneDetailCardView: CardView {
  static let identifier: String = "MilestoneDetailCard"

  func render(_ context: Any) {
    guard let data = context as? MilestoneCard else { return }

    lblRow.text = data.serialNo
    imgFlag.image = UIImage(named: Assets.NotificationsSelected)
    lblName.text = data.name
    lblDetails.text = data.details
    lblDate.text = data.date
    lblMiles.text = data.miles
  }
}

struct MilestoneCard: Card {
  let renderer: String = MilestoneDetailCardView.identifier

  // TODO(compnerd) provide a constructor to populate this
  let imageName: String = "Journey"
  let name: String = "Edmonton, Canada"
  let details: String = "Agakhan Garden"
  let miles: String = "Miles"
  let date: String = "Date"
  let serialNo: String = "5"
}
