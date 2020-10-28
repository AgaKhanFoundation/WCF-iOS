//
//  NotificationsPermissionView.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 10/25/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationPermissionCellDelegate: class{
  func turnOnNotifictions()
}

struct NotificationPermissionCellContext: CellContext {
  let identifier: String = NotificationPermissionCell.identifier
  let title: String
  let description: String
  let disclosureText: String
}

class NotificationPermissionCell: ConfigurableTableViewCell {
  static var identifier: String = "NotificationPermissionCell"
  
  private let cardView = CardViewV2()
  private let disclosureView = CellDisclosureView()
  
  weak var delegate: NotificationPermissionCellDelegate?
  
  let headerLabel = UILabel(typography: .title)
  let descriptionLabel = UILabel(typography: .smallRegular, color: Style.Colors.FoundationGrey.withAlphaComponent(0.5))
  
  let closeButton: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "close")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override func commonInit() {
    super.commonInit()
    backgroundColor = .clear
    disclosureView.delegate = self
    
    contentView.addSubview(cardView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p24)
      $0.top.bottom.equalToSuperview().inset(Style.Padding.p12)
    }
    
    cardView.addSubview(headerLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalToSuperview().offset(Style.Padding.p20)
    }
    
    cardView.addSubview(descriptionLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.top.equalTo(headerLabel.snp.bottom).offset(Style.Padding.p8)
    }
  
    cardView.addSubview(disclosureView) {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(Style.Padding.p20)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  func configure(context: CellContext) {
    guard let context = context as? NotificationPermissionCellContext else {
      return
    }
    
    headerLabel.text = context.title
    descriptionLabel.text = context.description
    disclosureView.configure(context: CellDisclosureContext(label: context.disclosureText))
  }
  
}

extension NotificationPermissionCell: CellDisclosureViewDelegate {
  func cellDisclosureTapped() {
    delegate?.turnOnNotifictions()
  }
}
