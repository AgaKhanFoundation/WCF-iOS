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

protocol RadioButtonDelegate: class {
  func radioButtonTapped(radioButton: RadioButton)
}

class RadioButton: View {
  enum State {
    case selected
    case unselected
  }
  
  var state: State = .unselected { didSet { update() }}
  var title: String? { didSet { button.title = title }}
  weak var delegate: RadioButtonDelegate?
  
  private let button = Button(style: .plain)
  private let circleView = View()
  
  override func commonInit() {
    super.commonInit()
    circleView.layer.borderColor = Style.Colors.FoundationGreen.cgColor
    circleView.layer.borderWidth = 2
    circleView.layer.cornerRadius = 8
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    
    let tapGesture = UITapGestureRecognizer()
    circleView.addGestureRecognizer(tapGesture)
    
    addSubview(button) {
      $0.top.bottom.trailing.equalToSuperview()
    }
    
    addSubview(circleView) {
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(button.snp.leading).offset(Style.Padding.p8)
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(16)
    }
  }
  
  private func update() {
    switch state {
    case .selected:
      circleView.backgroundColor = Style.Colors.FoundationGreen
    case .unselected:
      circleView.backgroundColor = nil
    }
  }
  
  @objc
  func buttonTapped() {
    delegate?.radioButtonTapped(radioButton: self)
  }
  
  @objc
  func radioTapped() {
    delegate?.radioButtonTapped(radioButton: self)
  }
}
