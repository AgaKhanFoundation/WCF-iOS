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
import SDWebImage

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
      let ds = dataSource as? ChallengeDataSource
      let teamName = ds?.participant?.team?.name
      AppController.shared.shareTapped(viewController: self, shareButton: nil,
                                       string: Strings.Share.item(teamName: teamName ?? ""))
    case .inviteSupporters:
      AppController.shared.shareTapped(viewController: self, shareButton: nil,
                                       string: Strings.InviteSupporters.request)
    case .showJourneyView:
      let journeyVC = JourneyViewController()
      if let journeyDataSource = journeyVC.dataSource as? JourneyDataSource, let challengeDataSource = self.dataSource as? ChallengeDataSource {
        journeyDataSource.milestones = challengeDataSource.milestones ?? []
        journeyDataSource.totalDistance = challengeDataSource.teamTotalSteps
      }
      navigationController?.pushViewController(journeyVC, animated: true)
    }
  }
}

extension ChallengeViewController: ChallengeTeamProgressCellDelegate {
  func challengeTeamProgressDisclosureTapped() {
    navigationController?.pushViewController(TeamBreakdownViewController(), animated: true)
  }

  func challengeTeamProgressEditTapped() {
    AKFCausesService.getParticipant(fbid: User.id) { (result) in
      guard let participant = Participant(json: result.response) else { return }
      if let _ = participant.currentEvent {
        let alert = TextAlertViewController()
        alert.title = Strings.CommitmentAlert.title
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
                  alert.title = Strings.CommitmentAlert.Failure.title
                  alert.body = Strings.CommitmentAlert.Failure.body
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
      } else {
        let alert = AlertViewController()
        alert.title = Strings.CommitmentAlert.Fallback.title
        alert.body = Strings.CommitmentAlert.Fallback.body
        alert.add(.okay({
          alert.dismiss(animated: true, completion: nil)
        }))
        AppController.shared.present(alert: alert, in: self, completion: nil)
      }
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

  private(set) var participant: Participant?
  private var teamCreator: String?
  private var teamImages: [URL?] = []
  private(set) var teamTotalSteps = 0
  private var teamMembers: [Participant] = []
  private(set) var achievement: Achievement?
  private(set) var milestones: [Milestone]?
  private(set) var isLead: Bool = false


  func reload(completion: @escaping () -> Void) {
    let group: DispatchGroup = DispatchGroup()

    self.participant = nil
    self.teamCreator = nil
    self.teamImages = []
    self.teamMembers = []
    self.achievement = nil

    group.enter()
    AKFCausesService.getParticipant(fbid: User.id) { [weak self] (result) in
      if let participant = Participant(json: result.response), let team = participant.team {
        self?.participant = participant
        self?.isLead = participant.team?.creator == User.id

        group.enter()
        AKFCausesService.getAchievement { (result) in
          if let achievement = Achievement(json: result.response) {
            self?.achievement = achievement
          }
          group.leave()
        }
        
        // TODO(samisuteria): update this to relay/cache system
        for member in team.members {
          group.enter()
          AKFCausesService.getParticipantSocial(fbid: member.fbid) { [weak self] (result) in
            if
              let response = result.response?.dictionaryValue,
              let photoURLRaw = response["photoURL"]?.stringValue,
              let photoURL = URL(string: photoURLRaw) {
              self?.teamImages.append(photoURL)
            }
            
            group.leave()
          }
          
          // TODO(samisuteria): update this to relay/cache system
          group.enter()
          AKFCausesService.getParticipant(fbid: member.fbid) { (result) in
            if let participant = Participant(json: result.response) {
              self?.teamMembers.append(participant)
            }
            group.leave()
          }
        }
        
        // TODO(samisuteria): update this to relay/cache system
        if let creator = team.creator {
          group.enter()
          AKFCausesService.getParticipantSocial(fbid: creator) { (result) in
            if let name = result.response?.dictionaryValue?["displayName"]?.stringValue {
              self?.teamCreator = name
            }
            group.leave()
          }
        }
      }

      group.leave()
    }

    group.notify(queue: .global()) { [weak self] in
      self?.configure()
      completion()
    }
  }

  func getCurrentMilestone(numSteps: Int) -> Int {
    var currMilestone = -1
    for milestone in self.milestones ?? [] {
      if numSteps >= milestone.distance {
        currMilestone += 1
      } else {
        break
      }
    }
    return currMilestone
  }

  func configure() { // swiftlint:disable:this function_body_length
    guard participant?.team != nil else {
      configureNoTeamCells()
      return
    }

    guard let event = participant?.events?.first,
          let team = participant?.team else {
      return
    }

    let formatter: DateFormatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeZone = TimeZone(abbreviation: "GMT")

    cells = []

    if let milestones = achievement?.milestones, milestones.count < 9 {
      if AppController.isTestRun {
        self.milestones = MilestoneDetails.testRunDictionary.compactMap({ Milestone(json: JSON($0))})
      } else {
        self.milestones = MilestoneDetails.dictionary.compactMap({ Milestone(json: JSON($0))})
      }
    } else {
      self.milestones = achievement?.milestones
    }

    let daysUntilStart = Date().daysUntil(event.challengePhase.start)

    if daysUntilStart > 0 {
      cells.append([
        InfoCellContext(
          asset: .onboardingJourney,
          title: "Journey",
          body: "Your journey begins in \(Date().daysUntil(event.challengePhase.start)) days on \(formatter.string(from: event.challengePhase.start))!") // swiftlint:disable:this line_length
      ])
    } else {

      // If need to get the sum of only the last record of every team member
//      teamTotalSteps = teamMembers.reduce(0, { (total, team) -> Int in
//        guard let records = team.records, records.count > 0 else { return total + 0 }
//        return total + (records[0].distance ?? 0)
//      })

      // If we need to get sum of all records of every team member
      teamTotalSteps = teamMembers.reduce(0, { (total, team) -> Int in
        guard let records = team.records else { return total + 0 }
        var sum = 0
        for record in records {
          sum += (record.distance ?? 0)
        }
        return total + sum
      })

      let milestonesCompleted = getCurrentMilestone(numSteps: teamTotalSteps)
      cells.append([
        DisclosureCellContext(
          asset: .onboardingJourney,
          title: "Journey",
          body: "\(milestonesCompleted) out of 8 milestones completed",
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
      totalMiles: (event.defaultStepCount/2000) * event.teamLimit,
      disclosureTitle: "View Breakdown",
      isEditingHidden: false)
    ])

    let spots = event.teamLimit - team.members.count
    if spots > 0 && isLead {
      cells.append([
        DisclosureCellContext(
          asset: .inviteFriends,
          title: "Invite more friends to join!",
          body: "Maximize your chances of reaching the team goal. Your team has \(spots) \(spots > 1 ? "spots" : "spot") remaining. Invite more friends to join!", // swiftlint:disable:this line_length
          disclosureTitle: "Invite \(spots) new team members",
          context: ChallengeContext.inviteFriends)
      ])
    }

//    cells.append([
//      DisclosureCellContext(
//        asset: .inviteSupporters,
//        title: "Fundraise while you stay fit",
//        body: "Did you know your friends and family can support you by donating to the cause?",
//        disclosureTitle: "Invite supporters to pledge",
//        context: ChallengeContext.inviteSupporters)
//    ])

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
