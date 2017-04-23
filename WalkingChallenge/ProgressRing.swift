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
                     startAngle: CGFloat(-Float.pi / 2),
                     endAngle: CGFloat(3 * Float.pi / 2), clockwise: true)

    fillColor = UIColor.clear.cgColor
    lineCap = kCALineCapSquare
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
        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    add(animation, forKey: "strokeEnd")

    strokeEnd = CGFloat(value)
  }
}

protocol ProgressRingSummary: CustomStringConvertible {
  var value: Float { get }
  var max: Float { get }
}

struct ProgressRingSummaryDistance: ProgressRingSummary {
  var value: Float
  var max: Float
}

extension ProgressRingSummaryDistance: CustomStringConvertible {
  var description: String {
    return "out of\n\(DataFormatters.formatDistance(value: max))"
  }
}

class ProgressRing: UIView {
  var progressTintColor: UIColor = Style.Colors.grey
  var trackTintColor: UIColor = Style.Colors.green
  var arcRadius: Float
  var arcWidth: Float = 16.0

  var summary: ProgressRingSummary? {
    didSet {
      if let summary = summary {
        lblValue.text = String(describing: summary.value)
        lblSummary.text = String(describing: summary)
        setProgress(summary.value / summary.max, animated: true)
      }
    }
  }
  var progress: Float = 0.0

  private let lblValue: UILabel = UILabel(.header)
  private let lblSummary: UILabel = UILabel(.caption)

  private var arcLayer: ProgressArcLayer?

  public init(radius: Float) {
    // FIXME(compnerd) can this be calculated from `frame.size.width / 2`?
    self.arcRadius = radius
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
      value = summary.value / summary.max
    }

    arcLayer = ProgressArcLayer(radius: arcRadius, width: arcWidth, value: value,
                                color: trackTintColor)
    layer.addSublayer(arcLayer!)

    addSubview(lblValue)
    lblValue.snp.makeConstraints { (make) in
      make.bottom.equalTo(self.snp.centerY)
      make.centerX.equalToSuperview()
    }

    addSubview(lblSummary)
    lblSummary.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.centerY)
      make.centerX.equalToSuperview()
    }
    lblSummary.textAlignment = .center

    if let summary = summary {
      lblValue.text = String(describing: summary.value)
      lblSummary.text = String(describing: summary)
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
