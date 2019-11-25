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

protocol CellImageButtonViewDelegate: class {
  func cellImageButtonViewTapped()
}

struct CellImageButtonContext: Context {
  let label: String
}

class CellImageButtonView: View {
  private let seperatorLineView = UIView()
  private let label = UILabel(typography: .smallRegularBlue)
  private let imageButtonImageView = WebImageView(image: Assets.disclosure.image)

  weak var delegate: CellImageButtonViewDelegate?

  override func commonInit() {
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    seperatorLineView.backgroundColor = Style.Colors.Seperator

    addSubview(seperatorLineView) {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(1)
    }

    addSubview(imageButtonImageView) {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.height.equalTo(16)
      $0.width.equalTo(10)
    }

    addSubview(label) {
      $0.top.bottom.leading.equalToSuperview().inset(Style.Padding.p16)
      $0.trailing.equalTo(imageButtonImageView.snp.leading).offset(-Style.Padding.p16)
    }
  }

  func configure(context: CellImageButtonContext) {
    label.text = context.label
  }

  @objc
  func viewTapped() {
    delegate?.cellImageButtonViewTapped()
  }
}
