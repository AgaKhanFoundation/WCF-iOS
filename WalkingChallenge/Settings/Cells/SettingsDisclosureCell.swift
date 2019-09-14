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

struct SettingsDisclosureCellContext: CellContext {
  let cellIdentifier: String = SettingsDisclosureCell.identifier
  let title: String
  let body: String?
  let value: String?
  let isDisclosureHidden: Bool
  let isLastItem: Bool
  let context: Context?
  init(title: String, body: String? = nil, value: String? = nil, isDisclosureHidden: Bool = false, isLastItem: Bool = false, context: Context? = nil) {

    self.title = title
    self.body = body
    self.value = value
    self.isDisclosureHidden = isDisclosureHidden
    self.isLastItem = isLastItem
    self.context = context
  }
}

class SettingsDisclosureCell: ConfigurableTableViewCell, Contextable {
  static let identifier = "SettingsDisclosureCell"

  private let titleLabel = UILabel(typography: .bodyRegular)
  private let bodyLabel = UILabel(typography: .smallRegular)
  private let valueLabel = UILabel(typography: .subtitleRegular)
  private let disclosureImageView = UIImageView(image: Assets.disclosure.image)
  private let seperatorView = UIView()
  var context: Context?

  override func commonInit() {
    super.commonInit()

    backgroundColor = Style.Colors.white
    valueLabel.textAlignment = .right
    seperatorView.backgroundColor = Style.Colors.Seperator

    let layoutGuide = UILayoutGuide()
    contentView.addLayoutGuide(layoutGuide: layoutGuide) {
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p16)
      $0.leading.equalToSuperview().inset(Style.Padding.p32)
      $0.width.equalToSuperview().multipliedBy(0.6)
    }

    contentView.addSubview(titleLabel) {
      $0.leading.trailing.top.equalTo(layoutGuide)
    }

    contentView.addSubview(bodyLabel) {
      $0.leading.trailing.bottom.equalTo(layoutGuide)
      $0.top.equalTo(titleLabel.snp.bottom)
    }

    contentView.addSubview(disclosureImageView) {
      $0.top.equalToSuperview().inset(Style.Padding.p16)
      $0.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.height.equalTo(16)
      $0.width.equalTo(10)
    }

    contentView.addSubview(valueLabel) {
      $0.leading.equalTo(layoutGuide.snp.trailing)
      $0.trailing.equalTo(disclosureImageView.snp.leading).offset(-Style.Padding.p8)
      $0.top.equalToSuperview().inset(Style.Padding.p16)
    }

    contentView.addSubview(seperatorView) {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? SettingsDisclosureCellContext else { return }

    titleLabel.text = context.title
    bodyLabel.text = context.body
    valueLabel.text = context.value
    disclosureImageView.isHidden = context.isDisclosureHidden
    seperatorView.isHidden = context.isLastItem
    self.context = context.context
  }
}
