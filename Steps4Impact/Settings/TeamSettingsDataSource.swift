/**
 * Copyright © 2019 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

import Foundation
import RxSwift

enum TeamSettingsContext: Context {
  case invite
  case delete
  case editname
}

enum TeamMembersContext: Context {
  case remove(fbid: String, name: String)
}

protocol TeamSettingsDataSourceDelegate: class {
  func updated(team: Team?)
}

class TeamSettingsDataSource: TableViewDataSource {
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
  }

  private var teamName: String = " "
  private var eventName: String = " "
  private var eventTeamLimit: Int = 0
  private var team: [Member] = []
  private var isLead: Bool = false

  var editing: Bool = false
  public weak var delegate: TeamSettingsDataSourceDelegate?

  init() {
    let update = Observable.combineLatest(
      cache.facebookNamesRelay,
      cache.facebookProfileImageURLsRelay,
      cache.participantRelay,
      cache.currentEventRelay
    )

    update.subscribeOnNext { [weak self] (names, imageURLs, participant, currentEvent) in
      guard let participant = participant else { return }
      self?.delegate?.updated(team: participant.team)
      self?.isLead = participant.team?.creator == self?.facebookService.id
      self?.teamName = participant.team?.name ?? " "

      if let event = participant.currentEvent {
        self?.eventName = event.name
        self?.eventTeamLimit = event.teamLimit
        let members = participant.team?.members.map {
          Member(fbid: $0.fbid,
                 name: names[$0.fbid],
                 image: imageURLs[$0.fbid],
                 isLead: $0.fbid == participant.team?.creator)
        }
        self?.team = members ?? []
      }

      self?.configure()
      self?.completion?()
    }.disposed(by: disposeBag)
  }

  func reload(completion: @escaping () -> Void) {
    self.completion = completion
    configure()
    completion()

    AKFCausesService.getParticipant(fbid: facebookService.id) { [weak self] (result) in
      let participant = Participant(json: result.response)
      self?.cache.participantRelay.accept(participant)

      if let eventId = participant?.currentEvent?.id {
        AKFCausesService.getEvent(event: eventId) { (result) in
          self?.cache.currentEventRelay.accept(Event(json: result.response))
        }
      }

      if let team = participant?.team {
        for teamMember in team.members {
          self?.facebookService.getRealName(fbid: teamMember.fbid)
          self?.facebookService.getProfileImageURL(fbid: teamMember.fbid)
        }
      }
    }
  }

  func configure() {
    cells = [[
      TeamSettingsHeaderCellContext(team: self.teamName, event: self.eventName),
      SettingsTitleCellContext(title: "Team Members")
    ]]

    for (index, member) in self.team.enumerated() {
      var context: Context?
      if let fbid = member.fbid {
        context = TeamMembersContext.remove(fbid: fbid, name: member.name ?? "")
      }

      cells.append([
        TeamSettingsMemberCellContext(count: index + 1, imageURL: member.image,
                                      name: member.name ?? "",
                                      isLead: member.isLead,
                                      isEditable: !member.isLead && editing,
                                      isLastItem: index == self.team.count - 1,
                                      context: context)
      ])
    }

    cells.append([
      SettingsActionCellContext(
        title: "Invite \(self.eventTeamLimit - self.team.count) new team members",
        buttonStyle: .plain,
        context: TeamSettingsContext.invite)
    ])

    if isLead {
      cells.append([
        SettingsActionCellContext(
          title: "Delete Team",
          buttonStyle: .destructive,
          context: TeamSettingsContext.delete)
      ])
    }
    if isLead {
      cells.append([
        SettingsActionCellContext(
          title: "Edit Team Name",
          buttonStyle: .plain,
          context: TeamSettingsContext.editname)
      ])
    }
  }
}
