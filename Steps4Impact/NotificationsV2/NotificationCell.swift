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

struct NotificationCellInfo: CellContext {
  let identifier: String = NotificationCell.identifier
  let title: String
  let date: Date
  let isRead: Bool
  let isFirst: Bool
  let isLast: Bool
  
  init(title: String, date: Date, isRead: Bool = true, isFirst: Bool = false, isLast: Bool = false) {
    self.title = title
    self.date = date
    self.isRead = isRead
    self.isFirst = isFirst
    self.isLast = isLast
  }
}

class NotificationCell: ConfigurableTableViewCell {
  static let identifier: String = "NotificationCell"
  
  private let containerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Style.Size.s8
    view.layer.maskedCorners = []
    view.layer.borderColor = Style.Colors.FoundationGrey.withAlphaComponent(0.1).cgColor
    view.layer.borderWidth = 1.0
    return view
  }()
  private let titleLabel = UILabel(typography: .bodyRegular)
  private let dateLabel = UILabel(typography: .footnote, color: Style.Colors.FoundationGrey.withAlphaComponent(0.5))
  
  override func commonInit() {
    super.commonInit()
    
    contentView.addSubview(containerView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview()
    }
    
    containerView.addSubview(titleLabel) {
      $0.leading.trailing.top.equalToSuperview().inset(Style.Padding.p12)
    }
    
    containerView.addSubview(dateLabel) {
      $0.leading.trailing.bottom.equalToSuperview().inset(Style.Padding.p12)
      $0.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p12)
    }
  }
  
  func configure(context: CellContext) {
    guard let context = context as? NotificationCellInfo else { return }
    
    if context.isRead {
      containerView.backgroundColor = Style.Colors.white
    } else {
      containerView.backgroundColor = Style.Colors.FoundationGreen.withAlphaComponent(0.1)
    }
    
    titleLabel.text = context.title
    dateLabel.text = "\(context.date.timeAgo() ?? "")"
    
    if context.isFirst {
      containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    } else if context.isLast {
      containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    } else {
      containerView.layer.maskedCorners = []
    }
  }
}
