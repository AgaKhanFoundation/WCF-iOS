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

class LeaderboardDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []
  var completion: (() -> Void)?

  var allTeams = [Leaderboard]()
  var myTeamRank: Int?
  var myTeamId: Int = -1
  var expandListDataSource: [CellContext] = []

  func reload(completion: @escaping () -> Void) {
    self.completion = completion
    AKFCausesService.getParticipant(fbid: FacebookService.shared.id) { (result) in
      if let participant = Participant(json: result.response), let event = participant.events?.first {
        if let teamId = participant.team?.id {
          self.myTeamId = teamId
        }
        if let eventId = event.id {
          AKFCausesService.getLeaderboard(eventId: eventId) { (result) in
            if let teams = result.response?.arrayValue {
              self.allTeams.removeAll()
              for team in teams {
                guard let newLeaderboard = Leaderboard(json: team) else { return }
                self.allTeams.append(newLeaderboard)
              }
              self.configure()
              completion()
            }
          }
        }
      }
    }
  }

  func newLeaderboardContext(for row: Int) -> LeaderboardContext {
    let rank = row+1
    let name = allTeams[row].name ?? ""
    let distance = allTeams[row].miles ?? 0
    let isMyTeam = allTeams[row].id == myTeamId
    let context = LeaderboardContext(rank: rank, teamName: name, teamDistance: distance, isMyTeam: isMyTeam)
    return context
  }

  func configure() {
    cells.removeAll()
    expandListDataSource.removeAll()
    allTeams = allTeams.sorted(by: { ($0.distance ?? 0) > ($1.distance ?? 0) })
    let count = allTeams.count > 2 ? 3 : allTeams.count
    let podium = LeaderboardPodiumContext(count: count, data: allTeams)
    cells.append([podium])
    var rankTableList = [CellContext]()
    myTeamRank = nil
    if allTeams.count > 3 {
      rankTableList.append(LeaderboardHeaderCellContext())
      for index in 3..<allTeams.count {

        // Checking if current Team is in the leaderboard and note the current team's rank
        if allTeams[index].id == myTeamId {
          myTeamRank = index+1
        }

        // Adding a new section for expand/collapse rows to the list only if the current team's rank is not in top 6
        if index == 6 && myTeamRank == nil {
          cells.append(rankTableList)
          rankTableList.removeAll()
          rankTableList.append(ExpandCollapseCellContext())
          expandListDataSource.append(ExpandCollapseCellContext(titleText: "Collapse"))
          expandListDataSource.append(newLeaderboardContext(for: index))
        } else if index > 6 && myTeamRank == nil {
          expandListDataSource.append(newLeaderboardContext(for: index))
        } else if allTeams[index].id == myTeamId && index > 6 {
          cells.append(rankTableList)
          rankTableList.removeAll()
          rankTableList.append(newLeaderboardContext(for: index))
        } else {
          rankTableList.append(newLeaderboardContext(for: index))
        }
      }

      // If my team is not present in the leaderboard, remove the expand/collapse section and merge all in one list
      if myTeamRank == nil && allTeams.count >= 7 {
        expandListDataSource.removeFirst()
        rankTableList = cells.removeLast()
        rankTableList.append(contentsOf: expandListDataSource)
      }
    }
    cells.append(rankTableList)
    if allTeams.count == 0 {
      cells = [[
        EmptyLeaderboardCellContext(body: Strings.Leaderboard.empty)
        ]]
    }
  }
}
