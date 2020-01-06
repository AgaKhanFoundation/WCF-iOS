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

import Foundation
import UIKit

struct LeaderboardHeaderCellContext: CellContext {
  let identifier: String = LeaderboardHeaderCell.identifier
  let teamTitle: String
  let distanceTitle: String

  init(teamTitle: String = "Team Name", distanceTitle: String = "Miles") {
    self.teamTitle = teamTitle
    self.distanceTitle = distanceTitle
  }
}

class LeaderboardHeaderCell: ConfigurableTableViewCell {
  static var identifier: String = "LeaderboardHeaderCell"

  func configure(context: CellContext) {
    guard let context = context as? LeaderboardHeaderCellContext else { return }
    headerNameTitleLabel.text = context.teamTitle
    headerDistanceTitleLabel.text = context.distanceTitle
  }

  private let headerNameTitleLabel: UILabel = {
    let label = UILabel(typography: .rowTitleSemiBold, color: Style.Colors.black)
    label.textAlignment = .left
    return label
  }()

  private let headerDistanceTitleLabel: UILabel = {
    let label = UILabel(typography: .rowTitleSemiBold, color: Style.Colors.black)
    label.textAlignment = .center
    return label
  }()

  private let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = Style.Colors.Seperator
    return view
  }()

  override func commonInit() {
    super.commonInit()

    contentView.addSubview(headerNameTitleLabel) {
      $0.leading.equalToSuperview().offset(Style.Padding.p64)
      $0.height.equalTo(Style.Size.s32)
      $0.centerY.equalToSuperview()
    }
    contentView.addSubview(headerDistanceTitleLabel) {
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.leading.equalTo(headerNameTitleLabel.snp.trailing).offset(Style.Padding.p16)
      $0.width.equalTo(Style.Size.s64)
      $0.height.equalTo(Style.Size.s24)
      $0.centerY.equalToSuperview()
    }

    contentView.addSubview(lineView) {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(0.5)
    }
  }
}

struct ExpandCollapseCellContext: CellContext {
  let identifier: String = ExpandCollapseCell.identifier
  let titleText: String

  init(titleText: String = "Expand") {
    self.titleText = titleText
  }
}

class ExpandCollapseCell: ConfigurableTableViewCell {
  static var identifier: String = "ExpandCollapseCell"

  func configure(context: CellContext) {
    guard let context = context as? ExpandCollapseCellContext else { return }
    titleLabel.text = context.titleText
  }

  private let titleLabel: UILabel = {
    let label = UILabel(typography: .bodyRegular, color: Style.Colors.grey)
    label.textAlignment = .center
    return label
  }()

  private let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = Style.Colors.Seperator
    return view
  }()

  override func commonInit() {
    super.commonInit()

    contentView.addSubview(titleLabel) {
      $0.trailing.leading.equalToSuperview()
      $0.top.equalToSuperview().offset(Style.Padding.p4)
      $0.bottom.equalToSuperview().inset(Style.Padding.p4)
      $0.height.equalTo(Style.Size.s32)
      $0.centerY.equalToSuperview()
    }

    contentView.addSubview(lineView) {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(0.5)
    }
  }
}
