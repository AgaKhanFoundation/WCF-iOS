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
import SDWebImage

protocol ProfileCardCellDelegate: class {
  func profileDisclosureTapped()
}

struct ProfileCardCellContext: CellContext {
  let identifier: String = ProfileCardCell.identifier
  let imageURL: URL?
  let name: String
  let teamName: String
  let eventName: String
  let eventTimeline: String
  let disclosureLabel: String
}

class ProfileCardCell: ConfigurableTableViewCell {
  static let identifier = "ProfileCardCell"

  private let cardView = CardViewV2()
  private let profileImageView = WebImageView()
  private let profileView = ProfileView()
  private let disclosureView = CellDisclosureView()

  weak var delegate: ProfileCardCellDelegate?

  override func commonInit() {
    super.commonInit()

    disclosureView.delegate = self
    profileImageView.clipsToBounds = true

    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }

    cardView.addSubview(disclosureView) {
      $0.leading.trailing.bottom.equalToSuperview()
    }

    let layoutGuide = UILayoutGuide()
    cardView.addLayoutGuide(layoutGuide: layoutGuide) {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(disclosureView.snp.top)
    }

    cardView.addSubview(profileImageView) {
      $0.height.width.equalTo(Style.Size.s96)
      $0.centerY.equalTo(layoutGuide)
      $0.leading.equalToSuperview().inset(Style.Padding.p32)
    }

    cardView.addSubview(profileView) {
      $0.top.bottom.trailing.equalTo(layoutGuide).inset(Style.Padding.p32)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(Style.Padding.p32)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    profileImageView.stopLoading()
  }

  func configure(context: CellContext) {
    guard let context = context as? ProfileCardCellContext else { return }
    profileImageView.fadeInImage(imageURL: context.imageURL, placeHolderImage: Assets.placeholder.image)
    profileView.configure(context: context)
    disclosureView.configure(context: CellDisclosureContext(label: context.disclosureLabel))
  }
}

extension ProfileCardCell: CellDisclosureViewDelegate {
  func cellDisclosureTapped() {
    delegate?.profileDisclosureTapped()
  }
}

class ProfileView: View {
  private let nameLabel = UILabel(typography: .title)
  private let teamNameLabel = UILabel(typography: .smallRegular)
  private let eventNameLabel = UILabel(typography: .smallBold)
  private let eventTimelineLabel = UILabel(typography: .smallRegular)

  override func commonInit() {
    super.commonInit()

    addSubview(nameLabel) {
      $0.leading.trailing.top.equalToSuperview()
    }

    addSubview(teamNameLabel) {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(nameLabel.snp.bottom)
    }

    addSubview(eventNameLabel) {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(teamNameLabel.snp.bottom).offset(Style.Padding.p8)
    }

    addSubview(eventTimelineLabel) {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(eventNameLabel.snp.bottom)
    }
  }

  func configure(context: ProfileCardCellContext) {
    nameLabel.text = context.name
    teamNameLabel.text = context.teamName
    eventNameLabel.text = context.eventName
    eventTimelineLabel.text = context.eventTimeline
  }
}
