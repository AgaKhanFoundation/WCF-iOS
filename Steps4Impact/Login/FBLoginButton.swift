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
import SnapKit

class FBLoginButton: UIButton {

  let icon = UIImageView(image: UIImage(named: "facebookIcon"))
  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    self.backgroundColor = UIColor(named: "facebook")
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = true

    icon.contentMode = .scaleAspectFit
    addSubview(icon) { (maker) in
      maker.leading.equalToSuperview().inset(Style.Padding.p32)
      maker.top.equalToSuperview().inset(Style.Padding.p12)
      maker.bottom.equalToSuperview().inset(Style.Padding.p12)
      maker.width.equalTo(24)
      maker.height.equalTo(24)
    }

    label.text = Strings.Login.facebookButton
    label.textColor = .white
    label.font = Style.Typography.buttonTitle.font
    addSubview(label) { (maker) in
      maker.left.equalTo(icon.snp.right).inset(-Style.Padding.p24)
      maker.centerY.equalToSuperview()
      maker.trailing.equalToSuperview()
    }
  }

}
