//
//  LeaderboardPickerCell.swift
//  WalkingChallenge
//
//  Created by Zain Budhwani on 2/26/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell {
  var leaderboard: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  var dropDownTextField: DropDownTextField!
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "LeaderboardPickerCell")
    selectionStyle = .default
    setupViews()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupViews() {
    addSubview(leaderboard)
    leaderboard.snp.makeConstraints { (make) in
      make.top.equalTo(8)
      make.left.equalTo(8)
    }
    dropDownTextField = DropDownTextField()
    addSubview(dropDownTextField)
    dropDownTextField.text = "Miles"
    dropDownTextField.textAlignment = .right
    dropDownTextField.snp.makeConstraints { (make) in
      make.top.equalTo(leaderboard)
      make.right.equalTo(-16)
      make.width.equalTo(175)
      make.height.equalTo(36)
    }
  }
}
