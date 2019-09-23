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

import SnapKit
import UIKit

class OnboardingPageViewController: ViewController {
  struct PageContext: Context {
    let title: String
    let asset: Assets
    let tagLine: String?

    init(title: String, asset: Assets, tagLine: String? = nil) {
      self.title = title
      self.asset = asset
      self.tagLine = tagLine
    }
  }

  private let titleLabel = UILabel(typography: .headerTitle, color: Style.Colors.FoundationGreen)
  private let imageView = UIImageView()
  private let taglineLabel = UILabel(typography: .bodyRegular, color: Style.Colors.FoundationGreen)

  convenience init(context: PageContext) {
    self.init()
    configure(context: context)
  }

  override func configureView() {
    super.configureView()

    titleLabel.numberOfLines = 2
    titleLabel.adjustsFontSizeToFitWidth = true
    imageView.contentMode = .scaleAspectFit
    imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
    taglineLabel.textAlignment = .center

    view.addSubview(titleLabel) {
      $0.leading.trailing.top.equalToSuperview().inset(Style.Padding.p32)
    }

    view.addSubview(taglineLabel) {
      $0.leading.trailing.bottom.equalToSuperview().inset(Style.Padding.p32)
    }

    let layoutGuide = UILayoutGuide()
    view.addLayoutGuide(layoutGuide) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.bottom.equalTo(taglineLabel.snp.top)
    }

    view.insertSubview(imageView, belowSubview: titleLabel)
    imageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.centerY.equalTo(layoutGuide)
    }
  }

  func configure(context: PageContext) {
    titleLabel.text = context.title
    imageView.image = context.asset.image
    taglineLabel.text = context.tagLine
  }
}
