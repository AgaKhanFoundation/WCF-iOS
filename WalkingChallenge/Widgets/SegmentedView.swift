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

internal class SegmentedView: UISegmentedControl {
  private var bar: UIView = UIView(frame: .zero)

  public override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .clear
    self.tintColor = .clear
    self.selectedSegmentIndex = 0

    self.setTitleTextAttributes([
        .font: Style.Typography.subtitleBold.font as Any,
        .foregroundColor: Style.Colors.black,                                   // swiftlint:disable:this trailing_comma
    ], for: .normal)
    self.setTitleTextAttributes([
        .font: Style.Typography.subtitleBold.font as Any,
        .foregroundColor: Style.Colors.black,                                   // swiftlint:disable:this trailing_comma
    ], for: .selected)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    self.addSubview(bar)
    bar.backgroundColor = Style.Colors.green
    bar.snp.makeConstraints {
      $0.top.equalTo(self.snp.bottom)
      // TODO(compnerd) figure out a height that is desirable
      $0.height.equalTo(5)
      $0.left.equalTo(self.snp.left)
      $0.width.equalTo(self.snp.width).dividedBy(self.numberOfSegments)
    }

    self.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
  }

  @objc private func indexChanged(_ sender: UISegmentedControl) {
    UIView.animate(withDuration: 0.3) {
      self.bar.frame.origin.x =
          (self.frame.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
    }
  }
}
