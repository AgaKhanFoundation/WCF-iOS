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

struct ConnectDeviceInformationCellContext: CellContext {
  let identifier: String = ConnectDeviceInformationCell.identifier
}

class ConnectDeviceInformationCell: ConfigurableTableViewCell, Contextable {
  static var identifier: String = "ConnectDeviceInformationCell"

  private var lblQuestion: UILabel = UILabel(typography: .subtitleRegular,
                                             color: Style.Colors.FoundationGrey)
  private let lblDetails: UILabel = UILabel(typography: .subtitleRegular,
                                            color: Style.Colors.FoundationGrey)
  private let btnExpand: UIButton = UIButton(frame: .zero)
  private var bExpanded: Bool = false

  var context: Context?

  override func commonInit() {
    super.commonInit()

    backgroundColor = Style.Colors.white

    lblQuestion.text = Strings.ConnectSource.missingDevice
    contentView.addSubview(lblQuestion) { (make) in
      make.leading.top.equalToSuperview().inset(Style.Padding.p16)
    }

    btnExpand.setImage(Assets.invertedCircumflex.image, for: .normal)
    btnExpand.imageView?.contentMode = .scaleAspectFit
    btnExpand.addTarget(self, action: #selector(expandTapped), for: .touchUpInside)
    contentView.addSubview(btnExpand) { (make) in
      make.trailing.top.equalToSuperview().inset(Style.Padding.p16)
      make.height.width.equalTo(Style.Size.s16)
      make.centerY.equalTo(lblQuestion.snp.centerY)
    }

    lblDetails.text = Strings.ConnectSource.missingDeviceDetails
    contentView.addSubview(lblDetails) { (make) in
      make.leading.trailing.bottom.equalToSuperview().inset(Style.Padding.p16)
      make.top.equalTo(lblQuestion.snp.bottom).offset(Style.Padding.p8
      )
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? ConnectDeviceInformationCellContext else { return }
    lblDetails.isHidden = !bExpanded
  }

  @objc
  private func expandTapped() {
    lblDetails.isHidden = !lblDetails.isHidden
    btnExpand.setImage(bExpanded ? Assets.invertedCircumflex.image : Assets.circumflex.image, for: .normal)
    bExpanded = !bExpanded
  }
}
