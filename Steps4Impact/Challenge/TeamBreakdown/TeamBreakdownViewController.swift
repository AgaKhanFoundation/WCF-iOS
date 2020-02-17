//
//  TeamBreakdownViewController.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 2/10/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import UIKit

class TeamBreakdownViewController: TableViewController {

  var teamName: String?
  private let activityView = UIActivityIndicatorView(style: .gray)

  override func commonInit() {
    super.commonInit()
    dataSource = TeamBreakdownDataSource()
    view.addSubview(activityView) {
      $0.centerX.centerY.equalToSuperview()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = teamName ?? "Breakdown"
  }

  override func reload() {
    activityView.startAnimating()
    dataSource?.reload { [weak self] in
      onMain {
        if let dataSource = self?.dataSource as? TeamBreakdownDataSource, let teamName = dataSource.teamName {
          self?.title = teamName
        }
        self?.activityView.stopAnimating()
      }
      self?.tableView.reloadOnMain()
    }
  }
}
