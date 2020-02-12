//
//  TeamBreakDownDataSource.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 2/10/20.
//  Copyright © 2020 AKDN. All rights reserved.
//

import Foundation
import RxSwift

class TeamBreakdownDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []
  var completion: (() -> Void)?

  var teamMembers: [Participant] = []
  private var isLead: Bool = false
  private(set) var teamName: String?
  private var teamImages: [URL?] = []
  private var teamMemberNames: [String] = []
  private var leadId: String = ""

  func configure() {

    cells.removeAll()

    let totalSteps = teamMembers.reduce(0, { (total, member) -> Int in
      guard let records = member.records else { return total + 0 }
      var sum = 0
      for record in records {
        sum += (record.distance ?? 0)
      }
      return total + sum
    })

    let totalCommitment = teamMembers.reduce(0) { (total, member) -> Int in
      return total + (member.currentEvent?.commitment?.steps ?? 0)
    }

    cells.append([
      TeamBreakdownHeaderCellContext(totalSteps: (totalSteps/2000),
                                     totalCommitment: (totalCommitment/2000)),
      SettingsTitleCellContext(title: "Team Members")
    ])

    for (index, member) in teamMembers.enumerated() {
      let personalTotal = member.records?.reduce(0, { (total, record) -> Int in
        return total + (record.distance ?? 0)
      })

      cells.append([
        TeamBreakdownMemberCellContext(count: index + 1, imageURL: teamImages[safe: index] ?? URL(string: ""),
                                       name: teamMemberNames[safe: index] ?? "",
                                       isLead: leadId == member.fbid,
                                      isLastItem: index == teamMembers.count - 1,
                                      personalCommitment: member.currentEvent?.commitment?.miles ?? 0,
                                      personalTotalMiles: (personalTotal ?? 0)/2000)
      ])
    }
  }

  func reload(completion: @escaping () -> Void) {
    self.completion = completion
    teamImages.removeAll()
    teamMemberNames.removeAll()
    let group: DispatchGroup = DispatchGroup()
    AKFCausesService.getParticipant(fbid: Facebook.id) { [weak self] (result) in
      if let participant = Participant(json: result.response), let team = participant.team {
        self?.leadId = team.creator ?? "0"
        self?.teamName = team.name
        self?.teamMembers.removeAll()
        for member in team.members {

          group.enter()
          Facebook.profileImage(for: member.fbid) { (url) in
            self?.teamImages.append(url)
            group.leave()
          }
          group.enter()
          Facebook.getRealName(for: member.fbid) { (name) in
            self?.teamMemberNames.append(name ?? "")
            group.leave()
          }
          group.enter()
          AKFCausesService.getParticipant(fbid: member.fbid) { (result) in
            if let participant = Participant(json: result.response) {
              self?.teamMembers.append(participant)
            }
            group.leave()
          }
        }
        group.notify(queue: .global()) { [weak self] in
          self?.configure()
          completion()
        }
      }
    }
  }

}
