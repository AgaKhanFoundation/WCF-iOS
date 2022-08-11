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

import Foundation
import UIKit

protocol NotificationPermissionCellDelegate: AnyObject {
  func turnOnNotifictions()
  func close()
}

struct NotificationPermissionCellContext: CellContext {
  let identifier: String = NotificationPermissionCell.identifier
  let title: String
  let description: String
  let disclosureText: String
}

class NotificationPermissionCell: ConfigurableTableViewCell {
  static var identifier: String = "NotificationPermissionCell"
  
  private let cardView = CardViewV2()
  private let disclosureView = CellDisclosureView()
  
  weak var delegate: NotificationPermissionCellDelegate?
  
  let headerLabel = UILabel(typography: .title)
  let descriptionLabel = UILabel(typography: .smallRegular, color: Style.Colors.FoundationGrey.withAlphaComponent(0.5))
  
  let closeButton: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Assets.close.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override func commonInit() {
    super.commonInit()
    backgroundColor = .clear
    disclosureView.delegate = self
    
    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }
    
    cardView.addSubview(headerLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalToSuperview().offset(Style.Padding.p20)
    }
    
    cardView.addSubview(descriptionLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalTo(headerLabel.snp.bottom).offset(Style.Padding.p8)
    }
  
    cardView.addSubview(disclosureView) {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(Style.Padding.p20)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    cardView.addSubview(closeButton) {
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalToSuperview().offset(Style.Padding.p16)
      $0.height.width.equalTo(Style.Size.s12)
    }
    
    closeButton.isUserInteractionEnabled = true
    closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped)))
  }
  
  func configure(context: CellContext) {
    guard let context = context as? NotificationPermissionCellContext else {
      return
    }
    
    headerLabel.text = context.title
    descriptionLabel.text = context.description
    disclosureView.configure(context: CellDisclosureContext(label: context.disclosureText))
  }
  
  @objc func closeButtonTapped() {
    delegate?.close()
  }
}

extension NotificationPermissionCell: CellDisclosureViewDelegate {
  func cellDisclosureTapped() {
    delegate?.turnOnNotifictions()
  }
}
