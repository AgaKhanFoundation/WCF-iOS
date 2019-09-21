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
    case logout
    case deleteAccount
    case connectSource
  }

  private var isTeamLead = true
  private var imageURL: URL?
  private var name: String = " "
  private var isOnTeam: Bool = false
  private var teamName: String = " "
  private var teamMembership: String = " "

  func reload(completion: @escaping () -> Void) {
    configure()
    completion()

    onBackground { [weak self] in
      Facebook.profileImage(for: "me") { (url) in
        guard let url = url else { return }

        self?.imageURL = url
        self?.configure()
        completion()
      }

      Facebook.getRealName(for: "me") { (name) in
        self?.name = name ?? "Could not load"
        self?.configure()
        completion()
      }

      AKFCausesService.getParticipant(fbid: Facebook.id, completion: { (result) in
        guard let participant = Participant(json: result.response) else { return }
        self?.isOnTeam = participant.team != nil
      })
    }
  }

  func configure() {
    cells = [[
      SettingsProfileCellContext(
        imageURL: imageURL,
        name: name,
        teamName: teamName,
        membership: teamMembership),
      SettingsTitleCellContext(
        title: "Personal"),
      SettingsDisclosureCellContext(
        title: "Personal Mile Commitment",
        body: "Mile commitment cannot be changed once the challenge has started.",
        value: "500 mi"),
      SettingsSwitchCellContext(
        title: "Push Notifications",
        isSwitchEnabled: true),
      SettingsDisclosureCellContext(
        title: "Connected apps & devices",
        isLastItem: true,
        context: SettingsContext.connectSource),
      SettingsTitleCellContext(
        title: "Team"),
      SettingsDisclosureCellContext(
        title: "View team",
        context: SettingsContext.viewTeam),
      SettingsSwitchCellContext(
        title: "Team visibility",
        body: "Your team is discoverable.\nAny participant can find and join your team.",
        switchLabel: "Public",
        isSwitchEnabled: true,
        isLastItem: true),
      SettingsActionCellContext(
        title: "Logout",
        context: SettingsContext.logout),
      SettingsActionCellContext(
        title: "Delete Account",
        buttonStyle: .plain,
        context: SettingsContext.deleteAccount)
      ]]
  }

  func deleteAccount(completion: @escaping () -> Void) {
    AKFCausesService.deleteParticipant(fbid: Facebook.id) { (_) in
      completion()
    }
  }
}
