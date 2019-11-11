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

struct ActivityCardCellContext: CellContext {
  let identifier: String = ActivityCardCell.identifier
  let title: String
  let milesDayCount: Int
  let milesWeekCount: Int
  let commitment: Int
}

class ActivityCardCell: ConfigurableTableViewCell {
  static let identifier = "ActivityCardCell"

  private let cardView = CardViewV2()
  private let titleLabel = UILabel(typography: .title)
  private let buttonView = ActivityCardCellButtonView()
  private let currentLabel = UILabel(typography: .bodyRegular) // TODO(samisuteria) replace with day/week selector
  private let progressView = CircularProgressView()
  private var milesDayCount: Int = 0
  private var milesWeekCount: Int = 0
  private var commitment: Int = 0

  override func commonInit() {
    super.commonInit()
    currentLabel.textAlignment = .center
    buttonView.delegate = self

    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }

    cardView.addSubview(titleLabel) {
      $0.top.equalToSuperview().inset(Style.Padding.p32)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
    }

    cardView.addSubview(buttonView) {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p16)
    }

    cardView.addSubview(currentLabel) {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(buttonView.snp.bottom).offset(Style.Padding.p16)
    }

    cardView.addSubview(progressView) {
      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.height.equalTo(progressView.snp.width)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(currentLabel.snp.bottom).offset(Style.Padding.p16)
      $0.bottom.equalToSuperview().inset(Style.Padding.p32)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? ActivityCardCellContext else { return }
    titleLabel.text = context.title
    currentLabel.text = "Today"
    milesDayCount = context.milesDayCount
    milesWeekCount = context.milesWeekCount
    commitment = context.commitment
    updateProgressBar()
  }

  private func updateProgressBar() {
    guard commitment > 0 else { return }
    var progress: CGFloat = 0.0
    switch buttonView.state {
    case .day:
      progress = CGFloat(milesDayCount) / CGFloat(commitment)
    case .week:
      progress = CGFloat(milesWeekCount) / CGFloat(commitment * 7)
    }
    progress = max(0, progress)
    progress = min(1.0, progress)
    progressView.progress = progress
    progressView.redraw()
  }
}

extension ActivityCardCell: ActivityCardCellButtonViewDelegate {
  func activityCardCellButtonViewChanged(state: ActivityCardCellButtonView.State) {
    switch state {
    case .day:
      currentLabel.text = "Today"
    case .week:
      currentLabel.text = "This Week"
    }
    updateProgressBar()
  }
}

protocol ActivityCardCellButtonViewDelegate: class {
  func activityCardCellButtonViewChanged(state: ActivityCardCellButtonView.State)
}

class ActivityCardCellButtonView: View {
  enum State {
    case day
    case week
  }

  private let dayButton = Button(style: .plain)
  private let weekButton = Button(style: .plain)
  private let underlineView = UIView()
  var state: State = .day { didSet { updateState() }}
  weak var delegate: ActivityCardCellButtonViewDelegate?

  override func commonInit() {
    super.commonInit()
    dayButton.title = "Day"
    dayButton.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
    weekButton.title = "Week"
    weekButton.addTarget(self, action: #selector(weekButtonTapped), for: .touchUpInside)
    underlineView.backgroundColor = Style.Colors.FoundationGreen

    addSubview(dayButton) {
      $0.top.bottom.leading.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(2)
    }

    addSubview(weekButton) {
      $0.top.bottom.trailing.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(2)
    }

    addSubview(underlineView) {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalTo(dayButton)
    }
  }

  @objc func dayButtonTapped() {
    state = .day
  }

  @objc func weekButtonTapped() {
    state = .week
  }

  private func updateState() {
    delegate?.activityCardCellButtonViewChanged(state: state)
    underlineView.snp.remakeConstraints {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      switch state {
      case .day: $0.leading.trailing.equalTo(dayButton)
      case .week: $0.leading.trailing.equalTo(weekButton)
      }
    }

    setNeedsLayout()
    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
  }
}
