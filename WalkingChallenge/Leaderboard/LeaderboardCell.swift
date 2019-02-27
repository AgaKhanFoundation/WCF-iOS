//
//  LeaderboardCell.swift
//  WalkingChallenge
//
//  Created by Zain Budhwani on 2/26/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {
  var ranking: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  var teamName: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  var totalMiles: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  var amountRaised: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "LeaderboardCell")
    selectionStyle = .none
    setupViews()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupViews() {
    addSubview(ranking)
    ranking.snp.makeConstraints { (make) in
      make.top.equalTo(8)
      make.left.equalTo(8)
    }
    addSubview(teamName)
    teamName.snp.makeConstraints { (make) in
      make.top.equalTo(ranking.snp.top)
      make.left.equalTo(ranking.snp.left).offset(24)
    }
    let stackView = UIStackView(arrangedSubviews: [totalMiles, amountRaised])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 4
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .trailing
    addSubview(stackView)
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(ranking.snp.top)
      make.right.equalTo(-16)
    }
  }
}
