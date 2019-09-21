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
import Foundation

class Leaderboard: UIViewController {
  var fetchedTeams = [Team]()
  private var displayedTeams = [Team]() {
    didSet {
      DispatchQueue.main.async {
      self.updateList()
      self.leaderboardView.reloadData()
      }
    }
  }
  var currentTeam: Team? // the team that the user is in
  private let leaderboardId = Strings.Leaderboard.leaderboardId
  private let collapseId = Strings.Leaderboard.collapseId
  private var compactRegularConstraints = [NSLayoutConstraint]()
  private var compactCompactConstraints = [NSLayoutConstraint]()
  private var regularCompactConstraints = [NSLayoutConstraint]()
  private var regularRegularConstraints = [NSLayoutConstraint]()
  private var sharedConstraints = [NSLayoutConstraint]()
  private var shouldCollapse = false
  private var isCollapsed = true
  private let padding = Style.Padding.self
  private let lblTitle = UILabel(typography: .headerTitle)
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = true
    scrollView.panGestureRecognizer.delaysTouchesBegan = true
    scrollView.backgroundColor = .cyan
    scrollView.delegate = self
    return scrollView
  }()
  private var contentView: UIView = {
    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.backgroundColor = Style.Colors.white
    return contentView
  }()
  private let topRankingView: TopRankingView = {
    let view = TopRankingView()
    view.backgroundColor = Style.Colors.white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private lazy var leaderboardView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.isScrollEnabled = true
    tableView.isHidden = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = Style.Colors.white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CollapseCell.self, forCellReuseIdentifier: collapseId)
    tableView.register(LeaderboardCell.self, forCellReuseIdentifier: leaderboardId)
    return tableView
  }()
  private lazy var placeholderView: UIView = {
    let placeholderView = UIView()
    placeholderView.translatesAutoresizingMaskIntoConstraints = false
    placeholderView.backgroundColor = Style.Colors.white
    let placeholderLbl = UILabel(typography: .placeholder)
    placeholderLbl.translatesAutoresizingMaskIntoConstraints = false
    placeholderLbl.text = Strings.Leaderboard.placeholder
    placeholderLbl.textAlignment = .center
    placeholderLbl.numberOfLines = 2
    placeholderView.addSubview(placeholderLbl)
    placeholderLbl.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor).isActive = true
    placeholderLbl.topAnchor.constraint(equalTo: placeholderView.topAnchor, constant: padding.p16).isActive = true
    return placeholderView
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchData()
    displayTopRankingView()
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    setupViews()
  }
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setAllConstraints()
  }
  override func viewWillTransition( to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    updateLeaderboardView()
  }
  private func fetchData() {
    // Fetch Teams here
    // Set current Team here
    sortFetchedTeams()
  }
  private func sortFetchedTeams() {
    fetchedTeams.sort {
      $0.calculateTotalMiles() < $1.calculateTotalMiles()
    }
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
  private func displayTopRankingView() {
    for rank in 0..<min(3, fetchedTeams.count) {
      var isCurrentTeam = false
      if currentTeam != nil && fetchedTeams[rank] == currentTeam! {
        isCurrentTeam = true
      }
      displayRankingView(rank: rank, isCurrentTeam: isCurrentTeam)
    }
  }
  private func setupViews() {
    setupLeaderboard()
    setupScrollView()
    setupContentView()
    setupContentConstraints()
  }
  private func setupLeaderboard() {
    lblTitle.text = Strings.Leaderboard.title
    lblTitle.textColor = Style.Colors.black
    lblTitle.backgroundColor = .clear
    view.addSubview(lblTitle)
    lblTitle.snp.makeConstraints {
        $0.top.equalTo(topLayoutGuide.snp.bottom)
        $0.left.right.equalToSuperview().inset(padding.p24)
    }
  }
  private func setupScrollView() {
    view.addSubview(scrollView)
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
  }
  private func setupContentView() {
    scrollView.addSubview(contentView)
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    contentView.heightAnchor.constraint(equalToConstant: Style.Size.s1000).isActive = true
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    contentView.addSubview(topRankingView)
    contentView.addSubview(leaderboardView)
    contentView.addSubview(placeholderView)
  }
  private func setupContentConstraints() {
    sharedConstraints.append(contentsOf: [
      topRankingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      topRankingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      topRankingView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      leaderboardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      leaderboardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      leaderboardView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      leaderboardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      leaderboardView.topAnchor.constraint(equalTo: topRankingView.bottomAnchor, constant: padding.p32),
      placeholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      placeholderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      placeholderView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      placeholderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      placeholderView.topAnchor.constraint(equalTo: topRankingView.bottomAnchor, constant: padding.p32)
    ])
    compactRegularConstraints.append(contentsOf: [
      topRankingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.p86),
      topRankingView.heightAnchor.constraint(equalToConstant: padding.p208)
    ])
    compactCompactConstraints.append(contentsOf: [
      topRankingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.p48),
      topRankingView.heightAnchor.constraint(equalToConstant: padding.p208)
    ])
    regularCompactConstraints.append(contentsOf: [
      topRankingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.p86),
      topRankingView.heightAnchor.constraint(equalToConstant: padding.p208)
    ])
    regularRegularConstraints.append(contentsOf: [
      topRankingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.p96),
      topRankingView.heightAnchor.constraint(equalToConstant: padding.p316)
    ])
    setAllConstraints()
    scrollView.contentSize = CGSize(width: view.frame.width, height: Style.Size.s1000)
  }
  private func setAllConstraints() {
    activateConstraints(constraints: sharedConstraints)
    switch(traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
    case(.compact, .regular):
      setConstraints(active: compactRegularConstraints,
                     deactive: [compactCompactConstraints,
                                regularCompactConstraints,
                                regularRegularConstraints])
    case(.compact, .compact):
      setConstraints(active: compactCompactConstraints,
                     deactive: [compactRegularConstraints,
                                regularCompactConstraints,
                                regularRegularConstraints])
    case(.regular, .compact):
      setConstraints(active: regularCompactConstraints,
                     deactive: [compactCompactConstraints,
                                compactRegularConstraints,
                                regularRegularConstraints])
    default:
      setConstraints(active: regularRegularConstraints,
                     deactive: [compactCompactConstraints,
                                regularCompactConstraints,
                                regularCompactConstraints])
    }
    setHeightForRows()
  }
  private func updateList() {
    if displayedTeams.count <= 3 {
      leaderboardView.isHidden = true
      placeholderView.isHidden = false
    } else {
      leaderboardView.isHidden = false
      placeholderView.isHidden = true
    }
  }
}
extension Leaderboard: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CollapseOrExpandDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    updateList()
    if shouldCollapse {
      return displayedTeams.count + 1
    } else {
      return displayedTeams.count
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if shouldCollapse {
      if indexPath.row == 3 {
        let cell = leaderboardView.dequeueReusableCell(withIdentifier: collapseId, for: indexPath)
          as? CollapseCell
        cell?.delegate = self
        if isCollapsed {
          cell?.textLabel?.text = Strings.Leaderboard.expand
        } else {
          cell?.textLabel?.text = Strings.Leaderboard.collapse
        }
        return cell!
      } else if indexPath.row >= 4 {
          let cell = leaderboardView.dequeueReusableCell(withIdentifier: leaderboardId, for: indexPath)
            as? LeaderboardCell
          if displayedTeams[indexPath.row - 1] == currentTeam! {
            cell?.rankLbl.textColor = Style.Colors.green
            cell?.teamLbl.textColor = Style.Colors.green
            cell?.milesLbl.textColor = Style.Colors.green
          } else {
            cell?.rankLbl.textColor = Style.Colors.black
            cell?.teamLbl.textColor = Style.Colors.black
            cell?.milesLbl.textColor = Style.Colors.black
          }
          cell?.rankLbl.text = "\(getTeamRank(displayedTeams[indexPath.row - 1]))."
          cell?.teamLbl.text = displayedTeams[indexPath.row - 1].name
          cell?.milesLbl.text = "\(displayedTeams[indexPath.row - 1].calculateTotalMiles()) mi"
          return cell!
        }
    }
    let cell = leaderboardView.dequeueReusableCell(withIdentifier: leaderboardId, for: indexPath)
      as? LeaderboardCell
    if displayedTeams[indexPath.row] == currentTeam! {
      cell?.rankLbl.textColor = Style.Colors.green
      cell?.teamLbl.textColor = Style.Colors.green
      cell?.milesLbl.textColor = Style.Colors.green
    } else {
      cell?.rankLbl.textColor = Style.Colors.black
      cell?.teamLbl.textColor = Style.Colors.black
      cell?.milesLbl.textColor = Style.Colors.black
    }
    cell?.rankLbl.text = "\(getTeamRank(displayedTeams[indexPath.row]))."
    cell?.teamLbl.text = displayedTeams[indexPath.row].name
    cell?.milesLbl.text = "\(displayedTeams[indexPath.row].calculateTotalMiles()) mi"
    return cell!
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if (traitCollection.horizontalSizeClass == .compact &&
      traitCollection.verticalSizeClass == .regular) ||
      (traitCollection.horizontalSizeClass == .compact &&
        traitCollection.verticalSizeClass == .compact) {
      return HeaderView(frame: CGRect(x: 0, y: 0, width: leaderboardView.frame.width, height: Style.Size.s24))
    } else {
      return HeaderView(frame: CGRect(x: 0, y: 0, width: leaderboardView.frame.width, height: Style.Size.s32))
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if traitCollection.verticalSizeClass == .regular {
      return Style.Size.s32
    } else {
      return Style.Size.s24
    }
  }
  func setHeightForRows() {
    if traitCollection.verticalSizeClass == .regular {
      leaderboardView.rowHeight = Style.Size.s64
    } else {
      leaderboardView.rowHeight = Style.Size.s48
    }
  }
  func collapseOrExpand() {
    if isCollapsed {
      displayedTeams.insert(contentsOf: fetchedTeams[6..<currentTeamRank()! - 1], at: 3)
      isCollapsed = false
      updateLeaderboardView()
    } else {
      let end = currentTeamRank()! - 4
      displayedTeams.removeSubrange(3..<end)
      isCollapsed = true
      updateLeaderboardView()
    }
  }
}
extension Leaderboard {
  func updateLeaderboardView() {
    leaderboardView.reloadData()
    leaderboardView.setNeedsUpdateConstraints()
    leaderboardView.layoutIfNeeded()
    leaderboardView.reloadData()
  }
  func currentTeamRank() -> Int? {
    if currentTeam == nil {
      return nil
    }
    return fetchedTeams.firstIndex(of: currentTeam!)
  }
  func getTeamRank(_ team: Team) -> Int {
    return fetchedTeams.firstIndex(of: team) ?? 0
  }
  func displayRankingView(rank: Int, isCurrentTeam: Bool) {
    var lblColor = Style.Colors.black
    if isCurrentTeam {
      lblColor = Style.Colors.green
    }
    if rank == 0 {
      topRankingView.firstPlace.teamLbl.text = fetchedTeams[rank].name
      topRankingView.firstPlace.teamLbl.textColor = lblColor
      topRankingView.firstPlace.milesLbl.text = "\(fetchedTeams[rank].calculateTotalMiles()) mi)"
      topRankingView.firstPlace.milesLbl.textColor = lblColor
    } else if rank == 1 {
      topRankingView.secondPlace.teamLbl.text = fetchedTeams[rank].name
      topRankingView.secondPlace.teamLbl.textColor = lblColor
      topRankingView.secondPlace.milesLbl.text = "\(fetchedTeams[rank].calculateTotalMiles()) mi)"
      topRankingView.secondPlace.milesLbl.textColor = lblColor
    } else {
      topRankingView.thirdPlace.teamLbl.text = fetchedTeams[rank].name
      topRankingView.thirdPlace.teamLbl.textColor = lblColor
      topRankingView.thirdPlace.milesLbl.text = "\(fetchedTeams[rank].calculateTotalMiles()) mi)"
      topRankingView.thirdPlace.milesLbl.textColor = lblColor
    }
  }
}
