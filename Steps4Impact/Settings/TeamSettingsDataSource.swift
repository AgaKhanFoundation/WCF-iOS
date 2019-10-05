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

enum TeamSettingsContext: Context {
  case invite
  case delete
}

protocol TeamSettingsDataSourceDelegate: class {
  func updated(team: Team?)
}

class TeamSettingsDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []

  private var teamName: String = " "
  private var eventName: String = " "
  private var team: (members: [(name: String?, image: URL?)], capacity: Int) = ([], 0)
  private var isLead: Bool = false

  public weak var delegate: TeamSettingsDataSourceDelegate?

  func reload(completion: @escaping () -> Void) {
    configure()
    completion()

    onBackground { [weak self] in
      let group: DispatchGroup = DispatchGroup()

      var capacity: Int = 1
      var members: [(name: String?, image: URL?)] = []

      group.enter()
      AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
        if let participant = Participant(json: result.response) {
          self?.delegate?.updated(team: participant.team)

          if let event = participant.currentEvent {
            self?.eventName = event.name

            group.enter()
            AKFCausesService.getEvent(event: event.id!) { (result) in
              if let event = Event(json: result.response) {
                capacity = event.teamLimit
              }
              group.leave()
            }
          }

          self?.isLead = participant.team?.creator == Facebook.id

          if let team = participant.team {
            if let name = team.name { self?.teamName = name }

            members = [(String?, URL?)](repeating: (name: nil, image: nil), count: team.members.count)

            for (index, member) in team.members.enumerated() {
              group.enter()
              Facebook.getRealName(for: member.fbid) { (name) in
                members[index].name = name
                group.leave()
              }

              group.enter()
              Facebook.profileImage(for: member.fbid) { (url) in
                members[index].image = url
                group.leave()
              }
            }
          }
        }
        group.leave()
      }
      group.wait()

      self?.team = (members: members, capacity: capacity)

      self?.configure()
      completion()
    }
  }

  func configure() {
    cells = [[
      TeamSettingsHeaderCellContext(team: self.teamName, event: self.eventName),
      SettingsTitleCellContext(title: "Team Members")
    ]]

    for (index, member) in self.team.members.enumerated() {
      cells.append([
        TeamSettingsMemberCellContext(count: index + 1, imageURL: member.image,
                                      name: member.name ?? "",
                                      isLastItem: index == self.team.members.count - 1)
      ])
    }

    cells.append([
      SettingsActionCellContext(
        title: "Invite \(self.team.capacity - self.team.members.count) new team members",
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
  }
}
