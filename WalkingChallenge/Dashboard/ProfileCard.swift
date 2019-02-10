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
import Foundation

class ProfileCardView: StylizedCardView {
  private var btnGear: UIButton = UIButton(frame: .zero)
  private var imgImage: UIImageView = UIImageView(frame: .zero)
  private var lblName: UILabel = UILabel(frame: .zero)
  private var lblChallenge: UILabel = UILabel(frame: .zero)
  private var lblTeamLabel: UILabel = UILabel(frame: .zero)
  private var lblTeam: UILabel = UILabel(frame: .zero)
  private var eltSeparator: UIView = UIView(frame: .zero)
  private var lblChallengeTimelineLabel: UILabel = UILabel(frame: .zero)
  private var lblChallengeTimeline: UILabel = UILabel(frame: .zero)

  func layout() {
    addSubviews([btnGear, imgImage, lblName, lblChallenge, lblTeamLabel,
                 lblTeam, eltSeparator, lblChallengeTimelineLabel,
                 lblChallengeTimeline])

    guard let gear = UIImage(named: Strings.Assets.gear) else {
      fatalError("missing asset \(Strings.Assets.gear)")
    }
    btnGear.frame =
        CGRect(x: 0, y: 0, width: gear.size.width, height: gear.size.height)
    btnGear.setBackgroundImage(gear, for: .normal)
    btnGear.snp.makeConstraints {
      $0.right.equalToSuperview().inset(Style.Padding.p8)
      $0.top.equalToSuperview().offset(Style.Padding.p8)
    }

    // TODO(compnerd) figure out the correct size for the image
    let szImageSize: CGFloat = Style.Size.s96
    imgImage.layer.cornerRadius = szImageSize / 2.0
    imgImage.layer.masksToBounds = true
    imgImage.snp.makeConstraints {
      $0.top.equalTo(btnGear.snp.bottom).offset(Style.Padding.p16)
      $0.left.equalToSuperview().offset(Style.Padding.p16)
      $0.height.width.equalTo(szImageSize)
      $0.centerY.equalToSuperview()
    }

    layoutPersonalDetails()

    eltSeparator.backgroundColor = .gray
    eltSeparator.snp.makeConstraints {
      $0.top.equalTo(lblTeam.snp.bottom).offset(Style.Padding.p8)
      $0.left.equalTo(lblTeamLabel.snp.left)
      $0.right.equalTo(lblTeam.snp.right)
      $0.height.equalTo(1.0)
    }

    layoutChallengeDetails()
  }

  private func layoutPersonalDetails() {
    lblName.snp.makeConstraints {
      $0.top.equalTo(imgImage.snp.top)
      $0.left.equalTo(imgImage.snp.right).offset(Style.Padding.p16)
      $0.right.equalToSuperview().inset(Style.Padding.p16)
    }

    lblChallenge.snp.makeConstraints {
      $0.top.equalTo(lblName.snp.bottom).offset(Style.Padding.p2)
      $0.left.equalTo(lblName.snp.left)
      $0.right.equalTo(lblName.snp.right)
    }

    lblTeamLabel.text = Strings.ProfileCard.team
    lblTeamLabel.snp.makeConstraints {
      $0.top.equalTo(lblChallenge.snp.bottom).offset(Style.Padding.p2)
      $0.left.equalTo(lblChallenge.snp.left)
    }

    lblTeam.snp.makeConstraints {
      $0.top.equalTo(lblChallenge.snp.bottom).offset(Style.Padding.p2)
      $0.left.equalTo(lblTeamLabel.snp.right).offset(Style.Padding.p2)
      $0.right.equalTo(lblChallenge.snp.right)
    }
  }

  private func layoutChallengeDetails() {
    lblChallengeTimelineLabel.text = Strings.ProfileCard.challengeTimeline
    lblChallengeTimelineLabel.snp.makeConstraints {
      $0.top.equalTo(eltSeparator.snp.bottom).offset(Style.Padding.p8)
      $0.left.equalTo(lblTeamLabel.snp.left)
      $0.right.equalTo(lblTeam.snp.right)
    }

    lblChallengeTimeline.snp.makeConstraints {
      $0.top.equalTo(lblChallengeTimelineLabel.snp.bottom)
        .offset(Style.Padding.p2)
      $0.left.equalTo(lblChallengeTimelineLabel.snp.left)
      $0.right.equalTo(lblChallengeTimelineLabel.snp.right)
    }
  }
}

extension ProfileCardView: CardView {
  static let identifier: String = "ProfileCard"

  func render(_ context: Any) {
    guard let data = context as? ProfileCard else { return }

    onBackground {
      Facebook.profileImage(for: data.fbid) { (url) in
        guard let url = url else { return }
        if let data = try? Data(contentsOf: url) {
          onMain { self.imgImage.image = UIImage(data: data) }
        }
      }
    }

    onBackground {
      Facebook.getRealName(for: data.fbid) { (name) in
        onMain { self.lblName.text = name }
      }
    }

    lblChallenge.text = data.event
    lblTeam.text = data.team
    lblChallengeTimeline.text = data.timeline
  }
}

struct ProfileCard: Card {
  let renderer: String = ProfileCardView.identifier

  // TODO(compnerd) provide a constructor to populate this
  let fbid: String = "me"
  let event: String = "AKF Spring 2019"
  let team: String = "Global Walkers"
  let timeline: String = "Jan 14 - May 12"
}
