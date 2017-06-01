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

import Foundation
import UIKit
import SnapKit

class StatisticsViewController: UIViewController {
  var event: Event?
  var imgMapView: UIImageView = UIImageView()
  var lblMissingStats: UILabel = UILabel()
  var btnCreateTeam: UIButton = UIButton(type: .system)
  var lblJoinTeam: UILabel = UILabel()

  convenience init(event: Event) {
    self.init(nibName: nil, bundle: nil)
    self.event = event
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureMap(&top)
    configureCreation(&top)
  }

  private func configureMap(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(imgMapView)
    imgMapView.layer.backgroundColor = Style.Colors.grey.cgColor
    imgMapView.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
      make.height.equalToSuperview().dividedBy(2)
    }
    top = imgMapView.snp.bottom
  }

  private func configureCreation(_ top: inout ConstraintRelatableTarget) {
    lblMissingStats.text = Strings.EventStatistics.missingStats
    lblMissingStats.numberOfLines = -1
    lblMissingStats.textAlignment = .justified
    view.addSubview(lblMissingStats)
    lblMissingStats.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblMissingStats.snp.bottom

    btnCreateTeam.setTitle(Strings.Event.createTeam, for: .normal)
    btnCreateTeam.setTitleColor(Style.Colors.green, for: .normal)
    btnCreateTeam.layer.borderColor = Style.Colors.green.cgColor
    btnCreateTeam.layer.borderWidth = 1.0
    btnCreateTeam.layer.cornerRadius = 4.0
    btnCreateTeam.contentEdgeInsets =
        UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
    view.addSubview(btnCreateTeam)
    btnCreateTeam.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
    top = btnCreateTeam.snp.bottom

    lblJoinTeam.text = Strings.EventStatistics.joinTeam
    lblJoinTeam.numberOfLines = -1
    lblJoinTeam.textAlignment = .justified
    view.addSubview(lblJoinTeam)
    lblJoinTeam.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblJoinTeam.snp.bottom
  }
}
