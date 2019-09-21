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

class TeamSettingsDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []

  private var teamName: String = " "
  private var eventName: String = " "
  private var team: (members: [(name: String?, image: URL?)], capacity: Int) = ([], 0)

  func reload(completion: @escaping () -> Void) {
    configure()
    completion()

    onBackground { [weak self] in
      let CC: NSCondition = NSCondition() // swiftlint:disable:this identifier_name
      var MS: DispatchSemaphore = DispatchSemaphore(value: 0) // swiftlint:disable:this identifier_name

      var capacity: Int = 1
      var members: [(name: String?, image: URL?)] = []

      AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
        guard let participant = Participant(json: result.response) else {
          CC.signal()
          return
        }

        self?.eventName = participant.event?.name ?? " "

        if let event = participant.event?.id {
          AKFCausesService.getEvent(event: event) { (result) in
            guard let event = Event(json: result.response) else {
              CC.signal()
              return
            }
            capacity = event.teamLimit
            CC.signal()
          }
        }

        if let team = participant.team {
          self?.teamName = team.name ?? " "

          if let team = participant.team?.members {
            MS = DispatchSemaphore(value: team.count * 2)
            members = [(String?, URL?)](repeating: (name: nil, image: nil), count: team.count)
            for (index, member) in team.enumerated() {
              Facebook.getRealName(for: member.fbid) { (name) in
                members[index].name = name
                MS.signal()
              }
              Facebook.profileImage(for: member.fbid) { (url) in
                members[index].image = url
                MS.signal()
              }
            }
          }
        }
      }

      CC.wait()
      MS.wait()

      self?.team = (members: members, capacity: capacity)

      self?.configure()
      completion()
    }
  }

  func configure() {
    var members: [[CellContext]] = []
    for (index, member) in self.team.members.enumerated() {
      members.append([TeamSettingsMemberCellContext(count: index + 1,
                                                    imageURL: member.image,
                                                    name: member.name ?? "<Facebook Error>",
                                                    isLastItem: index == self.team.members.count - 1)])
    }

    cells = [[
      TeamSettingsHeaderCellContext(team: self.teamName, event: self.eventName),
      SettingsTitleCellContext(title: "Team Members")
    ]] + members + [[
      SettingsActionCellContext(
        title: "Invite \(self.team.capacity - self.team.members.count) new team members",
        buttonStyle: .plain,
        context: nil),
      SettingsActionCellContext(
        title: "Delete Team",
        buttonStyle: .destructive,
        context: nil)
    ]]
  }
}
