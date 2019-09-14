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

class OnboardingCreateTeam : UIViewController {                                 // swiftlint:disable:this colon
  private var lblCreateTeam: UILabel =
      UILabel(typography: .headerTitle, color: Style.Colors.green)
  private var imgCreateTeam: UIImageView =
      UIImageView(image: Assets.onboardingCreateTeam.image)

  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }

  private func layout() {
    self.view.backgroundColor = .white

    self.view.addSubviews([lblCreateTeam, imgCreateTeam])

    lblCreateTeam.text = Strings.Onboarding.createTeam
    lblCreateTeam.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(Style.Padding.p64)
      make.left.equalToSuperview().offset(Style.Padding.p24)
      make.right.equalToSuperview().inset(Style.Padding.p24)
    }

    imgCreateTeam.contentMode = .scaleAspectFit
    imgCreateTeam.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview()

      // TODO(compnerd) figure out how to reference the page control
      // This should have bottom snapped to 72px from the top of the pageControl
      make.top.equalToSuperview().offset(238)
    }
  }
}
