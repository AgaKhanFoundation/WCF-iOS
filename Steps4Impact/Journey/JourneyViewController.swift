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

class JourneyViewController: TableViewController {

  let topProgressView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.alpha = 1
    view.layer.applySketchShadow(color: Style.Colors.FoundationGrey, alpha: 1, x: 0, y: -5, blur: 8, spread: 0)
    return view
  }()

  let progressLabel: UILabel = {
    let label = UILabel(typography: .smallRegular)
    label.textAlignment = .center
    label.numberOfLines = 2
    label.textColor = Style.Colors.FoundationGreen
    return label
  }()

  override func commonInit() {
    super.commonInit()
    dataSource = JourneyDataSource()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.Journey.title
    navigationController?.navigationBar.prefersLargeTitles = false
    view.backgroundColor = .white
    tableView.backgroundColor = .white
    tableView.contentInset = UIEdgeInsets(top: Style.Size.s64 + Style.Padding.p12, left: 0, bottom: 0, right: 0)

    topProgressView.addSubview(progressLabel) {
      $0.top.equalToSuperview().offset(Style.Padding.p8)
      $0.leading.equalToSuperview().offset(Style.Padding.p24)
      $0.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.bottom.equalToSuperview().inset(Style.Padding.p8)
    }
    view.addSubview(topProgressView) {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(Style.Size.s64)
    }
  }

  override func reload() {
    dataSource?.reload { [weak self] in
      if let dataSource = self?.dataSource as? JourneyDataSource {
        let nextMilestoneDistance = dataSource.distanceToNextMilestone
        let distanceRemaining = nextMilestoneDistance - dataSource.distanceCoveredToNextMilestone
        let nextMilestone = dataSource.nameOfNextMilestone
        let progressLabelText = "\(distanceRemaining) / \(nextMilestoneDistance) mi remaining to reach \(nextMilestone)"
        self?.progressLabel.text = progressLabelText
      }
      self?.tableView.reloadOnMain()
    }
  }
}
