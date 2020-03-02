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
  var cache = Cache.shared
  var facebookService = FacebookService.shared
  var disposeBag = DisposeBag()
  var cells: [[CellContext]] = []
  var completion: (() -> Void)?

  struct Member {
    let fbid: String?
    let name: String?
    let image: URL?
    let isLead: Bool
    let personalProgress: Int?
    let personalCommitment: Int?
  }

  var team: [Member] = []
  private var isLead: Bool = false
  private(set) var teamName: String?
  private var teamImages: [URL?] = []
  private var teamMemberNames: [String] = []
  private var leadId: String = ""

  init() {
    let update = Observable.combineLatest(
      cache.facebookNamesRelay,
      cache.facebookProfileImageURLsRelay,
      cache.participantRelay,
      cache.personalProgressRelay,
      cache.personalCommitmentRelay
    )

    update.subscribeOnNext { [weak self] (names, imageURLs, participant,
      personalProgresses, personalCommitments) in
      guard let participant = participant else { return }
      self?.isLead = participant.team?.creator == self?.facebookService.id
      self?.teamName = participant.team?.name ?? " "

      let members = participant.team?.members.map {
        Member(fbid: $0.fbid,
               name: names[$0.fbid],
               image: imageURLs[$0.fbid],
               isLead: $0.fbid == participant.team?.creator,
               personalProgress: personalProgresses[$0.fbid],
               personalCommitment: personalCommitments[$0.fbid]
        )
      }
      self?.team = members ?? []

      self?.configure()
      self?.completion?()
    }.disposed(by: disposeBag)
  }
  
  func configure() {

    cells.removeAll()

    let totalCommitment = team.reduce(0) { $0 + ($1.personalCommitment ?? 0)}
    let totalProgress = team.reduce(0) { $0 + ($1.personalProgress ?? 0)}

    cells.append([
      TeamBreakdownHeaderCellContext(totalSteps: totalProgress,
                                     totalCommitment: totalCommitment),
      SettingsTitleCellContext(title: "Team Members")
    ])

    for (index, member) in team.enumerated() {
      cells.append([
        TeamBreakdownMemberCellContext(count: index+1,
                                       imageURL: member.image,
                                       name: member.name ?? "",
                                       isLead: member.isLead,
                                       isLastItem: index == self.team.count - 1,
                                       personalCommitment: member.personalCommitment ?? 0,
                                       personalTotalMiles: member.personalProgress ?? 0)

      ])
    }
  }

  func reload(completion: @escaping () -> Void) {
    self.completion = completion
    configure()
    completion()

    AKFCausesService.getParticipant(fbid: facebookService.id) { [weak self] (result) in
      let participant = Participant(json: result.response)

      self?.cache.participantRelay.accept(participant)

      if let team = participant?.team {
        for teamMember in team.members {
          self?.facebookService.getRealName(fbid: teamMember.fbid)
          self?.facebookService.getProfileImageURL(fbid: teamMember.fbid)
          AKFCausesService.getParticipant(fbid: teamMember.fbid) { (result) in
            if let participant = Participant(json: result.response) {
              let personalTotal = participant.records?.reduce(0) { $0 + ($1.distance ?? 0) }
              self?.cache.update(fbid: teamMember.fbid, progress: (personalTotal ?? 0)/2000)
              self?.cache.update(fbid: teamMember.fbid, commitment: participant.currentEvent?.commitment?.miles ?? 0)
            }
          }
        }
      }
    }
  }
}
