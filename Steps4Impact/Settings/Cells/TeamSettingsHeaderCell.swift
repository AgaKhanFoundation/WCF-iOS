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

struct TeamSettingsHeaderCellContext: CellContext {
  let identifier: String = TeamSettingsHeaderCell.identifier
  let team: String
  let event: String
}

class TeamSettingsHeaderCell: ConfigurableTableViewCell {
  static let identifier = "TeamSettingsHeaderCell"

  private let teamImageView: WebImageView = {
    let webImageView = WebImageView()
    webImageView.layer.cornerRadius = 48
    webImageView.image = Assets.uploadImageIcon.image
    webImageView.layer.borderWidth = 1
    webImageView.layer.borderColor = UIColor.lightGray.cgColor
    webImageView.clipsToBounds = true
    webImageView.contentMode = .scaleAspectFill
    return webImageView
  }()
  private let teamLabel = UILabel(typography: .title)
  private let eventLabel = UILabel(typography: .bodyRegular)

  override func commonInit() {
    super.commonInit()
    backgroundColor = Style.Colors.white
    teamLabel.textAlignment = .center
    eventLabel.textAlignment = .center

    contentView.addSubview(teamImageView) {
      $0.height.width.equalTo(Style.Size.s96)
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
    }

    contentView.addSubview(teamLabel) {
      $0.leading.equalTo(teamImageView.snp.trailing).offset(Style.Padding.p32)
      $0.top.equalToSuperview().offset(Style.Padding.p32)
    }

    contentView.addSubview(eventLabel) {
      $0.top.equalTo(teamLabel.snp.bottom).offset(Style.Padding.p8)
      $0.leading.equalTo(teamImageView.snp.trailing).offset(Style.Padding.p32)
      $0.bottom.equalToSuperview().inset(Style.Padding.p32)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? TeamSettingsHeaderCellContext else { return }
    let teamImageURLString = AZSClient.buildImageURL(for: context.team)

    teamImageView.fadeInImage(imageURL: URL(string: teamImageURLString), placeHolderImage: Assets.uploadImageIcon.image)
    teamLabel.text = context.team
    eventLabel.text = context.event
  }
}
