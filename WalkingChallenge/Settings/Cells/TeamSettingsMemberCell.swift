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

struct TeamSettingsMemberCellContext: CellContext {
  let identifier: String = TeamSettingsMemberCell.identifier
  let count: Int
  let imageURL: URL?
  let name: String
  let isLastItem: Bool
  let context: Context?

  init(count: Int, imageURL: URL? = nil, name: String, isLastItem: Bool = false, context: Context? = nil) {
    self.count = count
    self.imageURL = imageURL
    self.name = name
    self.isLastItem = isLastItem
    self.context = context
  }
}

class TeamSettingsMemberCell: ConfigurableTableViewCell, Contextable {
  static let identifier = "TeamSettingsMemberCell"

  private let countLabel = UILabel(typography: .bodyRegular)
  private let profileImageView = UIImageView(image: Assets.placeholder.image)
  private let nameLabel = UILabel(typography: .bodyRegular)
  private let seperatorView = UIView()
  var context: Context?

  override func commonInit() {
    super.commonInit()
    backgroundColor = Style.Colors.white
    seperatorView.backgroundColor = Style.Colors.Seperator
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = 16

    contentView.addSubview(countLabel) {
      $0.leading.equalToSuperview().inset(Style.Padding.p32)
      $0.centerY.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(20)
    }

    contentView.addSubview(profileImageView) {
      $0.height.width.equalTo(32)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p16)
      $0.leading.equalTo(countLabel.snp.trailing).offset(Style.Padding.p16)
    }

    contentView.addSubview(nameLabel) {
      $0.leading.equalTo(profileImageView.snp.trailing).offset(Style.Padding.p16)
      $0.centerY.equalToSuperview()
    }

    contentView.addSubview(seperatorView) {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? TeamSettingsMemberCellContext else { return }
    countLabel.text = "\(context.count)."
    nameLabel.text = context.name
    seperatorView.isHidden = context.isLastItem
    self.context = context.context
  }
}
