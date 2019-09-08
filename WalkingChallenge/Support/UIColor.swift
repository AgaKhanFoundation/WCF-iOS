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

extension UIColor {
  /**
   Returns a new color which is the average of 2 of the colors.
   scale can be a number between 0 to 1 otherwise the start or end color is returned respectively
   */
  static func averageColor(start: UIColor, end: UIColor, scale: CGFloat = 0.5) -> UIColor {
    
    guard scale > 0 else { return start }
    guard scale < 1 else { return end }
    
    guard
      let sComp = start.componentsRGBA,
      let eComp = end.componentsRGBA
      else { return start }
    
    let red = CGFloat.scaledAverage(x: sComp.red, y: eComp.red, scale: scale)
    let green = CGFloat.scaledAverage(x: sComp.green, y: eComp.green, scale: scale)
    let blue = CGFloat.scaledAverage(x: sComp.blue, y: eComp.blue, scale: scale)
    let alpha = CGFloat.scaledAverage(x: sComp.alpha, y: eComp.alpha, scale: scale)
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  func average(with other: UIColor, scale: CGFloat = 0.5) -> UIColor {
    return .averageColor(start: self, end: other, scale: scale)
  }
  
  // swiftlint:disable large_tuple
  var componentsRGBA: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
    
    var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
    
    guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
    
    return (red, green, blue, alpha)
  }
  
  /**
   Init a color with a hex value
   Format: 0xXXXXXX
   */
  convenience init(hex: Int) {
    self.init(red: CGFloat( (hex & 0xFF0000) >> 16 ) / 255.0,
              green: CGFloat( (hex & 0x00FF00) >> 8 ) / 255.0,
              blue: CGFloat( (hex & 0x0000FF) >> 0 ) / 255.0,
              alpha: 1)
  }
}
