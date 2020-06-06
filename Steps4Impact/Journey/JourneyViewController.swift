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
    label.textColor = Style.Colors.FoundationGrey
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
        if let nextMilestone = dataSource.nameOfNextMilestone {
          let nextMilestoneDistance = dataSource.distanceToNextMilestone
          let distanceRemaining = nextMilestoneDistance - dataSource.distanceCoveredToNextMilestone
          let progressLabelText = NSMutableAttributedString()
          let boldAttribute = [
            NSAttributedString.Key.font: Style.Typography.smallBold.font as Any
          ]
          // swiftlint:disable:next line_length
          progressLabelText.append(NSAttributedString(string: "\(Int(distanceRemaining/2000))/\(Int(nextMilestoneDistance/2000)) mi", attributes: boldAttribute))
          progressLabelText.append(NSAttributedString(string: " remaining to reach\n \(nextMilestone)"))
          self?.progressLabel.attributedText = progressLabelText
        } else {
          self?.progressLabel.text = "All Milestones Completed"
        }
      }
      self?.tableView.reloadOnMain()
    }
  }
}

extension JourneyViewController {
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? MilestoneCell {
      cell.delegate = self
    }
    if let cell = cell as? CurrentMilestoneCell {
      cell.delegate = self
    }
  }
}

extension JourneyViewController: MilestoneNameButtonDelegate {
  func milestoneNameButtonTapped(sequence: Int) {
    let journeyDetailVC = JourneyDetailViewController()
    if let dataSource = dataSource as? JourneyDataSource {
      journeyDetailVC.milestone = dataSource.milestones[sequence]
      navigationController?.pushViewController(journeyDetailVC, animated: true)
    }
  }
}

