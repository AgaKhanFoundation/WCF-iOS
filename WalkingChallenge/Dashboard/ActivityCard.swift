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
import Foundation

class ActivityCardView: StylizedCardView {
  internal enum Range: Int {
    case daily
    case weekly
    case total
  }

  private class RangeDataSource: SelectionButtonDataSource {
    var items: [String] = [Range.daily.description,
                           Range.weekly.description,
                           Range.total.description]
    var selection: Int?
  }

  private var lblTitle: UILabel = UILabel(typography: .title)
  private var cboRange: SelectionButton = SelectionButton(type: .system)
  private let btnPrevious: UIButton = UIButton(type: .system)
  private let prgProgressRing: ProgressRing =
    ProgressRing(radius: 64.0, width: 16.0)
  private let btnNext: UIButton = UIButton(type: .system)
  private let lblDaysUntil: UILabel = UILabel(typography: .smallText)
  private let lblDate: UILabel = UILabel(frame: .zero)
  private let btnJoinChallenge: UIButton = UIButton(type: .system)

  private let datRangeDataSource: RangeDataSource = RangeDataSource()

  internal func layout() {
    addSubviews([lblTitle, cboRange, lblDaysUntil, lblDate, btnJoinChallenge])

    layoutHeader()
    layoutDetails()

    lblDaysUntil.textColor = Style.Colors.FoundationGrey
    lblDaysUntil.snp.makeConstraints {
      $0.bottom.equalTo(prgProgressRing.snp.bottom)
      $0.left.equalToSuperview().offset(Style.Padding.p16)
    }

    lblDate.snp.makeConstraints {
      $0.top.equalTo(lblDaysUntil.snp.bottom)
      $0.left.equalTo(lblDaysUntil.snp.left)

      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
    }

    btnJoinChallenge.setTitle(Strings.ActivityCard.joinChallenge, for: .normal)
    btnJoinChallenge.snp.makeConstraints {
      $0.left.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalTo(prgProgressRing.snp.bottom)
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
    }
  }

  private func layoutHeader() {
    lblTitle.text = Strings.ActivityCard.title
    lblTitle.font = lblTitle.font.withSize(16)
    lblTitle.snp.makeConstraints {
      $0.left.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalToSuperview().inset(Style.Padding.p16)
    }

    cboRange.dataSource = datRangeDataSource
    cboRange.delegate = self
    cboRange.selection = Range.daily.rawValue
    cboRange.snp.makeConstraints {
      $0.centerY.equalTo(lblTitle.snp.centerY)
      $0.right.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalToSuperview().inset(Style.Padding.p16)
    }
  }

  private func layoutDetails() {
    let view: UIView = UIView(frame: .zero)

    view.addSubview(btnPrevious)
    btnPrevious.setTitle("\u{2039}", for: .normal)
    btnPrevious.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.bottom.equalToSuperview()
    }

    view.addSubview(prgProgressRing)
    prgProgressRing.snp.makeConstraints {
      // NOTE(compnerd) this must be radius * 2 due to the way that the progress bar is rendered.
      // TODO(compnerd) fix the frame sizing for hte custom widget
      $0.width.height.equalTo(prgProgressRing.arcRadius * 2.0)
      $0.center.equalToSuperview()
      $0.top.bottom.equalToSuperview()
    }

    view.addSubview(btnNext)
    btnNext.setTitle("\u{203a}", for: .normal)
    btnNext.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.right.equalToSuperview()
    }

    addSubview(view)
    view.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(cboRange.snp.bottom).offset(Style.Padding.p8)
    }
  }
}

extension ActivityCardView.Range: CustomStringConvertible {
  var description: String {
    switch self {
    case .daily: return Strings.ActivityCard.daily
    case .weekly: return Strings.ActivityCard.weekly
    case .total: return Strings.ActivityCard.total
    }
  }
}

extension ActivityCardView: CardView {
  static let identifier: String = "ActivityCard"

  func render(_ context: Any) {
    guard let data = context as? ActivityCard else { return }

    if let date = data.challengeStartDate {
      lblDaysUntil.isHidden = date.timeIntervalSinceNow >= 0

      lblDate.isHidden = false

      let formatter: DateFormatter = DateFormatter()
      formatter.dateFormat = "E, MM/dd"

      lblDate.text = formatter.string(from: date)

      btnJoinChallenge.isHidden = true
    } else {
      lblDaysUntil.isHidden = true
      lblDate.isHidden = true

      btnJoinChallenge.isHidden = false
    }

    _ = data
  }
}

extension ActivityCardView: SelectionButtonDelegate {
  func present(_ viewControllerToPresent: UIViewController,
               animated: Bool, completion: (() -> Void)?) {
    AppController.shared
      .navigation
      .selectedViewController?
      .present(viewControllerToPresent, animated: animated,
               completion: completion)
  }
}

struct ActivityCard: Card {
  let renderer: String = ActivityCardView.identifier

  var challengeStartDate: Date?
}
