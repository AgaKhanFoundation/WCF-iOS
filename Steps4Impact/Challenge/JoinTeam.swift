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
import NotificationCenter

class JoinTeamViewController: TableViewController {
  private let searchController = UISearchController(searchResultsController: nil)

  var selectedId: Int? {
    didSet {
      navigationItem.rightBarButtonItem?.isEnabled = selectedId != nil
    }
  }

  override func commonInit() {
    super.commonInit()

    title = Strings.Challenge.JoinTeam.title
    dataSource = JoinTeamDataSource()
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: Assets.close.image,
      style: .plain,
      target: self,
      action: #selector(closeButtonTapped))
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Join",
      style: .plain,
      target: self, action: #selector(joinTapped))
    navigationItem.rightBarButtonItem?.isEnabled = false
    configureSearchController()
  }

  private func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let context = (tableView.cellForRow(at: indexPath) as? Contextable)?.context else { return }
    handle(context: context)
  }

  // MARK: - Actions

  @objc
  func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }

  @objc
  func joinTapped() {
    guard let selectedId = selectedId, let dataSource = dataSource as? JoinTeamDataSource else { return }
    dataSource.joinTeam(team: selectedId) { [weak self] (success) in
      guard let `self` = self else { return }
      let alert = AlertViewController()
      alert.title = "Error"
      alert.body = "Could not join team."
      alert.add(.okay())

      onMain {
        if success {
          // Not pushing the success view controller because we don't want the user to be able to go back in the stack
          self.navigationController?.setViewControllers([JoinTeamSuccessViewController()], animated: true)
        } else {
          AppController.shared.present(alert: alert, in: self, completion: nil)
        }
      }
    }
  }

  override func handle(context: Context) {
    guard let context = context as? JoinTeamContext else { return }
    switch context {
    case .none:
      selectedId = nil
    case .team(id: let id): // swiftlint:disable:this identifier_name
      selectedId = id
    }
  }
}

extension JoinTeamViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    selectedId = nil
    guard let searchText = searchController.searchBar.text else { return }
    (dataSource as? JoinTeamDataSource)?.filter(search: searchText, { [weak self] in
      self?.reload()
    })
  }
}

class JoinTeamSuccessViewController: ViewController {
  private let checkmarkImageView = UIImageView(image: Assets.checkmark.image)
  private let titleLabel = UILabel(typography: .title)

  override func configureView() {
    super.configureView()
    title = Strings.Challenge.JoinTeam.title
    checkmarkImageView.contentMode = .scaleAspectFit
    titleLabel.text = "You have successfully joined"
    titleLabel.textAlignment = .center
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: Assets.close.image,
      style: .plain,
      target: self,
      action: #selector(closeButtonTapped))

    view.addSubview(checkmarkImageView) {
      $0.height.width.equalTo(100)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p32)
    }

    view.addSubview(titleLabel) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.top.equalTo(checkmarkImageView.snp.bottom).offset(Style.Padding.p32)
    }
  }

  @objc
  func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
}

enum JoinTeamContext: Context {
  case none
  case team(id: Int) // swiftlint:disable:this identifier_name
}

class JoinTeamDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []

  private var teams: [Team] = []
  private var event: Event?
  private var filter: String?
  private(set) var teamLimit: Int?

  func reload(completion: @escaping () -> Void) {
    AKFCausesService.getParticipant(fbid: Facebook.id) { [weak self] (result) in
      guard let participant = Participant(json: result.response) else { return }

      if let event = participant.currentEvent {
        self?.event = event
      }

      if let events = participant.events, events.count > 0 {
        self?.teamLimit = events[0].teamLimit
      }


      AKFCausesService.getTeams { [weak self] (result) in
        if let teams = result.response?.arrayValue {
          self?.teams = teams.compactMap { Team(json: $0) }
            .filter { $0.members.count < (self?.teamLimit ?? 11) }
            .sorted { $0.members.count > $1.members.count }


          self?.configure()
          completion()
        } else {
          self?.configure()
          completion()
        }
      }
    }
  }

  func configure() {
    var teamCells: [JoinTeamCellContext] = teams
      .filter {
        guard let filter = self.filter else { return true }
        return $0.name?.lowercased().contains(filter.lowercased()) ?? true
      }
      .compactMap {
      guard
        let name = $0.name,
        let id = $0.id, // swiftlint:disable:this identifier_name
        let teamLimit = self.teamLimit
      else { return nil }
      return JoinTeamCellContext(
        teamLimit: teamLimit,
        teamName: name,
        memberCount: $0.members.count,
        context: JoinTeamContext.team(id: id))
    }

    if teamCells.isEmpty {
      cells = [[
          InfoCellContext(
            title: "No Teams Available",
            body: "No teams available for the event you are a part of. Please create a new team.")
        ]]
    } else {
      var last = teamCells.removeLast()
      last.isLastItem = true
      teamCells.append(last)

      cells = [teamCells]
    }
  }

  func joinTeam(team: Int, _ completion: @escaping (Bool) -> Void) {
    AKFCausesService.joinTeam(fbid: Facebook.id, team: team) { (result) in
      completion(result.isSuccess)
      if result.isSuccess {
        NotificationCenter.default.post(name: .teamChanged, object: nil)
      }
    }
  }

  func filter(search: String, _ completion: () -> Void) {
    filter = search.isEmpty ? nil : search
    configure()
    completion()
  }
}
