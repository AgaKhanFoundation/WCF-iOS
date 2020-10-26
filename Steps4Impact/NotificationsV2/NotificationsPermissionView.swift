//
//  NotificationsPermissionView.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 10/25/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import Foundation
import UIKit

class NotificationPermissionView: UIView {
  
  let header: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Stay in the Loop"
    label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    label.textAlignment = .left
    label.baselineAdjustment = .alignCenters
    label.numberOfLines = 1
    return label
  }()
  
  let closeButton: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "close")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
//    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    addSubview(header) {
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.height.equalTo(Style.Size.s24)
      $0.top.equalToSuperview().offset(Style.Padding.p20)
    }
  }
}
