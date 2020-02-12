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

class ActivityProgressView: View {
  private let progressView = CircularProgressView()
  private let headerLabel = UILabel(typography: .headerTitle, color: Style.Colors.FoundationGreen)
  private let subtitleLabel = UILabel(typography: .subtitleRegular, color: Style.Colors.Silver)
  
  override func commonInit() {
    super.commonInit()
    
    headerLabel.textAlignment = .center
    subtitleLabel.textAlignment = .center
    
    addSubview(progressView) {
      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.height.equalTo(progressView.snp.width)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().inset(Style.Padding.p16)
      $0.bottom.equalToSuperview()
    }
    
    addSubview(headerLabel) {
      $0.leading.trailing.centerY.equalTo(progressView)
    }
    
    addSubview(subtitleLabel) {
      $0.leading.trailing.equalTo(headerLabel)
      $0.top.equalTo(headerLabel.snp.bottom)
    }
  }
  
  func configure(state: ActivityState) {
    guard
      state.commitment > 0,
      let currentData = state.currentPedometerData.first
    else { return }
    
    var progress: CGFloat = 0
    
    switch state.unit {
    case .miles:
      let dailyCommitment = state.commitment / state.eventLengthInDays
      progress = CGFloat(currentData.count) / CGFloat(dailyCommitment)
      headerLabel.text = String(format: "%0.2f", currentData.count)
      subtitleLabel.text = "/\(Int(dailyCommitment)) miles"
    case .steps:
      let dailyCommitment = (state.commitment * 2000) / state.eventLengthInDays
      progress = CGFloat(currentData.count) / CGFloat(dailyCommitment)
      headerLabel.text = "\(Int(currentData.count))"
      subtitleLabel.text = "/\(Int(dailyCommitment)) steps"
    }
    
    progress = max(0.0, progress)
    progress = min(1.0, progress)
    progressView.progress = progress
    progressView.redraw()
  }
}
