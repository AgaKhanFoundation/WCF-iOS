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

protocol ActivityUnitViewDelegate: AnyObject {
  func activityUnitViewTapped(unit: ActivityUnit)
}

class ActivityUnitView: View {
  private let stackView = UIStackView(axis: .horizontal,
                                      spacing: Style.Padding.p8,
                                      alignment: .fill)
  private let milesRadioButton = RadioButton()
  private let stepsRadioButton = RadioButton()
  
  weak var delegate: ActivityUnitViewDelegate?
  
  override func commonInit() {
    super.commonInit()
    
    milesRadioButton.title = "Miles"
    stepsRadioButton.title = "Steps"
    milesRadioButton.delegate = self
    stepsRadioButton.delegate = self
    stackView.addArrangedSubviews(milesRadioButton, stepsRadioButton)
    addSubview(stackView) {
      $0.top.leading.equalToSuperview().inset(Style.Padding.p16)
      $0.bottom.equalToSuperview()
    }
  }
  
  func configure(state: ActivityState) {
    switch state.unit {
    case .miles:
      milesRadioButton.state = .selected
      stepsRadioButton.state = .unselected
    case .steps:
      milesRadioButton.state = .unselected
      stepsRadioButton.state = .selected
    }
  }
}

extension ActivityUnitView: RadioButtonDelegate {
  func radioButtonTapped(radioButton: RadioButton) {
    switch radioButton {
    case milesRadioButton:
      delegate?.activityUnitViewTapped(unit: .miles)
    case stepsRadioButton:
      delegate?.activityUnitViewTapped(unit: .steps)
    default:
      break
    }
  }
}
