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
  static let defaultIconSize: CGFloat = 24
  
  struct Colors {
    // Standard
    static let black = UIColor(named: "black")!
    static let blue = UIColor(named: "blue")!
    static let green = UIColor(named: "green")!
    static let grey = UIColor(named: "grey")!
    static let red = UIColor(named: "red")!
    static let white = UIColor(named: "white")!

    // New Colours
    static let FoundationGreen = UIColor(named: "FoundationGreen")!
    static let RubineRed = UIColor(named: "RubineRed")!
    static let DeepTurquoise = UIColor(named: "DeepTurquoise")!
    static let EarthyGold = UIColor(named: "EarthyGold")!
    static let SpringGreen = UIColor(named: "SpringGreen")!
    static let VerdantGreen = UIColor(named: "VerdantGreen")!
    
    // UI
    static let FoundationGrey = UIColor(named: "FoundationGrey")!
    static let Silver = UIColor(named: "Silver")!
    static let Background = UIColor(named: "Background")!
    static let Shadow = UIColor(named: "Shadow")!
    static let Seperator = UIColor(named: "Seperator")!
    static let Destructive = UIColor(named: "Destructive")!
  }

  enum Typography {
    case headerTitle
    case title
    case subtitleRegular
    case subtitleBold
    case bodyRegular
    case bodyBold
    case smallRegular
    case smallRegularBlue
    case smallBold
    case footnote

    case onboarding

    var font: UIFont? {
      switch self {
      case .headerTitle:
        return UIFont.boldSystemFont(ofSize: 32)
      case .title:
        return UIFont.boldSystemFont(ofSize: 20)
      case .subtitleRegular:
        return UIFont.systemFont(ofSize: 16)
      case .subtitleBold:
        return UIFont.systemFont(ofSize: 16, weight: .bold)
      case .bodyRegular:
        return UIFont.systemFont(ofSize: 16)
      case .bodyBold:
        return UIFont.systemFont(ofSize: 16, weight: .bold)
      case .smallRegular:
        return UIFont.systemFont(ofSize: 14)
      case .smallRegularBlue:
        return UIFont.systemFont(ofSize: 14)
      case .smallBold:
        return UIFont.systemFont(ofSize: 14, weight: .bold)
      case .footnote:
        return UIFont.systemFont(ofSize: 12)
      case .onboarding:
        return UIFont.systemFont(ofSize: 24, weight: .bold)
      }
    }
  }

  struct Size {
    static let s8: CGFloat = 8                                                  // swiftlint:disable:this identifier_name line_length
    static let s16: CGFloat = 16
    static let s24: CGFloat = 24
    static let s32: CGFloat = 32
    static let s40: CGFloat = 40
    static let s48: CGFloat = 48
    static let s56: CGFloat = 56
    static let s64: CGFloat = 64
    static let s96: CGFloat = 96
    static let s128: CGFloat = 128
  }

  struct Padding {
    static let p2: CGFloat = 2                                                  // swiftlint:disable:this identifier_name line_length
    static let p4: CGFloat = 4                                                  // swiftlint:disable:this identifier_name line_length
    static let p8: CGFloat = 8                                                  // swiftlint:disable:this identifier_name line_length
    static let p12: CGFloat = 12
    static let p16: CGFloat = 16
    static let p24: CGFloat = 24
    static let p32: CGFloat = 32
    static let p40: CGFloat = 40
    static let p48: CGFloat = 48
    static let p64: CGFloat = 64
  }
}

extension UILabel {
  convenience init(typography: Style.Typography, color: UIColor? = nil) {
    self.init()
    self.font = typography.font
    switch typography {
    case .smallRegularBlue:
      self.textColor = Style.Colors.blue
    case .footnote:
      self.textColor = Style.Colors.red
    case .onboarding:
      self.textColor = Style.Colors.green
    default:
      self.textColor = Style.Colors.black
    }
    if let color = color {
      self.textColor = color
    }
    numberOfLines = 0
  }
}

extension UITextField {
  convenience init(_ typography: Style.Typography, color: UIColor? = nil) {
    self.init()
    font = typography.font
    textColor = Style.Colors.black
    if let color = color {
      textColor = color
    }
  }
}

extension CALayer {
  func addShadow() {
    self.shadowColor = Style.Colors.white.cgColor
    self.shadowOffset = .zero
    self.shadowOpacity = 0.5
    self.shadowRadius = Style.Size.s8
  }
}
