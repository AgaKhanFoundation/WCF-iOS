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

  static let CellIdentifier: String = "NotificationCell"

  lazy var notificationInfoLabel: UILabel = UILabel()
  lazy var notificationDateLabel: UILabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.backgroundColor = Style.Colors.DeepTurquoise.withAlphaComponent(0.0735)
    self.layer.masksToBounds = false
    self.layer.renderShadow()

    self.addSubview(self.notificationInfoLabel)
    self.addSubview(self.notificationDateLabel)

    self.notificationInfoLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self).offset(10)
      make.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    self.notificationInfoLabel.numberOfLines = 0

    self.notificationDateLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.notificationInfoLabel.snp.bottom).offset(Style.Padding.p16)
      make.bottom.equalToSuperview().inset(Style.Padding.p16)
      make.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    //TODO: Placeholder, use name from data
    self.notificationInfoLabel.text = String(format: Strings.Notifications.notificationCellTitleLabelPlaceholderTextFormat,
                                             arguments: ["FirstName", "LastName"])
    //TODO: Placeholder for now, use date (w/ formatter) from data
    self.notificationDateLabel.text = "01/01/2000"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
