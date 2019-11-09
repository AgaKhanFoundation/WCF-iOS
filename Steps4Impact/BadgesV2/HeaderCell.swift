//
//  HeaderCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/9/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import UIKit

class HeaderCell: UICollectionViewCell {

  let headerLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.textColor = UIColor(hex: 0x111111)
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    return label
  }()

  let lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(hex: 0xF1F1F1)
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    backgroundColor = .white
    addSubview(lineView)
    addSubview(headerLabel)

    lineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    lineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
    lineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
    lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
    headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
  }
}

