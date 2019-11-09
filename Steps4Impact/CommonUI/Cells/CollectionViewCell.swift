//
//  CollectionViewCell.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/3/19.
//  Copyright © 2019 AKDN. All rights reserved.
//


import Foundation

import UIKit

class CollectionViewCell : UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    backgroundColor = nil
  }
}

