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

class SettingsDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []

  enum SettingsContext: Context {
    case viewTeam
    case leaveTeam
    case logout
    case deleteAccount
    case connectSource
    case createAKFProfile
  }

  private var isTeamLead = false
  private var imageURL: URL?
  private var name: String = " "
  private var isOnTeam: Bool = false
  private var teamName: String = " "
  private var teamMembership: String = " "

  func reload(completion: @escaping () -> Void) {
    configure()
    completion()

    onBackground { [weak self] in
      let group: DispatchGroup = DispatchGroup()

      group.enter()
      AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
        if let participant = Participant(json: result.response) {
          self?.isOnTeam = participant.team != nil
          // TODO(compnerd) query this from the team's creator field
          self?.isTeamLead = participant.team?.members[safe: 0]?.fbid == participant.fbid
        }
        group.leave()
      }

      group.enter()
      Facebook.profileImage(for: "me") { (url) in
        if let url = url { self?.imageURL = url }
        group.leave()
      }

      group.enter()
      Facebook.getRealName(for: "me") { (name) in
        if let name = name { self?.name = name }
        group.leave()
      }

      group.wait()

      self?.configure()
      completion()
    }
  }

  func configure() {
    cells = [[
      // Profile
      SettingsProfileCellContext(imageURL: imageURL, name: name,
                                 teamName: teamName, membership: teamMembership),
      // Personal
      SettingsTitleCellContext(title: "Personal"),
      SettingsDisclosureCellContext(title: "Personal Mile Commitment",
                                    body: "Mile commitment cannot be changed once the challenge has started.",
                                    value: "500 mi"),
      SettingsSwitchCellContext(title: "Push Notifications",
                                isSwitchEnabled: true),
      SettingsDisclosureCellContext(title: "Connected apps & devices",
                                    context: SettingsContext.connectSource)
  ]]

  if UserInfo.AKFID == nil {
    cells.append([SettingsDisclosureCellContext(title: "Create Aga Khan Foundation Profile",
                                                isLastItem: true,
                                                context: SettingsContext.createAKFProfile)])
  }

  cells.append(contentsOf: [[
    // Team
    SettingsTitleCellContext(title: "Team"),
    SettingsDisclosureCellContext(title: "View team",
                                  isDisclosureHidden: !isOnTeam,
                                  context: SettingsContext.viewTeam),
    (isTeamLead
      ? SettingsSwitchCellContext(title: "Team visibility",
                                  body: "Your team is discoverable.\nAny participant can find and join your team.",
                                  switchLabel: "Public",
                                  isSwitchEnabled: true, isLastItem: true)
      : SettingsDisclosureCellContext(title: "Leave Team",
                                      isDisclosureHidden: !isOnTeam,
                                      isLastItem: true,
                                      context: SettingsContext.leaveTeam)),
    SettingsActionCellContext(title: "Logout",
                              context: SettingsContext.logout),
    SettingsActionCellContext(title: "Delete Account", buttonStyle: .plain,
                              context: SettingsContext.deleteAccount)
    ]])
  }
}
