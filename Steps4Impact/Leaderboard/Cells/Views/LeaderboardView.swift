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

import UIKit
import SnapKit

class LeaderboardView: View {
  private let placeholderView: PlaceholderView = PlaceholderView(frame: .zero)
  private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
  private var fetchedTeams: [Team] = [] {
    didSet {
      self.reloadTableView()
    }
  }
  private var currentTeam: Team? {
    didSet {
      displayTeams()
      self.reloadTableView()
    }
  }
  private var shouldCollapse: Bool = false
  private var isCollapsed: Bool = true
  private var displayedTeams: [Team] = [] {
    didSet {
      self.reloadTableView()
    }
  }

  override func commonInit() {
    super.commonInit()

    tableView.backgroundColor = Style.Colors.white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(LeaderboardCell.self, forCellReuseIdentifier: LeaderboardCell.identifier)
    tableView.register(CollapseCell.self, forCellReuseIdentifier: CollapseCell.identifier)

    addSubview(placeholderView) {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }

    addSubview(tableView) {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
  }
  func configure(context: LeaderboardCardCellContext) {
    fetchedTeams = context.teams
    currentTeam = context.userTeam
    displayTeams()
    updateList()
  }
  private func displayTeams() {
    displayedTeams = [Team]()
    if fetchedTeams.count <= 3 {
      isCollapsed = true
      shouldCollapse = false
    } else if currentTeamRank() == nil {
      isCollapsed = true
      shouldCollapse = false
      displayedTeams.append(contentsOf: fetchedTeams[3..<fetchedTeams.count])
    } else if currentTeamRank()! <= 6 {
      isCollapsed = true
      shouldCollapse = false
      displayedTeams.append(contentsOf: fetchedTeams[3..<6])
    } else if currentTeamRank()! == 7 {
      isCollapsed = true
      shouldCollapse = false
      displayedTeams.append(contentsOf: fetchedTeams[3..<7])
    } else {
      isCollapsed = true
      shouldCollapse = true
      displayedTeams.append(contentsOf: fetchedTeams[3..<6])
      displayedTeams.append(contentsOf: fetchedTeams[currentTeamRank()! - 1..<fetchedTeams.count])
    }
  }
  private func updateList() {
    if displayedTeams.count <= 3 {
      tableView.isHidden = true
      placeholderView.isHidden = false
    } else {
      tableView.isHidden = false
      placeholderView.isHidden = true
    }
  }
  private func updateTableView() {
    tableView.reloadData()
    tableView.setNeedsUpdateConstraints()
    tableView.layoutIfNeeded()
    tableView.reloadData()
  }
  private func reloadTableView() {
    updateList()
    tableView.reloadData()
  }
}

extension LeaderboardView {
  func currentTeamRank() -> Int? {
    if currentTeam == nil {
      return nil
    }
    return fetchedTeams.firstIndex(of: currentTeam!)
  }
}

extension LeaderboardView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let cell = cell as? CollapseCell {
      cell.delegate = self
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if shouldCollapse && indexPath.row == 3 {
      return Style.Size.s40
    } else {
      return Style.Size.s64
    }
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return HeaderView(frame: CGRect(
      x: 0, y: 0,
      width: tableView.frame.width,
      height: Style.Size.s32))
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Style.Size.s32
  }
}

extension LeaderboardView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    updateList()
    if shouldCollapse {
      return displayedTeams.count + 1
    } else {
      return displayedTeams.count
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if shouldCollapse && indexPath.row == 3 {
      let cell = tableView.dequeueReusableCell(withIdentifier: CollapseCell.identifier, for: indexPath) as? CollapseCell
      if isCollapsed {
        cell?.lbl.text = "Expand"
      } else {
        cell?.lbl.text = "Collapse"
      }
      return cell!
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardCell.identifier,
        for: indexPath) as? LeaderboardCell
    if shouldCollapse && indexPath.row >= 4 {
      cell?.configure(context: LeaderboardCellContext(
        rank: indexPath.row + 3,
        dist: displayedTeams[indexPath.row - 1].calculateDist(),
        name: displayedTeams[indexPath.row - 1].name ?? "",
        isUserTeam: currentTeam != nil && currentTeam == displayedTeams[indexPath.row - 1]))
    } else {
      cell?.configure(context: LeaderboardCellContext(
        rank: indexPath.row + 4,
        dist: displayedTeams[indexPath.row].calculateDist(),
        name: displayedTeams[indexPath.row].name ?? "",
        isUserTeam: currentTeam != nil && currentTeam == displayedTeams[indexPath.row]))
    }
    return cell!
  }
}

extension LeaderboardView: CollapseCellDelegate {
  func collapseOrExpand() {
    if isCollapsed {
      displayedTeams.insert(contentsOf: fetchedTeams[6..<currentTeamRank()! - 1], at: 3)
      isCollapsed = false
      updateTableView()
    } else {
      let end = currentTeamRank()! - 4
      displayedTeams.removeSubrange(3..<end)
      isCollapsed = true
      updateTableView()
    }
  }
}
