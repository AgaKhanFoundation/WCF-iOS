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

protocol Keyboardable: class {
    func addKeyboardNotifications()
    func removeKeyboardNotifications()
    func keyboardChanged(notification: Foundation.Notification)
    func dismissKeyboard(forced: Bool)

    var bottomConstraint: Constraint? { get set }
}

extension Keyboardable where Self: UIViewController {
  func addKeyboardNotifications() {
      _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { self.keyboardChanged(notification: $0) } // swiftlint:disable:this line_length
      _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { self.keyboardChanged(notification: $0) } // swiftlint:disable:this line_length
  }

  func removeKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    dismissKeyboard(forced: true)
  }

  func keyboardChanged(notification: Foundation.Notification) {
      guard
          let userInfo = notification.userInfo,
          let animationCurveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
          let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
          let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      else {
          print("Keyboardable - Something went wrong with keyboard animation")
          return
      }

      let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
      let bottomOffset = keyboardFrame.origin.y - UIScreen.main.bounds.height
      bottomConstraint?.update(offset: bottomOffset)

      UIView.animate(withDuration: animationDuration, delay: 0, options: [.beginFromCurrentState, animationCurve], animations: { // swiftlint:disable:this line_length
          self.view.layoutIfNeeded()
      }, completion: nil)
  }

  func dismissKeyboard(forced: Bool) {
      view.endEditing(forced)
  }
}
