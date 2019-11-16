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
import NotificationCenter

class ChallengeViewController: TableViewController {
  override func commonInit() {
    super.commonInit()

    title = Strings.Challenge.title
    dataSource = ChallengeDataSource()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: Assets.gear.image,
      style: .plain,
      target: self,
      action: #selector(settingsButtonTapped))

    _ = NotificationCenter.default.addObserver(forName: .teamChanged,
                                               object: nil, queue: nil) { [weak self] (_) in
      self?.reload()
    }
    _ = NotificationCenter.default.addObserver(forName: .commitmentChanged,
                                               object: nil, queue: nil) { [weak self] (_) in
      self?.reload()
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc
  private func settingsButtonTapped() {
    navigationController?.pushViewController(SettingsViewController(), animated: true)
  }

  override func tableView(_ tableView: UITableView,
                          willDisplay cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    if let cell = cell as? TeamNeededCell {
      cell.delegate = self
    }
    if let cell = cell as? DisclosureCell {
      cell.delegate = self
    }
    if let cell = cell as? ChallengeTeamProgressCell {
      cell.delegate = self
    }
  }
}

extension ChallengeViewController: TeamNeededCellDelegate {
  func teamNeededCellPrimaryTapped() {
    present(NavigationController(rootVC: CreateTeamViewController()),
            animated: true, completion: nil)
  }

  func teamNeededCellSecondaryTapped() {
    present(NavigationController(rootVC: JoinTeamViewController()),
            animated: true, completion: nil)
  }
}

extension ChallengeViewController: DisclosureCellDelegate {
  func disclosureCellTapped(context: Context?) {
    guard let context = context as? ChallengeContext else { return }
    switch context {
    case .inviteFriends:
      AppController.shared.shareTapped(viewController: self, shareButton: nil,
                                       string: Strings.Share.item)
    case .inviteSupporters:
      AppController.shared.shareTapped(viewController: self, shareButton: nil,
                                       string: Strings.InviteSupporters.request)
    case .showJourneyView:
      print("Journey View")
    }
  }
}

extension ChallengeViewController: ChallengeTeamProgressCellDelegate {
  func challengeTeamProgressDisclosureTapped() {
    // TODO(compnerd) view breakdown
  }

  func challengeTeamProgressEditTapped() {
    AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
      guard let participant = Participant(json: result.response) else { return }

      let alert = TextAlertViewController()
      alert.title = "Personal mile commitment"
      alert.value = "\(participant.currentEvent?.commitment?.miles ?? 0)"
      alert.suffix = "Miles"
      alert.add(.init(title: "Save", style: .primary, shouldDismiss: false) {
        if let cid = participant.currentEvent?.commitment?.id {
          AKFCausesService.setCommitment(cid, toSteps: (Int(alert.value ?? "0") ?? 0) * 2000) { (result) in
            alert.dismiss(animated: true) {
              if result.isSuccess {
                NotificationCenter.default.post(name: .commitmentChanged, object: nil)
              } else {
                let alert: AlertViewController = AlertViewController()
                alert.title = "Update Failed"
                alert.body = "Could not update commitment.  Please try again later."
                alert.add(.okay())
                onMain {
                  AppController.shared.present(alert: alert, in: self, completion: nil)
                }
              }
            }
          }
        }
      })
      alert.add(.cancel())
      AppController.shared.present(alert: alert, in: self, completion: nil)
    }
  }
}

enum ChallengeContext: Context {
  case inviteFriends
  case inviteSupporters
  case showJourneyView
}

class ChallengeDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []

  private var participant: Participant?
  private var teamCreator: String?
  private var teamImages: [URL?] = []
  private var teamMembers: [Participant] = []

  func reload(completion: @escaping () -> Void) {
    let group: DispatchGroup = DispatchGroup()

    self.participant = nil
    self.teamCreator = nil
    self.teamImages = []
    self.teamMembers = []

    group.enter()
    AKFCausesService.getParticipant(fbid: Facebook.id) { [weak self] (result) in
      if let participant = Participant(json: result.response), let team = participant.team {
        self?.participant = participant

        for member in team.members {
          group.enter()
          Facebook.profileImage(for: member.fbid) { (url) in
            self?.teamImages.append(url)
            group.leave()
          }

          group.enter()
          AKFCausesService.getParticipant(fbid: member.fbid) { (result) in
            if let participant = Participant(json: result.response) {
              self?.teamMembers.append(participant)
            }
            group.leave()
          }
        }

        group.enter()
        Facebook.getRealName(for: team.creator!) { (name) in // swiftlint:disable:this force_unwrapping
          self?.teamCreator = name
          group.leave()
        }
      }

      group.leave()
    }

    group.notify(queue: .global()) { [weak self] in
      self?.configure()
      completion()
    }
  }

  func configure() { // swiftlint:disable:this function_body_length
    guard participant?.team != nil else {
      configureNoTeamCells()
      return
    }

    guard let event = participant?.currentEvent,
          let team = participant?.team else {
      return
    }

    let formatter: DateFormatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeZone = TimeZone(abbreviation: "GMT")

    cells = []

    let daysUntilStart = Date().daysUntil(event.challengePhase.start)

    if daysUntilStart > 0 {
      cells.append([
        InfoCellContext(
          asset: .challengeJourney,
          title: "Journey",
          body: "Your journey begins in \(Date().daysUntil(event.challengePhase.start)) days on \(formatter.string(from: event.challengePhase.start))!") // swiftlint:disable:this line_length
      ])
    } else {
      guard let milestonesCompleted = event.commitment?.miles else { return }
      print(milestonesCompleted)
      cells.append([
        DisclosureCellContext(
          asset: .inviteFriends,
          title: "Journey",
          body: "\(milestonesCompleted) out of 10 milestones completed",
          disclosureTitle: "View milestone details",
          context: ChallengeContext.showJourneyView)
      ])
    }

    cells.append([
      ChallengeTeamProgressCellContext(
      teamName: team.name ?? "",
      teamLeadName: teamCreator ?? "",
      teamMemberImageURLS: teamImages,
      yourCommittedMiles: participant?.currentEvent?.commitment?.miles ?? 0,
      teamCommittedMiles: teamMembers.compactMap({ $0.currentEvent?.commitment?.miles }).reduce(0, +),
      totalMiles: 5500,
      disclosureTitle: "View Breakdown",
      isEditingHidden: false)
    ])

    let spots = event.teamLimit - team.members.count
    if spots > 0 {
      cells.append([
        DisclosureCellContext(
          asset: .inviteFriends,
          title: "Invite more friends to join!",
          body: "Maximize your chances of reaching the team goal. Your team has \(spots) \(spots > 1 ? "spots" : "spot") remaining. Invite more friends to join!", // swiftlint:disable:this line_length
          disclosureTitle: "Invite \(spots) new team members",
          context: ChallengeContext.inviteFriends)
      ])
    }

    cells.append([
      DisclosureCellContext(
        asset: .inviteSupporters,
        title: "Fundraise while you stay fit",
        body: "Did you know your friends and family can support you by donating to the cause?",
        disclosureTitle: "Invite supporters to pledge",
        context: ChallengeContext.inviteSupporters)
    ])
  }

  private func configureNoTeamCells() {
    cells = [[
      TeamNeededCellContext(
        title: Strings.Challenge.TeamNeededCard.title,
        body: Strings.Challenge.TeamNeededCard.body,
        primaryButtonTitle: Strings.Challenge.TeamNeededCard.primaryButton,
        secondaryButtonTitle: Strings.Challenge.TeamNeededCard.secondaryButton)
    ]]
  }
}
