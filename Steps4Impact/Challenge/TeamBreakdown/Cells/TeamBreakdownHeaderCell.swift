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

struct TeamBreakdownHeaderCellContext: CellContext {
  let identifier: String = TeamBreakdownHeaderCell.identifier
  let totalSteps: Int
  let totalCommitment: Int
}

class TeamBreakdownHeaderCell: ConfigurableTableViewCell {
  static let identifier = "TeamBreakdownHeaderCell"

  let teamProgressLabel = UILabel(typography: .title)
  let totalWalkedTitleLabel = UILabel(typography: .bodyRegular)

  let totalWalkedValueLabel = UILabel(typography: .bodyRegular)
  
  override func commonInit() {
    super.commonInit()
    backgroundColor = Style.Colors.white
    teamProgressLabel.textAlignment = .left
    teamProgressLabel.text = "Team Progress"
    totalWalkedTitleLabel.textAlignment = .left
    totalWalkedTitleLabel.text = "Total Walked"

    contentView.addSubview(teamProgressLabel) {
      $0.leading.equalToSuperview().offset(Style.Padding.p32)
      $0.top.equalToSuperview().offset(Style.Padding.p24)
    }

    contentView.addSubview(totalWalkedTitleLabel) {
      $0.top.equalTo(teamProgressLabel.snp.bottom).offset(Style.Padding.p8)
      $0.leading.equalToSuperview().offset(Style.Padding.p32)
      $0.bottom.equalToSuperview().inset(Style.Padding.p32)
    }

    contentView.addSubview(totalWalkedValueLabel) {
      $0.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.centerY.equalTo(totalWalkedTitleLabel.snp.centerY)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? TeamBreakdownHeaderCellContext else { return }
    totalWalkedValueLabel.text = "\(context.totalSteps)/\(context.totalCommitment) miles"
  }
}
