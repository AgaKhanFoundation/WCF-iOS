//
//  JourneyCard.swift
//  WalkingChallenge
//
//  Created by Mohsin on 24/02/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation
import SnapKit
import Foundation
import UIKit

typealias StylizedJourneyView =  JourneyCardViewCell & LayoutableCardView

class JourneyCardViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    guard let view = self as? StylizedJourneyView else { return }

    self.contentView.backgroundColor = .white
    self.contentView.layer.cornerRadius = Style.Size.s8
    self.backgroundColor = .clear
    self.layer.masksToBounds = false
    self.layer.shadowColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1.0000000000)
    self.layer.shadowOffset = .zero
    self.layer.shadowOpacity = 0.5
    self.layer.shadowRadius = Style.Size.s8

    view.layout()
  }
}
