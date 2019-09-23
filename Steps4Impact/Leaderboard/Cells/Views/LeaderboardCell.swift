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

protocol CollapseCellDelegate: class {
  func collapseOrExpand()
}

struct LeaderboardCellContext: Context {
  let rank: Int
  let dist: Int
  let name: String
  let isUserTeam: Bool
}

class LeaderboardCell: TableViewCell {
  static let identifier = "LeaderboardCell"
  private let rankLbl: UILabel = {
    let lbl = UILabel(typography: .bodyRegular)
    lbl.numberOfLines = 0
    lbl.textAlignment = .left
    return lbl
  }()
  private let distLbl: UILabel = {
    let lbl = UILabel(typography: .bodyRegular)
    lbl.numberOfLines = 0
    lbl.textAlignment = .right
    return lbl
  }()
  private let teamLbl: UILabel = {
    let lbl = UILabel(typography: .bodyRegular)
    lbl.numberOfLines = 0
    lbl.lineBreakMode = .byTruncatingMiddle
    lbl.textAlignment = .left
    return lbl
  }()

  override func commonInit() {
    super.commonInit()

    addSubview(rankLbl) {
      $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(Style.Padding.p16)
      $0.centerY.equalToSuperview()
      $0.width.lessThanOrEqualTo(200)
    }

    addSubview(distLbl) {
      $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-Style.Padding.p16)
      $0.centerY.equalToSuperview()
      $0.width.lessThanOrEqualTo(200)
    }

    addSubview(teamLbl) {
      $0.leading.equalTo(rankLbl.snp.trailing).offset(Style.Padding.p16)
      $0.trailing.equalTo(distLbl.snp.leading).offset(-Style.Padding.p16)
      $0.centerY.equalToSuperview()
    }
  }
  func configure(context: LeaderboardCellContext) {
    if context.isUserTeam {
      rankLbl.textColor = Style.Colors.green
      distLbl.textColor = Style.Colors.green
      teamLbl.textColor = Style.Colors.green
    }
    rankLbl.text = "\(context.rank)."
    distLbl.text = "\(context.dist) mi"
    teamLbl.text = context.name
  }
}

class CollapseCell: TableViewCell {
  static let identifier = "CollapseCell"
  var lbl: UILabel = UILabel(typography: .bodyRegular, color: Style.Colors.grey)
  weak var delegate: CollapseCellDelegate?

  override func commonInit() {
    super.commonInit()

    lbl.text = "Expand"
    isUserInteractionEnabled = true
    let gesture = UITapGestureRecognizer(target: self, action: #selector(collapseOrExpand))
    addGestureRecognizer(gesture)
    addSubview(lbl) {
      $0.centerX.centerY.equalToSuperview()
    }
  }
  @objc
  func collapseOrExpand() {
    delegate?.collapseOrExpand()
  }
}
