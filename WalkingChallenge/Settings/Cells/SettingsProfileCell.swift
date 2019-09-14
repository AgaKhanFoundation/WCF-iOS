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

struct SettingsProfileCellContext: CellContext {
  let identifier: String = SettingsProfileCell.identifier
  let image: UIImage?
  let name: String
  let teamName: String
  let membership: String
}

class SettingsProfileCell: ConfigurableTableViewCell {
  static let identifier = "SettingsProfileCell"

  private let profileImageView = UIImageView()
  private let nameLabel = UILabel(typography: .title)
  private let teamNameLabel = UILabel(typography: .smallRegular)
  private let membershipLabel = UILabel(typography: .smallRegular)

  override func commonInit() {
    super.commonInit()

    profileImageView.clipsToBounds = true
    contentView.backgroundColor = Style.Colors.white

    contentView.addSubview(profileImageView) {
      $0.height.width.equalTo(Style.Size.s64)
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(Style.Padding.p32)
    }

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.addArrangedSubviews(nameLabel, teamNameLabel, membershipLabel)

    contentView.addSubview(stackView) {
      $0.top.bottom.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(Style.Padding.p32)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
  }

  func configure(context: CellContext) {
    guard let context = context as? SettingsProfileCellContext else { return }

    nameLabel.text = context.name
    teamNameLabel.text = context.teamName
    membershipLabel.text = context.membership
  }
}
