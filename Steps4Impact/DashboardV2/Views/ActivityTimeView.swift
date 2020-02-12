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

protocol ActivityTimeViewDelegate: class {
  func activityTimeViewTapped(time: ActivityTime)
}

class ActivityTimeView: View {
  private let dayButton = Button(style: .plain)
  private let weekButton = Button(style: .plain)
  private let underlineView = View()
  
  weak var delegate: ActivityTimeViewDelegate?
  
  override func commonInit() {
    super.commonInit()
    dayButton.title = "Day"
    weekButton.title = "Week"
    dayButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    weekButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    underlineView.backgroundColor = Style.Colors.FoundationGreen
    
    addSubview(dayButton) {
      $0.top.bottom.leading.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(2)
    }
    
    addSubview(weekButton) {
      $0.top.bottom.trailing.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(2)
      $0.leading.equalTo(dayButton.snp.trailing)
    }
    
    addSubview(underlineView) {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalTo(dayButton)
    }
  }
  
  func configure(state: ActivityState) {
    underlineView.snp.remakeConstraints {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      switch state.time {
      case .day: $0.leading.trailing.equalTo(dayButton)
      case .week: $0.leading.trailing.equalTo(weekButton)
      }
    }
    
    setNeedsLayout()
    UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
      self.layoutIfNeeded()
    }, completion: nil)
  }
  
  @objc
  func buttonTapped(_ sender: Button) {
    switch sender {
    case dayButton:
      delegate?.activityTimeViewTapped(time: .day)
    case weekButton:
      delegate?.activityTimeViewTapped(time: .week)
    default:
      break
    }
  }
}
