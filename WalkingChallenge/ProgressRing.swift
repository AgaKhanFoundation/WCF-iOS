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
import QuartzCore

class ProgressArcLayer: CAShapeLayer {
  private let radius: Float
  private let width: Float
  private let value: Float
  private let color: UIColor

  init(radius: Float, width: Float, value: Float, color: UIColor) {
    self.radius = radius
    self.width = width
    self.value = value
    self.color = color
    super.init()
    initialise()
  }

  public func initialise() {
    let curve: UIBezierPath =
        UIBezierPath(arcCenter: CGPoint(x: CGFloat(radius), y: CGFloat(radius)),
                     radius: CGFloat(radius - width / 2),
                     startAngle: -CGFloat.pi / 2,
                     endAngle: 3 * CGFloat.pi / 2, clockwise: true)

    fillColor = UIColor.clear.cgColor
    lineCap = CAShapeLayerLineCap.square
    lineWidth = CGFloat(width)
    path = curve.cgPath
    strokeColor = color.cgColor
    strokeStart = 0.0
    strokeEnd = CGFloat(value)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  fileprivate func animateTo(_ value: Float) {
    strokeEnd = 0.0

    let animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = strokeEnd
    animation.toValue = value
    animation.duration = CFTimeInterval(3.6)
    animation.timingFunction =
      CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    add(animation, forKey: "strokeEnd")

    strokeEnd = CGFloat(value)
  }
}

protocol ProgressRingSummary {
  var value: Int { get }
  var max: Int { get }
  var units: String { get }
}

struct ProgressRingSummaryDistance: ProgressRingSummary {
  var value: Int
  var max: Int
  var units: String
}

class ProgressRing: UIView {
  var progressTintColor: UIColor = #colorLiteral(red: 0.9019607843, green: 0.8980392156, blue: 0.8980392156, alpha: 1) // #e6e5e5
  var trackTintColor: UIColor = Style.Colors.green
  var arcRadius: Float
  var arcWidth: Float

  var summary: ProgressRingSummary? {
    didSet {
      if let summary = summary {
        lblValue.text = "\(summary.value)/\(summary.max)"
        lblUnits.text = summary.units
        setProgress(Float(summary.value) / Float(summary.max), animated: true)
      }
    }
  }
  var progress: Float = 0.0

  private let lblValue: UILabel = UILabel(typography: .body)
  private let lblUnits: UILabel = UILabel(typography: .body)

  private var arcLayer: ProgressArcLayer?

  public init(radius: Float, width: Float) {
    // FIXME(compnerd) can this be calculated from `frame.size.width / 2`?
    self.arcRadius = radius
    self.arcWidth = width
    super.init(frame: CGRect.zero)
    self.initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    let arcBaseLayer: ProgressArcLayer =
        ProgressArcLayer(radius: arcRadius, width: arcWidth, value: 1.0,
                         color: progressTintColor)
    layer.addSublayer(arcBaseLayer)

    var value: Float = progress
    if let summary = summary {
      value = Float(summary.value) / Float(summary.max)
    }

    arcLayer = ProgressArcLayer(radius: arcRadius, width: arcWidth, value: value,
                                color: trackTintColor)
    layer.addSublayer(arcLayer!)

    addSubview(lblValue)
    lblValue.snp.makeConstraints { (make) in
      make.bottom.equalTo(self.snp.centerY)
      make.centerX.equalToSuperview()
    }

    addSubview(lblUnits)
    lblUnits.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.centerY)
      make.centerX.equalToSuperview()
    }
    lblUnits.textAlignment = .center

    if let summary = summary {
      lblValue.text = String(describing: summary.value)
      lblUnits.text = String(describing: summary)
    }

    setProgress(value, animated: true)
  }

  func setProgress(_ value: Float, animated: Bool) {
    progress = value
    if animated {
      arcLayer?.animateTo(value)
    }
  }
}
