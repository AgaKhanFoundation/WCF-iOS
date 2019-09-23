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

protocol ConnectSourceCellDelegate: class {
  func connectSource(context: Context?)
}

struct ConnectSourceCellContext: CellContext {
  let identifier: String = ConnectSourceCell.identifier

  let name: String
  let description: String
  let selected: Bool
  let context: Context?
  let disabled: Bool
  let isLast: Bool
}

class ConnectSourceCell: ConfigurableTableViewCell {
  static let identifier = "ConnectSourceCell"

  private let lblName: UILabel = UILabel(typography: .bodyBold)
  private let lblDescription: UILabel = UILabel(typography: .bodyRegular)
  private let btnConnect: Button = Button(style: .primary)
  private let separator: UIView = UIView()
  private var context: Context?

  weak var delegate: ConnectSourceCellDelegate?

  override func commonInit() {
    super.commonInit()

    backgroundColor = Style.Colors.white

    separator.backgroundColor = Style.Colors.Seperator

    btnConnect.title = Strings.ConnectSource.connect
    btnConnect.addTarget(self, action: #selector(connect), for: .touchUpInside)

    contentView.addSubview(btnConnect) {
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.centerY.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.30)
    }

    let layoutGuide = UILayoutGuide()
    contentView.addLayoutGuide(layoutGuide) {
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p8)
      $0.leading.equalToSuperview().inset(Style.Padding.p32)
      $0.trailing.equalTo(btnConnect.snp.leading).offset(-Style.Padding.p8)
    }

    contentView.addSubview(lblName) {
      $0.leading.trailing.top.equalTo(layoutGuide)
    }

    contentView.addSubview(lblDescription) {
      $0.leading.trailing.bottom.equalTo(layoutGuide)
      $0.top.equalTo(lblName.snp.bottom).offset(Style.Padding.p8)
    }

    contentView.addSubview(separator) {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? ConnectSourceCellContext else { return }
    lblName.text = context.name
    lblDescription.text = context.description
    self.context = context.context
    separator.isHidden = context.isLast
    self.accessoryType = context.selected ? .checkmark : .none
    btnConnect.style = context.disabled || context.selected ? .disabled : .primary
    btnConnect.isEnabled = !context.disabled
  }

  @objc
  func connect() {
    delegate?.connectSource(context: context)
  }
}
