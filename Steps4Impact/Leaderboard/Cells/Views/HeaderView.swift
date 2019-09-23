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

class PlaceholderView: View {
  private let lbl: UILabel = {
    let lbl = UILabel(typography: .bodyRegular)
    lbl.numberOfLines = 2
    lbl.text = "Rest of the team rankings will show here."
    lbl.textAlignment = .center
    return lbl
  }()
  override func commonInit() {
    super.commonInit()

    addSubview(lbl) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalToSuperview().offset(Style.Padding.p16)
    }
  }
}

class HeaderView: View {
  private let teamName: UILabel = {
    let lbl = UILabel(typography: .bodyBold)
    lbl.numberOfLines = 0
    lbl.text = "Team Name"
    return lbl
  }()
  private let miles: UILabel = {
    let lbl = UILabel()
    lbl.numberOfLines = 0
    lbl.textAlignment = .right
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = Assets.downArrow.image
    imageAttachment.bounds = CGRect(
      x: 0,
      y: -Style.Padding.p8,
      width: imageAttachment.image!.size.width,
      height: imageAttachment.image!.size.height)
    let attachmentString = NSAttributedString(attachment: imageAttachment)
    let mileString = NSMutableAttributedString(
      string: "Miles",
      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
    mileString.append(attachmentString)
    lbl.attributedText = mileString
    return lbl
  }()

  override func commonInit() {
    super.commonInit()

    addSubview(teamName) {
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.centerY.equalToSuperview()
      $0.width.lessThanOrEqualTo(200)
    }

    addSubview(miles) {
      $0.trailing.equalToSuperview().offset(-Style.Padding.p16)
      $0.centerY.equalToSuperview()
      $0.width.lessThanOrEqualTo(200)
    }
  }
}
