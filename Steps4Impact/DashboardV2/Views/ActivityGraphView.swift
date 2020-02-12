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

class ActivityGraphViewLine: View {
  var progress: CGFloat = 0.0 { didSet { progressLine.progress = progress }}
  var day: String? { didSet { dayLabel.text = day }}
  var count: String? { didSet {
    countLabel.text = count
    if (count?.count ?? 0) > 2 {
      countLabel.transform = CGAffineTransform(rotationAngle: -(.pi / 4))
    } else {
      countLabel.transform = .identity
    }
  }}
  
  private let progressLine = VerticalProgressLineView()
  private let dayLabel = UILabel(typography: .bodyBold)
  private let countLabel = UILabel(typography: .smallRegular)
  
  override func commonInit() {
    super.commonInit()
    
    dayLabel.textAlignment = .center
    
    addSubview(progressLine) {
      $0.leading.trailing.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p32)
    }
    
    addSubview(dayLabel) {
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    addSubview(countLabel) {
      $0.leading.top.equalToSuperview()
    }
  }
}

class ActivityGraphView: View {
  private let progressViews = [
    ActivityGraphViewLine(),
    ActivityGraphViewLine(),
    ActivityGraphViewLine(),
    ActivityGraphViewLine(),
    ActivityGraphViewLine(),
    ActivityGraphViewLine(),
    ActivityGraphViewLine()
  ]
  private let dailyCommitmentLabel = UILabel(typography: .bodyRegular)
  
  private let progressStackView = UIStackView()
  
  override func commonInit() {
    super.commonInit()
    
    progressStackView.axis = .horizontal
    progressStackView.distribution = .equalSpacing
    progressViews.forEach { progressStackView.addArrangedSubview($0) }
    dailyCommitmentLabel.textAlignment = .center
    
    addSubview(progressStackView) {
      $0.width.equalToSuperview().multipliedBy(0.8)
      $0.height.equalTo(progressStackView.snp.height)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().inset(Style.Padding.p16)
    }
    
    addSubview(dailyCommitmentLabel) {
      $0.top.equalTo(progressStackView.snp.bottom).offset(Style.Padding.p16)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  func configure(state: ActivityState) {
    guard
      state.commitment > 0,
      state.currentPedometerData.count == 7
    else { return }
    
    let dailyCommitment: Int
    
    switch state.unit {
    case .miles:
      dailyCommitment = state.commitment / state.eventLengthInDays
      dailyCommitmentLabel.text = "Daily Commitment: \(dailyCommitment) miles"
    case .steps:
      dailyCommitment = (state.commitment * 2000) / state.eventLengthInDays
      dailyCommitmentLabel.text = "Daily Commitment: \(dailyCommitment) steps"
    }
    
    for (index, data) in state.currentPedometerData.enumerated() {
      
      var progress = CGFloat(data.count) / CGFloat(dailyCommitment)
      progress = max(0.0, progress)
      progress = min(1.0, progress)
      progressViews[index].progress = progress
      
      let dayOfWeek = Calendar.current.veryShortWeekdaySymbols[
        Calendar.current.component(.weekday, from: data.date) - 1]
      
      progressViews[index].day = dayOfWeek
      progressViews[index].count = "\(Int(data.count))"
    }
  }
}
