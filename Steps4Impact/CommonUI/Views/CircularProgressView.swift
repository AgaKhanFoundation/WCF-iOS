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

class CircularProgressView: View {
  var progress: CGFloat = 0.0
  private let foregroundLayer = CAShapeLayer()
  private let backgroundLayer = CAShapeLayer()
  private var pathCenter: CGPoint { return convert(center, from: superview) }
  private var radius: CGFloat { return (frame.width - lineWidth) / 2 }
  private var lineWidth: CGFloat = 20

  override func commonInit() {
    super.commonInit()
  }

  override func layoutSublayers(of layer: CALayer) {
    redraw()
  }

  func redraw() {
    layer.sublayers = nil
    drawBackgroundLayer()
    drawForegroundLayer()
  }

  private func drawBackgroundLayer() {
    let path = UIBezierPath(arcCenter: pathCenter,
                            radius: radius,
                            startAngle: 0,
                            endAngle: .pi * 2,
                            clockwise: true)
    backgroundLayer.path = path.cgPath
    backgroundLayer.strokeColor = Style.Colors.grey.cgColor
    backgroundLayer.lineWidth = lineWidth
    backgroundLayer.fillColor = UIColor.clear.cgColor
    layer.addSublayer(backgroundLayer)
  }

  private func drawForegroundLayer() {
    let path = UIBezierPath(arcCenter: pathCenter,
                            radius: radius,
                            startAngle: -.pi / 2,
                            endAngle: (-.pi / 2) + (2 * .pi) * progress,
                            clockwise: true)
    foregroundLayer.path = path.cgPath
    foregroundLayer.strokeColor = Style.Colors.FoundationGreen.cgColor
    foregroundLayer.lineWidth = lineWidth
    foregroundLayer.fillColor = UIColor.clear.cgColor
    foregroundLayer.lineCap = .round
    layer.addSublayer(foregroundLayer)
  }
}
