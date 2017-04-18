/**
 * Copyright © 2017 Aga Khan Foundation
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

struct Style {
  struct Colors {
    // Primary
    static let green = #colorLiteral(red: 0.0000000000, green: 0.6941176470, blue: 0.2509803921, alpha: 1)      // #00b140
    static let black = #colorLiteral(red: 0.0000000000, green: 0.0000000000, blue: 0.0000000000, alpha: 1)      // #000000
    static let white = #colorLiteral(red: 1.0000000000, green: 1.0000000000, blue: 1.0000000000, alpha: 1)      // #ffffff
    static let grey = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3568627450, alpha: 1)       // #58585b

    // Secondary
    static let gold = #colorLiteral(red: 0.7333333333, green: 0.6196078431, blue: 0.1843137254, alpha: 1)       // #bb9e2f
    static let yellow = #colorLiteral(red: 1.0000000000, green: 0.7843137254, blue: 0.2705882352, alpha: 1)     // #ffc845
    static let lightGreen = #colorLiteral(red: 0.5843137254, green: 0.7568627450, blue: 0.1215686274, alpha: 1) // #95c11f
    static let darkGreen = #colorLiteral(red: 0.0156862745, green: 0.4156862745, blue: 0.2196078431, alpha: 1)  // #045a38
  }

  struct Size {
    static let s16: CGFloat = 16
    static let s32: CGFloat = 32
    static let s40: CGFloat = 40
    static let s48: CGFloat = 48
    static let s56: CGFloat = 56
    static let s128: CGFloat = 128
  }

  struct Padding {
    static let p8: CGFloat = 8
    static let p12: CGFloat = 12
    static let p16: CGFloat = 16
    static let p24: CGFloat = 24
    static let p32: CGFloat = 32
    static let p40: CGFloat = 40
    static let p48: CGFloat = 48
    static let p64: CGFloat = 64
  }

  // TODO: Update this based on style guide from UX/UI person
  enum Typography {
    case header
    case title
    case body
    case button
    case section
    case caption

    var font: UIFont? {
      switch self {
      case .header: return UIFont.preferredFont(forTextStyle: .headline)
      case .title: return UIFont.preferredFont(forTextStyle: .subheadline)
      case .body: return UIFont.preferredFont(forTextStyle: .body)
      case .button: return UIFont.preferredFont(forTextStyle: .callout)
      case .section: return UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
      case .caption: return UIFont.preferredFont(forTextStyle: .caption1)
      }
    }
  }
}

extension UILabel {
  convenience init(_ typography: Style.Typography) {
    self.init()
    font = typography.font
    if (typography == .section) {
      textColor = Style.Colors.grey
    } else {
      textColor = Style.Colors.black
    }
    numberOfLines = 0
  }
}

extension UITextField {
  convenience init(_ typography: Style.Typography) {
    self.init()
    font = typography.font
    textColor = Style.Colors.black
  }
}

