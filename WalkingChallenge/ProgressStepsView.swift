/**
 * Copyright © 2017 Aga Khan Foundation
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

import Foundation
import UIKit
import SnapKit

class ProgressStepsView: UIView {
  internal let stkStackView: UIStackView = UIStackView()
  internal let uvwBar: UIView = UIView()

  var axis: UILayoutConstraintAxis = .horizontal {
    didSet { stkStackView.axis = axis }
  }
  var diameter: CGFloat = 40.0
  var steps: Int {
    didSet {
      createSteps(steps)
    }
  }
  var progress: Int = 1 {
    didSet {
      setProgress(progress)
    }
  }

  init(withSteps: Int) {
    steps = withSteps
    super.init(frame: CGRect.zero)

    addSubview(uvwBar)
    uvwBar.layer.borderColor = Style.Colors.grey.cgColor
    uvwBar.layer.borderWidth = 3.0
    uvwBar.snp.makeConstraints { (make) in
      make.height.equalTo(3.0)
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }

    addSubview(stkStackView)
    stkStackView.alignment = .leading
    stkStackView.spacing = diameter
    stkStackView.snp.makeConstraints { (make) in
      make.centerX.centerY.equalToSuperview()
    }

    createSteps(withSteps)
    setProgress(progress)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func createSteps(_ count: Int) {
    for view in stkStackView.arrangedSubviews {
      view.removeFromSuperview()
      stkStackView.removeArrangedSubview(view)
    }

    for step in 1...count {
      let view: UILabel = UILabel()
      view.snp.makeConstraints { (make) in
        make.height.equalTo(diameter)
        make.width.equalTo(diameter)
      }
      view.backgroundColor = Style.Colors.white
      view.font = UIFont.boldSystemFont(ofSize: 16.0)
      view.layer.borderColor = Style.Colors.grey.cgColor
      view.layer.borderWidth = 3.0
      view.layer.cornerRadius = diameter / 2
      view.text = "\(step)"
      view.textAlignment = .center
      view.textColor = Style.Colors.grey

      stkStackView.addArrangedSubview(view)
    }
  }

  private func setProgress(_ steps: Int) {
    for step in 0..<steps {
      guard
        let view = stkStackView.arrangedSubviews[safe: step] as? UILabel
        else { return }

      view.layer.borderColor = Style.Colors.green.cgColor
      view.textColor = Style.Colors.green
    }
  }
}
