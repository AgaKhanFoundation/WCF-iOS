/**
 * Copyright © 2019 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

import UIKit
import SnapKit

protocol ChallengeTeamProgressCellDelegate: class {
  func challengeTeamProgressDisclosureTapped()
  func challengeTeamProgressEditTapped()
}

struct ChallengeTeamProgressCellContext: CellContext {
  let identifier: String = ChallengeTeamProgressCell.identifier
  let teamName: String
  let teamLeadName: String
  let teamMemberImageURLS: [URL?]
  let yourCommittedMiles: Int
  let teamCommittedMiles: Int
  let totalMiles: Int
  let disclosureTitle: String
  let isEditingHidden: Bool
}

class ChallengeTeamProgressCell: ConfigurableTableViewCell {
  static let identifier: String = "ChallengeTeamProgressCell"

  private let cardView = CardViewV2()
  private let teamLabel = UILabel(typography: .title)
  private let teamLeadLabel = UILabel(typography: .subtitleRegular)
  private let imagesStackView = UIStackView()
  private let committedMilesLabel = UILabel(typography: .bodyBold)
  private let remainingMilesLabel = UILabel(typography: .bodyRegular)
  private let yourProgressView = UIProgressView(progressViewStyle: .bar)
  private let teamProgressView = UIProgressView(progressViewStyle: .bar)
  private let totalProgressView = UIProgressView(progressViewStyle: .bar)
  private let yourProgressLabel = ChallengeTeamProgressLabelView()
  private let teamProgressLabel = ChallengeTeamProgressLabelView()
  private let totalProgressLabel = ChallengeTeamProgressLabelView()
  private let editButton = UIButton()
  private let disclosureView = CellDisclosureView()

  weak var delegate: ChallengeTeamProgressCellDelegate?

  override func commonInit() {
    super.commonInit()

    imagesStackView.axis = .horizontal
    imagesStackView.spacing = -10
    imagesStackView.distribution = .fillProportionally
    
    yourProgressView.layer.cornerRadius = 10
    yourProgressView.clipsToBounds = true
    yourProgressView.tintColor = Style.Colors.FoundationGreen
    teamProgressView.layer.cornerRadius = 10
    teamProgressView.clipsToBounds = true
    teamProgressView.tintColor = Style.Colors.SpringGreen
    totalProgressView.progress = 1.0
    totalProgressView.layer.cornerRadius = 10
    totalProgressView.clipsToBounds = true
    totalProgressView.tintColor = Style.Colors.grey
    
    yourProgressLabel.indicatorColor = Style.Colors.FoundationGreen
    yourProgressLabel.text = "Your committed miles"
    teamProgressLabel.indicatorColor = Style.Colors.SpringGreen
    teamProgressLabel.text = "Team's committed miles"
    totalProgressLabel.indicatorColor = Style.Colors.grey
    totalProgressLabel.text = "Uncommitted miles"
    
    editButton.setTitle("Edit", for: .normal)
    editButton.setTitleColor(Style.Colors.blue, for: .normal)
    editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    disclosureView.delegate = self
    
    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }

    cardView.addSubview(teamLabel) {
      $0.top.equalToSuperview().inset(Style.Padding.p32)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
    }

    cardView.addSubview(teamLeadLabel) {
      $0.top.equalTo(teamLabel.snp.bottom).offset(Style.Padding.p8)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
    }

    cardView.addSubview(imagesStackView) {
      $0.top.equalTo(teamLeadLabel.snp.bottom).offset(Style.Padding.p16)
      $0.leading.equalToSuperview().inset(Style.Padding.p16)
    }

    cardView.addSubview(totalProgressView) {
      $0.top.equalTo(imagesStackView.snp.bottom).offset(Style.Padding.p16)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.height.equalTo(20)
    }

    cardView.addSubview(teamProgressView) {
      $0.edges.equalTo(totalProgressView)
    }

    cardView.addSubview(yourProgressView) {
      $0.edges.equalTo(totalProgressView)
    }

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = Style.Padding.p8
    stackView.addArrangedSubviews(yourProgressLabel, teamProgressLabel, totalProgressLabel)

    cardView.addSubview(stackView) {
      $0.top.equalTo(totalProgressView.snp.bottom).offset(Style.Padding.p16)
      $0.leading.equalToSuperview().inset(Style.Padding.p16)
      $0.width.equalToSuperview().multipliedBy(0.80)
    }

    cardView.addSubview(editButton) {
      $0.leading.equalTo(stackView.snp.trailing).offset(Style.Padding.p8)
      $0.top.equalTo(stackView).offset(-4)
    }

    cardView.addSubview(disclosureView) {
      $0.top.equalTo(stackView.snp.bottom).offset(Style.Padding.p16)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? ChallengeTeamProgressCellContext else { return }
    teamLabel.text = context.teamName
    teamLeadLabel.text = "Team Lead: \(context.teamLeadName)"
    teamProgressView.progress = (Float(context.yourCommittedMiles) + Float(context.teamCommittedMiles)) / Float(context.totalMiles)
    yourProgressView.progress = Float(context.yourCommittedMiles) / Float(context.totalMiles)
    yourProgressLabel.miles = context.yourCommittedMiles
    teamProgressLabel.miles = context.teamCommittedMiles
    totalProgressLabel.miles = context.totalMiles - context.yourCommittedMiles - context.teamCommittedMiles
    disclosureView.configure(context: CellDisclosureContext(label: context.disclosureTitle))

    imagesStackView.arrangedSubviews.forEach { imagesStackView.removeArrangedSubview($0) }
    // TODO(samisuteria) switch from colors to urls
    for color in [UIColor.black, UIColor.red, UIColor.blue, UIColor.green, UIColor.magenta] {
      let imageView = UIImageView(image: UIImage(color: color))
      imageView.snp.makeConstraints {
        $0.height.width.equalTo(32)
      }
      imageView.layer.cornerRadius = 16
      imageView.clipsToBounds = true
      imagesStackView.addArrangedSubview(imageView)
      imagesStackView.sendSubviewToBack(imageView)
    }
  }
  
  @objc func editButtonTapped() {
    delegate?.challengeTeamProgressEditTapped()
  }
}

extension ChallengeTeamProgressCell: CellDisclosureViewDelegate {
  func cellDisclosureTapped() {
    delegate?.challengeTeamProgressDisclosureTapped()
  }
}

class ChallengeTeamProgressLabelView: View {
  var indicatorColor: UIColor? { didSet { indicatorView.backgroundColor = indicatorColor }}
  var text: String? { didSet { label.text = text }}
  var miles: Int = 0 { didSet { milesLabel.text = "\(miles)" }}

  private let indicatorView = View()
  private let label = UILabel(typography: .bodyRegular)
  private let milesLabel = UILabel(typography: .bodyBold)

  override func commonInit() {
    super.commonInit()

    milesLabel.textAlignment = .right

    addSubview(indicatorView) {
      $0.height.width.equalTo(12)
      $0.top.bottom.leading.equalToSuperview().inset(Style.Padding.p8)
    }

    addSubview(label) {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(indicatorView.snp.trailing).offset(Style.Padding.p16)
    }

    addSubview(milesLabel) {
      $0.centerY.trailing.equalToSuperview()
      $0.leading.equalTo(label.snp.trailing)
    }
  }
}
