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

class TopRankingView: UIView {
  private var compactRegularConstraints = [NSLayoutConstraint]()
  private var compactCompactConstraints = [NSLayoutConstraint]()
  private var regularCompactConstraints = [NSLayoutConstraint]()
  private var regularRegularConstraints = [NSLayoutConstraint]()
  private var sharedConstraints = [NSLayoutConstraint]()
  private let padding = Style.Padding.self
  private let size = Style.Size.self
  let firstPlace: RankingView = {
    let view = RankingView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Style.Colors.white
    view.circularView.placeLbl.text = Strings.Leaderboard.firstPlace
    view.circularView.backgroundColor = Style.Colors.Gold
    return view
  }()
  let secondPlace: RankingView = {
    let view = RankingView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Style.Colors.white
    view.circularView.placeLbl.text = Strings.Leaderboard.secondPlace
    view.circularView.backgroundColor = Style.Colors.Silver
    return view
  }()
  let thirdPlace: RankingView = {
    let view = RankingView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Style.Colors.white
    view.circularView.placeLbl.text = Strings.Leaderboard.thirdPlace
    view.circularView.backgroundColor = Style.Colors.Bronze
    return view
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
    addSubview(firstPlace)
    addSubview(secondPlace)
    addSubview(thirdPlace)
  }
  func setupConstraints() {
    sharedConstraints.append(contentsOf: [
      firstPlace.centerXAnchor.constraint(equalTo: centerXAnchor),
      firstPlace.topAnchor.constraint(equalTo: topAnchor),
      secondPlace.topAnchor.constraint(equalTo: firstPlace.bottomAnchor, constant: -padding.p28),
      secondPlace.rightAnchor.constraint(equalTo: firstPlace.leftAnchor, constant: -padding.p12)
    ])
    compactRegularConstraints.append(contentsOf: [
      firstPlace.heightAnchor.constraint(equalToConstant: size.s96),
      firstPlace.widthAnchor.constraint(equalToConstant: size.s96),
      secondPlace.heightAnchor.constraint(equalToConstant: size.s96),
      secondPlace.widthAnchor.constraint(equalToConstant: size.s96),
      thirdPlace.topAnchor.constraint(equalTo: secondPlace.bottomAnchor, constant: -padding.p80),
      thirdPlace.leftAnchor.constraint(equalTo: firstPlace.rightAnchor, constant: padding.p12),
      thirdPlace.heightAnchor.constraint(equalToConstant: size.s96),
      thirdPlace.widthAnchor.constraint(equalToConstant: size.s96),
      thirdPlace.topAnchor.constraint(equalTo: secondPlace.bottomAnchor, constant: -padding.p80)
    ])
    compactCompactConstraints.append(contentsOf: [
      firstPlace.heightAnchor.constraint(equalToConstant: size.s96),
      firstPlace.widthAnchor.constraint(equalToConstant: size.s96),
      secondPlace.heightAnchor.constraint(equalToConstant: size.s96),
      secondPlace.widthAnchor.constraint(equalToConstant: size.s96),
      thirdPlace.leftAnchor.constraint(equalTo: firstPlace.rightAnchor, constant: padding.p4),
      thirdPlace.heightAnchor.constraint(equalToConstant: size.s96),
      thirdPlace.widthAnchor.constraint(equalToConstant: size.s96)
    ])
    regularCompactConstraints.append(contentsOf: [
      firstPlace.heightAnchor.constraint(equalToConstant: size.s108),
      firstPlace.widthAnchor.constraint(equalToConstant: size.s128),
      secondPlace.heightAnchor.constraint(equalToConstant: size.s108),
      secondPlace.widthAnchor.constraint(equalToConstant: size.s128),
      thirdPlace.leftAnchor.constraint(equalTo: firstPlace.rightAnchor, constant: padding.p4),
      thirdPlace.heightAnchor.constraint(equalToConstant: size.s108),
      thirdPlace.widthAnchor.constraint(equalToConstant: size.s128)
    ])
    regularRegularConstraints.append(contentsOf: [
      firstPlace.heightAnchor.constraint(equalToConstant: size.s128),
      firstPlace.widthAnchor.constraint(equalToConstant: size.s128),
      secondPlace.heightAnchor.constraint(equalToConstant: size.s128),
      secondPlace.widthAnchor.constraint(equalToConstant: size.s128),
      thirdPlace.leftAnchor.constraint(equalTo: firstPlace.rightAnchor, constant: padding.p12),
      thirdPlace.heightAnchor.constraint(equalToConstant: size.s128),
      thirdPlace.widthAnchor.constraint(equalToConstant: size.s128)
    ])
    setAllConstraints()
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
