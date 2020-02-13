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
  let stepsData: [PedometerData]
  let milesData: [PedometerData]
  let commitment: Int
  let eventLengthInDays: Int
}

class ActivityCardCell: ConfigurableTableViewCell {
  static let identifier: String = "ActivityCardCell"
  
  // Views
  private let cardView = CardViewV2()
  private let titleLabel = UILabel(typography: .title)
  private let activityView = ActivityView()
  
  override func commonInit() {
    super.commonInit()
    
    titleLabel.numberOfLines = 1
    
    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }
    
    cardView.addSubview(titleLabel) {
      $0.top.equalToSuperview().inset(Style.Padding.p32)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
    }
    
    cardView.addSubview(activityView) {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p16)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
    }
  }
  
  func configure(context: CellContext) {
    guard let context = context as? ActivityCardCellContext else { return }
    titleLabel.text = context.title
    activityView.configure(data: ActivityData(
      milesData: context.milesData,
      stepsData: context.stepsData,
      commitment: context.commitment,
      eventLengthInDays: context.eventLengthInDays))
  }
}
