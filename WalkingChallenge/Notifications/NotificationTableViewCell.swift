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

    self.backgroundColor = UIColor(red: 0/255.0, green: 168/255.0, blue: 93/255.0, alpha: 0.07351600000000003)
    self.layer.masksToBounds = false
    self.layer.shadowColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1.0000000000)
    self.layer.shadowOffset = .zero
    self.layer.shadowOpacity = 0.5
    self.layer.shadowRadius = Style.Size.s8

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

    self.notificationInfoLabel.text = "FirstName LastName has joined your team!"
    self.notificationDateLabel.text = "01/01/2000"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
