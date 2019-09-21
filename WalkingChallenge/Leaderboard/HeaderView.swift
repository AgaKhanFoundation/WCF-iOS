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

extension Leaderboard {
  class HeaderView: UIView {
    var mileString = NSMutableAttributedString(string: String())
    let teamNameLbl: UILabel = {
      let lbl = UILabel(typography: .placeholderBold)
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.text = Strings.Leaderboard.teamName
      lbl.textAlignment = .left
      lbl.numberOfLines = 0
      return lbl
    }()
    lazy var milesLbl: UILabel = {
      let lbl = UILabel()
      lbl.translatesAutoresizingMaskIntoConstraints = false
      lbl.textAlignment = .right
      let imageAttachment =  NSTextAttachment()
      imageAttachment.image = UIImage(named: Assets.chevron)
      let imageOffsetY = -Style.Padding.p4
      imageAttachment.bounds = CGRect(
        x: 0, y: imageOffsetY,
        width: imageAttachment.image!.size.width,
        height: imageAttachment.image!.size.height
      )
      let attachmentString = NSAttributedString(attachment: imageAttachment)
      mileString = NSMutableAttributedString(
        string: Strings.Leaderboard.miles,
        attributes: [NSAttributedString.Key.font: Style.Font.leaderboardBold]
      )
      mileString.append(attachmentString)
      lbl.attributedText = mileString
      lbl.numberOfLines = 0
      return lbl
    }()
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
      super.layoutSubviews()
      setupViews()
    }
    private func setupViews() {
      addSubview(teamNameLbl)
      addSubview(milesLbl)
      teamNameLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
      teamNameLbl.widthAnchor.constraint(lessThanOrEqualToConstant: Style.Size.s200).isActive = true
      milesLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
      milesLbl.widthAnchor.constraint(lessThanOrEqualToConstant: Style.Size.s200).isActive = true
      if traitCollection.horizontalSizeClass == .compact ||
        traitCollection.verticalSizeClass == .regular {
        teamNameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.Size.s24).isActive = true
        milesLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.Padding.p16).isActive = true
      } else {
        teamNameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.Padding.p86).isActive = true
        milesLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.Padding.p64).isActive = true
      }
    }
  }
}
