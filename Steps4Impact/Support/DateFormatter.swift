//
//  DateFormatter.swift
//  Steps4Impact
//
//  Created by Sami Suteria on 2/13/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import Foundation

extension DateFormatter {
  convenience init(format: String) {
    self.init()
    self.dateFormat = format
  }
}
