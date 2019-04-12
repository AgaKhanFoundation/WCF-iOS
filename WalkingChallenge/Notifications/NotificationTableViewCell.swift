//
//  NotificationTableViewCell.swift
//  WalkingChallenge
//
//  Created by Husein Kareem on 4/12/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class NotificationTableViewCell: UITableViewCell {

  lazy var notificationInfoLabel = UILabel()
  lazy var notificationDateLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.backgroundColor = UIColor.red
    self.addSubview(self.notificationInfoLabel)
    self.addSubview(self.notificationDateLabel)

    self.notificationInfoLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self).offset(20)
      make.left.equalTo(self).offset(20)
      make.bottom.equalTo(self).offset(-20)
      make.right.equalTo(self).offset(-20)
    }

    self.notificationInfoLabel.text = "HELLO"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
