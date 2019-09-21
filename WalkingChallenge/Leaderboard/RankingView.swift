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

class RankingView: UIView {
  private var compactRegularConstraints = [NSLayoutConstraint]()
  private var compactCompactConstraints = [NSLayoutConstraint]()
  private var regularCompactConstraints = [NSLayoutConstraint]()
  private var regularRegularConstraints = [NSLayoutConstraint]()
  private var sharedConstraints = [NSLayoutConstraint]()
  private let padding = Style.Padding.self
  private let size = Style.Size.self
  let circularView: CircularView = {
    let view = CircularView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  let teamLbl: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.text = Strings.Leaderboard.blank
    lbl.numberOfLines = 2
    lbl.textAlignment = .center
    return lbl
  }()
  let milesLbl: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.text = Strings.Leaderboard.blank
    lbl.textColor = .lightGray
    lbl.textAlignment = .center
    return lbl
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    setupViews()
    setupConstraints()
  }
  func setupViews() {
    addSubview(circularView)
    addSubview(teamLbl)
    addSubview(milesLbl)
  }
  func setupConstraints() {
    sharedConstraints.append(contentsOf: [
      circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
      circularView.topAnchor.constraint(equalTo: topAnchor),
      teamLbl.topAnchor.constraint(equalTo: circularView.bottomAnchor, constant: padding.p2),
      teamLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.p4),
      teamLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.p4),
      milesLbl.topAnchor.constraint(equalTo: teamLbl.bottomAnchor, constant: padding.p2),
      milesLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.p4),
      milesLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.p4)
    ])
    compactRegularConstraints.append(contentsOf: [
      circularView.heightAnchor.constraint(equalToConstant: size.s64),
      circularView.widthAnchor.constraint(equalToConstant: size.s64)
    ])
    regularCompactConstraints.append(contentsOf: [
      circularView.heightAnchor.constraint(equalToConstant: size.s64),
      circularView.widthAnchor.constraint(equalToConstant: size.s64)
    ])
    compactCompactConstraints.append(contentsOf: [
      circularView.heightAnchor.constraint(equalToConstant: size.s64),
      circularView.widthAnchor.constraint(equalToConstant: size.s64)
    ])
    regularRegularConstraints.append(contentsOf: [
      circularView.heightAnchor.constraint(equalToConstant: size.s64),
      circularView.widthAnchor.constraint(equalToConstant: size.s64)
    ])
    setAllConstraints()
    setFonts()
  }
  func setFonts() {
    if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
      circularView.placeLbl.font = Style.Font.title
      circularView.layer.cornerRadius = size.s32
      teamLbl.font = Style.Font.largeLabelThin
      milesLbl.font = Style.Font.smallLabel
    } else if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact {
      circularView.placeLbl.font = Style.Font.title
      circularView.layer.cornerRadius = size.s32
      teamLbl.font = Style.Font.largeLabelThin
      milesLbl.font = Style.Font.smallLabel
    } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {
      circularView.placeLbl.font = Style.Font.title
      circularView.layer.cornerRadius = size.s32
      teamLbl.font = Style.Font.largeLabelThin
      milesLbl.font = Style.Font.smallLabel
    } else {
      circularView.placeLbl.font = UIFont.systemFont(ofSize: 46, weight: .bold)
      circularView.layer.cornerRadius = size.s48
      teamLbl.font = Style.Font.placeholderThin
      milesLbl.font = Style.Font.largeLabel
    }
  }
  func setAllConstraints() {
    activateConstraints(constraints: sharedConstraints)
    switch(traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
    case(.compact, .regular):
      setConstraints(active: compactRegularConstraints,
                     deactive: [compactCompactConstraints,
                                regularCompactConstraints,
                                regularRegularConstraints])
    case(.compact, .compact):
      setConstraints(active: compactCompactConstraints,
                     deactive: [compactRegularConstraints,
                                regularCompactConstraints,
                                regularRegularConstraints])
    case(.regular, .compact):
      setConstraints(active: regularCompactConstraints,
                     deactive: [compactCompactConstraints,
                                compactRegularConstraints,
                                regularRegularConstraints])
    default:
      setConstraints(active: regularRegularConstraints,
                     deactive: [compactCompactConstraints,
                                regularCompactConstraints,
                                regularCompactConstraints])
    }
  }
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setAllConstraints()
  }
}
