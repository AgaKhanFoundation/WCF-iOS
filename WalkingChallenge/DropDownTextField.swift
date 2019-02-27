//
//  DropDownTextField.swift
//  WalkingChallenge
//
//  Created by Zain Budhwani on 2/26/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

class DropDownTextField: UITextField {
  var dropDownOptions: [String] = []
  var dropDownMenu = UIPickerView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDropDown()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupDropDown() {
    backgroundColor = .white
    setIcon(#imageLiteral(resourceName: "downArrow"))
    translatesAutoresizingMaskIntoConstraints = false
    inputView = dropDownMenu
  }
}

extension DropDownTextField {
  func setIcon(_ image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
    iconView.image = image
    iconView.tintColor = .black
    let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
    iconContainerView.addSubview(iconView)
    rightView = iconContainerView
    rightViewMode = .always
  }
}
