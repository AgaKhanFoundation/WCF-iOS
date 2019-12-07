//
//  LeaderboardDemoData.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/26/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import Foundation

struct DemoLeaderboard {

  var id: Int?
  var name: String?
  var distance: Int?
  static func getRecords() -> [DemoLeaderboard] {
    var res = [DemoLeaderboard]()
    for i in 0..<2 {
      let new = DemoLeaderboard(id: i+1, name: "Dolemite is My Name and fucking up mother fuckers is my name", distance: 2000)
      res.append(new)
    }
    return res
  }
}
