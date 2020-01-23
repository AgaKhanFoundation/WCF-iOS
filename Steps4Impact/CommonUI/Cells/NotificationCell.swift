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

protocol NotificationCellDelegate: class {
  func notificationCellTapped(context: Context?)
}

struct NotificationCellContext: CellContext {
  let identifier: String = NotificationCell.identifier
  let message: String
  let timeDelta: String
  let backgroundColor: UIColor
  let context: NotificationContext
  
  init(message: String, timeDelta: String, backgroundColor: UIColor, context: NotificationContext) {
    self.message = message
    self.timeDelta = timeDelta
    self.backgroundColor = backgroundColor
    self.context = context
  }
}

enum NotificationContext: Context {
  case none
  case markRead(notificationId: Int)
}

class NotificationCell: ConfigurableTableViewCell, Contextable {
  static let identifier = "NotificationCell"
  
  private let cardView = CardViewV2()
  private let messageLabel = UILabel(typography: .bodyRegular)
  private let timeDeltaLabel = UILabel(typography: .footnote)
  internal var context: Context?
  
  override func commonInit() {
    super.commonInit()
    
    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }
    
    cardView.addSubview(messageLabel) {
      $0.top.equalToSuperview().inset(Style.Padding.p32)
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
    }
    
    cardView.addSubview(timeDeltaLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalTo(messageLabel.snp.bottom).offset(Style.Padding.p32)
      $0.bottom.equalToSuperview().inset(Style.Padding.p32)
    }
  }
  
  func configure(context: CellContext) {
    guard let context = context as? NotificationCellContext else { return }
    messageLabel.text = context.message
    timeDeltaLabel.text = context.timeDelta
    cardView.backgroundColor = context.backgroundColor
    self.context = context.context
  }
}
