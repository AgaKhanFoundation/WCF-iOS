//
//  BaseScrollView.swift
//  WalkingChallenge
//
//  Created by Karim Abdul on 4/18/17.
//  Copyright © 2017 AKDN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BaseScrollView: UIScrollView {
  let contentView = UIView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    confireView()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    confireView()
  }
  func confireView() {
    addSubview(contentView)
    contentView.snp.makeConstraints { (make) in
      make.edges.equalTo(self)
      make.width.equalToSuperview()
    }
  }
}
