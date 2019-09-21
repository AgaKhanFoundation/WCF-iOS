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

class LeaderboardCell: UITableViewCell {
  private var compactRegularConstraints = [NSLayoutConstraint]()
  private var compactCompactConstraints = [NSLayoutConstraint]()
  private var regularCompactConstraints = [NSLayoutConstraint]()
  private var regularRegularConstraints = [NSLayoutConstraint]()
  private var sharedConstraints = [NSLayoutConstraint]()
  let rankLbl: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .left
    lbl.numberOfLines = 0
    return lbl
  }()
  let teamLbl: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .left
    lbl.contentMode = .left
    lbl.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
    lbl.numberOfLines = 0
    return lbl
  }()
  let milesLbl: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.textAlignment = .right
    lbl.numberOfLines = 0
    return lbl
  }()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    setupViews()
    setupConstraints()
  }
  override func updateConstraints() {
    super.updateConstraints()
    layoutIfNeeded()
  }
  func setupViews() {
    addSubview(rankLbl)
    addSubview(teamLbl)
    addSubview(milesLbl)
  }
  func setupConstraints() {
    var rankLeadingAnchor = rankLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
    var mileTrailAnchor = milesLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
    if #available(iOS 11.0, *) {
      rankLeadingAnchor = rankLbl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
      mileTrailAnchor = milesLbl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
    }
    sharedConstraints.append(contentsOf: [
      rankLeadingAnchor,
      rankLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
      rankLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
      teamLbl.leadingAnchor.constraint(equalTo: rankLbl.trailingAnchor, constant: 16),
      teamLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
      teamLbl.trailingAnchor.constraint(equalTo: milesLbl.leadingAnchor, constant: -16),
      mileTrailAnchor,
      milesLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
      milesLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
      ])
    setAllConstraints()
    setFonts()
  }
  func setFonts() {
    if traitCollection.verticalSizeClass == .regular {
      rankLbl.font = UIFont.systemFont(ofSize: 21)
      teamLbl.font = UIFont.systemFont(ofSize: 21)
      milesLbl.font = UIFont.systemFont(ofSize: 21)
    } else {
      rankLbl.font = UIFont.systemFont(ofSize: 19)
      teamLbl.font = UIFont.systemFont(ofSize: 19)
      milesLbl.font = UIFont.systemFont(ofSize: 19)
    }
  }
  func setAllConstraints() {
    if sharedConstraints.count > 0 && !sharedConstraints[0].isActive {
      NSLayoutConstraint.activate(sharedConstraints)
    }
  }
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setAllConstraints()
  }
}
extension UIViewController {
  func deactivateConstraints(constraints: [NSLayoutConstraint]) {
    if constraints.count > 0 && constraints[0].isActive {
      NSLayoutConstraint.deactivate(constraints)
    }
  }
  func activateConstraints(constraints: [NSLayoutConstraint]) {
    if constraints.count > 0 && constraints[0].isActive == false {
      NSLayoutConstraint.activate(constraints)
    }
  }
  func setConstraints(active: [NSLayoutConstraint], deactive: [[NSLayoutConstraint]]) {
    activateConstraints(constraints: active)
    for constraints in deactive {
      deactivateConstraints(constraints: constraints)
    }
  }
}
extension UIView {
  func deactivateConstraints(constraints: [NSLayoutConstraint]) {
    if constraints.count > 0 && constraints[0].isActive {
      NSLayoutConstraint.deactivate(constraints)
    }
  }
  func activateConstraints(constraints: [NSLayoutConstraint]) {
    if constraints.count > 0 && constraints[0].isActive == false {
      NSLayoutConstraint.activate(constraints)
    }
  }
  func setConstraints(active: [NSLayoutConstraint], deactive: [[NSLayoutConstraint]]) {
    activateConstraints(constraints: active)
    for constraints in deactive {
      deactivateConstraints(constraints: constraints)
    }
  }
}
