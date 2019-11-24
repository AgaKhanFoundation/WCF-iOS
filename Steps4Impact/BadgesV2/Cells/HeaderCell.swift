//
//  HeaderCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/9/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit

class HeaderCell: ConfigurableCollectionViewCell {
  func configure(context: CellContext) {
  }
  
  static var identifier: String = "HeaderCell"
  
  let headerLabel: UILabel = {
    let label = UILabel(typography: .subtitleRegular)
    label.textAlignment = .left
    label.numberOfLines = 1
    label.textColor = UIColor(hex: 0x111111)
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    return label
  }()
  
  let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(hex: 0xF1F1F1)
    return view
  }()
  
  override func commonInit() {
    super.commonInit()
    
    contentView.addSubview(lineView) {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.height.equalTo(1)
    }
    
    contentView.addSubview(headerLabel) {
      $0.leading.equalToSuperview().offset(Style.Padding.p16)
      $0.trailing.equalToSuperview().inset(Style.Padding.p16)
      $0.centerY.equalToSuperview()
    }
  }
}
