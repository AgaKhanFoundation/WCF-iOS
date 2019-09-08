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

class Button: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  var title: String? {
    didSet {
      setTitle(title, for: .normal)
    }
  }
  
  func commonInit() {
    setBackgroundImage(UIImage(color: Style.Colors.FoundationGreen), for: .normal)
    setBackgroundImage(UIImage(color: Style.Colors.VerdantGreen), for: .highlighted)
    setBackgroundImage(UIImage(color: Style.Colors.VerdantGreen), for: .selected)
    setTitleColor(Style.Colors.white, for: .normal)
    layer.cornerRadius = 4
    layer.masksToBounds = true
    setTitle(currentTitle, for: .normal)
    snp.makeConstraints { $0.height.equalTo(Style.Size.s48) }
    
    contentEdgeInsets = UIEdgeInsets(
      top: Style.Size.s16,
      left: Style.Size.s16,
      bottom: Style.Size.s16,
      right: Style.Size.s16)
    
    guard let buttonFont = Style.Typography.bodyBold.font else { return }
    titleLabel?.font = buttonFont
    
    // this is to center the title in the actual button
    // descender is the part under the font for lowercase and is a negative number
    titleEdgeInsets = UIEdgeInsets(top: -buttonFont.descender / 2, left: 0, bottom: 0, right: 0)
  }
}
