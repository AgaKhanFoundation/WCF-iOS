//
//  MiniChallengeProgressCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 2/14/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


struct MiniChallengeProgressCellContext: CellContext {
  let identifier: String = MiniChallengeProgressCell.identifier
  let title: String
  let teamProgressMiles: Int
  let totalMiles: Int
  let status: String
}

class MiniChallengeProgressCell: ConfigurableTableViewCell {
  static let identifier: String = "MiniChallengeProgressCell"

  private let cardView = CardViewV2()
  private let titleLabel = UILabel(typography: .title)
  private let teamProgressLabel = UILabel(typography: .subtitleRegular)
  private let teamProgressView = UIProgressView(progressViewStyle: .bar)
  private let totalProgressView = UIProgressView(progressViewStyle: .bar)
  private let statusLabel = UILabel(typography: .bodyBold)

  override func commonInit() {
    super.commonInit()
    configureViews()
    configureConstraints()
  }

  private func configureViews() {
    teamProgressView.layer.cornerRadius = 10
    teamProgressView.clipsToBounds = true
    teamProgressView.tintColor = Style.Colors.FoundationGreen
    totalProgressView.progress = 1.0
    totalProgressView.layer.cornerRadius = 10
    totalProgressView.clipsToBounds = true
    totalProgressView.tintColor = Style.Colors.grey
  }

  private func configureConstraints() {
    cardView.backgroundColor = .white
    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }

    cardView.addSubview(titleLabel) {
      $0.top.equalToSuperview().inset(Style.Padding.p32)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
    }

    cardView.addSubview(teamProgressLabel) {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p8)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
    }

    cardView.addSubview(totalProgressView) {
      $0.top.equalTo(teamProgressLabel.snp.bottom).offset(Style.Padding.p16)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.height.equalTo(20)
    }

    cardView.addSubview(teamProgressView) {
      $0.edges.equalTo(totalProgressView)
    }

    cardView.addSubview(statusLabel) {
      $0.top.equalTo(totalProgressView).offset(Style.Padding.p32)
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.trailing.bottom.equalToSuperview().inset(Style.Padding.p16)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? MiniChallengeProgressCellContext else { return }

    titleLabel.text = context.title

    teamProgressView.progress = Float(context.teamProgressMiles) / Float(context.totalMiles)
    teamProgressLabel.text = "\(context.teamProgressMiles) / \(context.totalMiles) miles completed"
    statusLabel.text = context.status
  }
}
