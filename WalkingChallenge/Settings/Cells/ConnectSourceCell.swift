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
}

class ConnectSourceCell: ConfigurableTableViewCell {
  static let identifier = "ConnectSourceCell"

  private let lblName: UILabel = UILabel(typography: .bodyBold)
  private let lblDescription: UILabel = UILabel(typography: .bodyRegular)
  private let btnConnect: UIButton = Button(style: .primary)
  private let separator: UIView = UIView()
  private var context: Context?

  weak var delegate: ConnectSourceCellDelegate?

  override func commonInit() {
    super.commonInit()

    backgroundColor = Style.Colors.white

    separator.backgroundColor = Style.Colors.Seperator

    btnConnect.setTitle(Strings.ConnectSource.connect, for: .normal)
    btnConnect.addTarget(self, action: #selector(connect(_:)),
                         for: .touchUpInside)

    contentView.addSubview(btnConnect)

    contentView.addSubview(lblName) {
      $0.leading.equalToSuperview().inset(Style.Padding.p32)
      $0.trailing.equalTo(btnConnect.snp.leading).offset(Style.Padding.p8)
      $0.top.equalToSuperview().offset(Style.Padding.p8)
    }
    contentView.addSubview(lblDescription) {
      $0.leading.equalToSuperview().inset(Style.Padding.p32)
      $0.trailing.equalTo(btnConnect.snp.leading).inset(Style.Padding.p12)
      $0.top.equalTo(lblName.snp.bottom).offset(Style.Padding.p8)
      $0.bottom.equalToSuperview().inset(Style.Padding.p8)
    }
    btnConnect.snp.makeConstraints { (make) in
      make.trailing.equalToSuperview().inset(Style.Padding.p16)
      make.width.equalToSuperview().multipliedBy(0.30)
      make.centerY.equalToSuperview()
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
    btnConnect.isEnabled = !context.selected
    self.context = context.context

    self.accessoryType = context.selected ? .checkmark : .none
    self.isUserInteractionEnabled = !context.disabled
    // TODO(compnerd) grey out the cell?
  }

  @objc
  func connect(_ sender: UIView) {
    delegate?.connectSource(context: context)
  }
}
