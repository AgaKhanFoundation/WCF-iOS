//
//  Leaderboard.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/24/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation

struct Leaderboard {
  var id: Int?                                                                        // swiftlint:disable:this identifier_name line_length
  var name: String?
  var commitment: Int?
  var distance: Int?
  var hidden: Int?

  init?(json: JSON?) {
    guard let json = json else { return nil }
    self.id = json["id"]?.intValue
    self.name = json["name"]?.stringValue
    self.commitment = json["commitment"]?.intValue
    self.distance = json["distance"]?.intValue
    self.hidden = json["hidden"]?.intValue
  }

  public var miles: Int? {
    return (distance ?? 1)/2000
  }
}
