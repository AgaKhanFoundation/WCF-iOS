//
//  JourneyViewController.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/17/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

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
