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

protocol ImageButtonCellDelegate: class {
  func imageButtonCellTapped(context: Context?)
}

struct ImageButtonCellContext: CellContext {
  let identifier: String = DisclosureCell.identifier
  var imgImage: WebImageView = WebImageView(image: Assets.placeholder.image)
  let title: String
  let body: String?
  let imageButtonTitle: String
  let context: Context?
  let mapURL: URL

  init(mapURL: URL, title: String, body: String?, disclosureTitle: String, context: Context? = nil) {
    self.mapURL = mapURL
    self.title = title
    self.body = body
    self.imageButtonTitle = disclosureTitle
    self.context = context
  }
}

class ImageButtonCell: ConfigurableTableViewCell {
  static let identifier = "ImageButtonCell"

  private let cardView = CardViewV2()
  private var cellImageView = WebImageView()
  private let titleLabel = UILabel(typography: .title)
  private let bodyLabel = UILabel(typography: .bodyRegular)
  private let imageButtonView = CellImageButtonView()
  private var context: Context?

  weak var delegate: ImageButtonCellDelegate?

  override func commonInit() {
    super.commonInit()

    cellImageView.contentMode = .scaleAspectFit
    //imageButtonView.delegate = self

    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = Style.Padding.p32
    stackView.addArrangedSubviews(cellImageView, titleLabel)

    cardView.addSubview(stackView) {
      $0.top.equalToSuperview().inset(Style.Padding.p32)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
    }

    cardView.addSubview(imageButtonView) {
      $0.leading.trailing.bottom.equalToSuperview()
    }

    cardView.addSubview(bodyLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalTo(stackView.snp.bottom).offset(Style.Padding.p32)
      $0.bottom.equalTo(imageButtonView.snp.top).offset(-Style.Padding.p32)
    }
  }

  func configure(context: CellContext) {
    guard let context = context as? ImageButtonCellContext else { return }

    let imageView = WebImageView()
    imageView.fadeInImage(imageURL: URL(string: "http://wcf.x10host.com/challenge1_1_v1.png"),
                          placeHolderImage: Assets.placeholder.image)
    cellImageView = imageView
    titleLabel.text = context.title
    bodyLabel.text = context.body
    self.context = context.context
    imageButtonView.configure(context: CellImageButtonContext(label: context.imageButtonTitle))
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    cellImageView.stopLoading()
  }
}

extension ImageButtonCell: CellDisclosureViewDelegate {
  func cellDisclosureTapped() {
    delegate?.imageButtonCellTapped(context: context)
  }
}
