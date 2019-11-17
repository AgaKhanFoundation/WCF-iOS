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

class JourneyDetailViewController: ViewController {

  override var title: String? { didSet { titleLabel.text = title }}
  var body: String? { didSet { bodyText.text = body }}
  var dismissBlock: (() -> Void)?
  var isDismissable: Bool = true

  // Views
  private let containerView = UIView()
  private let dismissView = UIView()
  private let detailImage = UIImageView()
  private let titleLabel = UILabel(typography: .headerTitle)
  private let subtitleLabel = UILabel(typography: .title)
  private let bodyText = UITextView()

  // Keyboardable
  var bottomConstraint: Constraint?
  var bottomConstraintOffset: CGFloat? = Style.Padding.p16

  override func configureView() {
    super.configureView()
    view.backgroundColor = nil
    containerView.backgroundColor = Style.Colors.white
    containerView.layer.cornerRadius = 4.0
    containerView.clipsToBounds = true
    bodyText.isScrollEnabled = true
    detailImage.image = UIImage(named: "journey")
    bodyText.font = Style.Typography.bodyRegular.font
    bodyText.textColor = UIColor.black
    bodyText.backgroundColor = UIColor.white

    titleLabel.text = "Nairobi, Kenya"
    subtitleLabel.text = "Aga Khan Garden | May 2019"
    bodyText.text = "Viola is a Grade 9 student at Joy Primary School in Mathare, a notoriously poor neighborhood in Nairobi, Kenya. There, few families have books. Even schools lack suitable reading material. Across Kenya, only 2 percent of public schools have libraries. Before, Viola and her friends had very few chances to practice reading. The whole school had just a box of a few textbooks. When Viola first arrived several years ago, she was far behind her peers, with no way to catch up. was not good at reading,she admits. That changed when Joy School gained a library, thanks to a Kenyan nonprofit that raised funds for libraries with its Start-A-Library campaign, supported by the Aga Khan Foundation and the Yetu Initiative. The new library at Joy brought in 1,000 storybooks, and Viola started devouring them. Viola is a Grade 9 student at Joy Primary School in Mathare, a notoriously poor neighborhood in Nairobi, Kenya. There, few families have books. Even schools lack suitable reading material. Across Kenya, only 2 percent of public schools have libraries. Before, Viola and her friends had very few chances to practice reading. The whole school had just a box of a few textbooks. When Viola first arrived several years ago, she was far behind her peers, with no way to catch up. was not good at reading,she admits. That changed when Joy School gained a library, thanks to a Kenyan nonprofit that raised funds for libraries with its Start-A-Library campaign, supported by the Aga Khan Foundation and the Yetu Initiative. The new library at Joy brought in 1,000 storybooks, and Viola started devouring them." // swiftlint:disable:this line_length

    dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewTapped(_:))))

    view.addSubview(dismissView) {
      $0.edges.equalToSuperview()
    }

    view.addSubview(containerView) {
      $0.edges.equalToSuperview()
      $0.centerY.equalToSuperview().priority(.low)
      self.bottomConstraint = $0.bottom.lessThanOrEqualToSuperview().constraint
    }

    containerView.addSubview(detailImage) {
      $0.leading.trailing.top.equalToSuperview().inset(Style.Padding.p64)
      $0.height.equalTo(containerView).dividedBy(3)
    }

    containerView.addSubview(titleLabel) {
      $0.leading.trailing.equalToSuperview().offset(Style.Padding.p12)
      $0.top.equalTo(detailImage.snp.bottom).offset(Style.Padding.p8)
    }
    
    containerView.addSubview(subtitleLabel) {
      $0.leading.trailing.equalToSuperview().offset(Style.Padding.p12)
      $0.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p8)
    }

    containerView.addSubview(bodyText) {
      $0.leading.trailing.bottom.equalToSuperview().inset(Style.Padding.p8)
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(Style.Padding.p8)
    }

  }

  // MARK: - Actions

  @objc
  func dismissViewTapped(_ gesture: UITapGestureRecognizer) {
    guard isDismissable, gesture.state == .ended else { return }
    dismiss(animated: true, completion: dismissBlock)
  }
  
  @objc
  func buttonTapped(_ sender: ActionButton) {
    if sender.shouldDismiss {
      dismiss(animated: true, completion: sender.handler)
    } else {
      sender.handler?()
    }
  }
  
}

extension JourneyDetailViewController: Keyboardable {}


