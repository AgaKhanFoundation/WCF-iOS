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

struct JoinTeamCellContext: CellContext {
  let identifier: String = JoinTeamCell.identifier
  let teamLimit: Int
  let teamName: String
  let memberCount: Int
  var isLastItem: Bool
  let context: Context?

  init(teamLimit: Int, teamName: String, memberCount: Int, isLastItem: Bool = false, context: Context?) {
    self.teamLimit = teamLimit
    self.teamName = teamName
    self.memberCount = memberCount
    self.isLastItem = isLastItem
    self.context = context
  }
}

class JoinTeamCell: ConfigurableTableViewCell, Contextable {
  static let identifier = "JoinTeamCell"

  private let teamImageView = UIImageView(image: UIImage(color: Style.Colors.FoundationGreen))
  private let teamNameLabel = UILabel(typography: .bodyRegular)
  private let availableLabel = UILabel(typography: .subtitleRegular)
  private let seperatorView = UIView()

  var context: Context?

  override func commonInit() {
    super.commonInit()
    backgroundColor = Style.Colors.white
    selectionStyle = .default
    seperatorView.backgroundColor = Style.Colors.Seperator
    teamImageView.layer.cornerRadius = 24
    teamImageView.clipsToBounds = true

    contentView.addSubview(teamImageView) {
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p16)
      $0.height.width.equalTo(48)
      $0.leading.equalToSuperview().inset(Style.Padding.p32)
    }

    let layoutGuide = UILayoutGuide()
    contentView.addLayoutGuide(layoutGuide) {
      $0.leading.equalTo(teamImageView.snp.trailing).offset(Style.Padding.p16)
      $0.trailing.centerY.equalToSuperview()
    }

    contentView.addSubview(teamNameLabel) {
      $0.leading.trailing.bottom.equalTo(layoutGuide)
    }

    contentView.addSubview(availableLabel) {
      $0.leading.trailing.top.equalTo(layoutGuide)
    }

    contentView.addSubview(seperatorView) {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? JoinTeamCellContext else { return }
    teamNameLabel.text = context.teamName
    availableLabel.text = "\(context.teamLimit - context.memberCount) spots available"
    seperatorView.isHidden = context.isLastItem
    self.context = context.context
  }
}
