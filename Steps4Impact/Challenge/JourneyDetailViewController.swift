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
    let htmlText = "<p>Dr. Zainab Samad was only 13 years old when she knew she wanted to become a doctor. She was able to fulfill her dream by attending medical school at the Aga Khan University. Growing up, she didn’t see many female leaders in her field and despite her passion for medicine, the idea of playing a leading role at a university was a leap beyond her imagination. Nevertheless, after years of studying at AKU and abroad, Dr. Samad eventually returned to Karachi to lead the Medicine Department at AKU. She’s the youngest person ever to hold that position, and the first woman.</p><p>Zainab’s journey to new heights was long, but she hopes that it will inspire other women to follow in her footsteps. “AKU has had female chairs in other departments, including Obstetrics-Gynecology and Anesthesia,” she said. \"I hope it means we’ll have more.\"</p><p>Aga Khan University became the leading healthcare institution in Pakistan and influences healthcare practice and policy across the country. AKU Hospital will continue to develop skills of healthcare professionals like Zainab to deliver world-class care.</p><br><br>Read Zainab’s story here:<br><a href=\"https://www.akfusa.org/our-stories/reaching-new-heights-in-national-healthcare/\" target=\"_blank\">https://www.akfusa.org/our-stories/reaching-new-heights-in-national-healthcare/</a>." // swiftlint:disable:this line_length

    bodyText.text = htmlText.htmlToAttributedString?.string
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

extension String {
  var htmlToAttributedString: NSAttributedString? {
    guard let data = data(using: .utf8) else { return NSAttributedString() }
    do {
      return try NSAttributedString(data: data,
                                    options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], // swiftlint:disable:this line_length
                                    documentAttributes: nil)
    } catch {
      return NSAttributedString()
    }
  }
  var htmlToString: String {
    return htmlToAttributedString?.string ?? ""
  }
}
