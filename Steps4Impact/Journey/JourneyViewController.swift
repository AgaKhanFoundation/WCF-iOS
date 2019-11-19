//
//  JourneyViewController.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/17/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

class JourneyViewController: TableViewController {

  let topProgressView : UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.alpha = 1
    view.layer.applySketchShadow(color: Style.Colors.FoundationGrey, alpha: 1, x: 0, y: -5, blur: 8, spread: 0)
    return view
  }()

  let progressLabel : UILabel = {
    let label = UILabel(typography: .smallRegular)
    label.translatesAutoresizingMaskIntoConstraints = false
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
    title = "Journey"
    navigationController?.navigationBar.prefersLargeTitles = false
    view.backgroundColor = .white
    tableView.backgroundColor = .white
    tableView.contentInset = UIEdgeInsets(top: Style.Size.s64 + Style.Padding.p4, left: 0, bottom: 0, right: 0)

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
      if let ds = self?.dataSource as? JourneyDataSource {
        self?.progressLabel.text = "\(ds.distanceConveredToNextMilestone) / \(ds.distanceToNextMilestone) mi remaining to reach \(ds.nameOfNextMilestone)"
      }
      self?.tableView.reloadOnMain()
    }
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    if let _ = cell as? MilestoneCell {
    }
  }
}
