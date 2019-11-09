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

struct AlertAction {
  let title: String
  let style: Button.ButtonStyle
  let shouldDismiss: Bool
  let handler: (() -> Void)?

  init(title: String, style: Button.ButtonStyle = .primary, shouldDismiss: Bool = true, handler: (() -> Void)? = nil) {
    self.title = title
    self.style = style
    self.shouldDismiss = shouldDismiss
    self.handler = handler
  }

  static func cancel(_ handler: (() -> Void)? = nil) -> AlertAction {
    return AlertAction(title: "Cancel", style: .secondary, handler: handler)
  }

  static func delete(_ handler: (() -> Void)? = nil) -> AlertAction {
    return AlertAction(title: "Delete", style: .destructive, handler: handler)
  }

  static func okay(_ handler: (() -> Void)? = nil) -> AlertAction {
    return AlertAction(title: "Okay", style: .primary, handler: handler)
  }
}

class AlertViewController: ViewController {
  override var title: String? { didSet { titleLabel.text = title }}
  var body: String? { didSet { bodyLabel.text = body }}
  var dismissBlock: (() -> Void)?
  var isDismissable: Bool = true

  // Views
  private let containerView = UIView()
  private let dismissView = UIView()
  private let titleLabel = UILabel(typography: .title)
  private let bodyLabel = UILabel(typography: .bodyRegular)
  public let contentView = UIView()
  private let labelsStackView = UIStackView()
  private let buttonsStackView = UIStackView()

  // Keyboardable
  var bottomConstraint: Constraint?

  // MARK: - Lifecycle

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    addKeyboardNotifications()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    removeKeyboardNotifications()
  }

  override func configureView() {
    super.configureView()
    view.backgroundColor = nil
    containerView.backgroundColor = Style.Colors.white
    containerView.layer.cornerRadius = 4.0
    containerView.clipsToBounds = true
    titleLabel.textAlignment = .center
    bodyLabel.textAlignment = .center
    labelsStackView.axis = .vertical
    labelsStackView.spacing = Style.Padding.p8
    buttonsStackView.axis = .vertical
    buttonsStackView.distribution = .equalSpacing
    buttonsStackView.alignment = .fill
    buttonsStackView.spacing = Style.Padding.p8
    dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewTapped(_:))))

    view.addSubview(dismissView) {
      $0.edges.equalToSuperview()
    }

    view.addSubview(containerView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.centerY.equalToSuperview().priority(.low)
      self.bottomConstraint = $0.bottom.lessThanOrEqualToSuperview().constraint
    }

    containerView.addSubview(labelsStackView) {
      $0.leading.trailing.top.equalToSuperview().inset(Style.Padding.p16)
    }

    containerView.addSubview(contentView) {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(labelsStackView.snp.bottom)
    }

    containerView.addSubview(buttonsStackView) {
      $0.leading.trailing.bottom.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalTo(contentView.snp.bottom).offset(Style.Padding.p16)
    }

    labelsStackView.addArrangedSubviews(titleLabel, bodyLabel)
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

  // MARK: - Public API

  func add(_ action: AlertAction) {
    let button = ActionButton(style: action.style)
    button.title = action.title
    button.shouldDismiss = action.shouldDismiss
    button.handler = action.handler
    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    buttonsStackView.addArrangedSubview(button)
  }

  func removeAllActions() {
    for button in buttonsStackView.arrangedSubviews {
      button.removeFromSuperview()
    }
  }
}

extension AlertViewController: Keyboardable {}
