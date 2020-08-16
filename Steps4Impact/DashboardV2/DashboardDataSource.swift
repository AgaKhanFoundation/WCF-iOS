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
import RxSwift

class DashboardDataSource: TableViewDataSource {
  var cache = Cache.shared
  var disposeBag = DisposeBag()
  var cells = [[CellContext]]()
  var completion: (() -> Void)?

  private var name: String = " "
  private var imageURL: URL?
  private var teamName: String = " "
  private var eventName: String = " "
  private var eventTimeline: DateInterval = DateInterval(start: Date(), duration: 0)
  private var eventTimelineString: String = " "
  private var eventLengthInDays: Int = 1
  private var milesCountDay: Int = 0
  private var milesCountWeek: Int = 0
  private var commitment: Int = 0
  private(set) var participant: Participant?
  private(set) var event: Event?
  private var pedometerStepsData: [PedometerData] = []
  private var pedometerDistanceData: [PedometerData] = []
  private var healthKitDataProvider = HealthKitDataProvider()
  private var fitBitDataProvider = FitbitDataProvider()

  enum DashboardContext: Context {
    case inviteSupporters
  }

  init() {
    let update = Observable.combineLatest(
      cache.socialDisplayNamesRelay,
      cache.socialProfileImageURLsRelay,
      cache.participantRelay)

    update.subscribeOnNext { [weak self] (names, imageURLs, participant) in
      guard let `self` = self else { return }
      self.name = names["me"] ?? " "
      self.imageURL = imageURLs["me"]
      self.teamName = participant?.team?.name ?? " "
      if let event = participant?.currentEvent {
        self.eventName = event.name
        self.eventTimeline = DateInterval(start: event.teamFormationPhase.start, end: event.challengePhase.end)
        self.eventTimelineString = DataFormatters
          .formatDateRange(value: (start: event.challengePhase.start, end: event.challengePhase.end))
        self.eventLengthInDays = event.lengthInDays
        self.commitment = event.commitment?.miles ?? 300
      } else {
        self.eventName = "No Current Event"
        let monthsInSeconds: Double = 60 * 60 * 24 * 30
        self.eventTimeline = DateInterval(
          start: Date(timeIntervalSinceNow: -monthsInSeconds),
          end: Date(timeIntervalSinceNow: monthsInSeconds))
        self.eventTimelineString = "Last 2 Months"
        self.eventLengthInDays = self.eventTimeline.start.daysUntil(self.eventTimeline.end)
        self.commitment = 300
      }
      self.configure()
      self.completion?()
      self.getPedometerData()
    }.disposed(by: disposeBag)
  }

  func reload(completion: @escaping () -> Void) {
    self.completion = completion
    self.name = " "
    self.imageURL = nil
    self.teamName = " "
    self.eventName = " "
    self.eventTimelineString = " "

    configure()
    completion()

    cache.fetchSocialInfo(fbid: User.id)
    AKFCausesService.getParticipant(fbid: User.id) { [weak self] (result) in
      self?.cache.participantRelay.accept(Participant(json: result.response))
    }
    let group: DispatchGroup = DispatchGroup()
    AKFCausesService.getParticipant(fbid: User.id) { [weak self] (result) in
      if var participant = Participant(json: result.response), let team = participant.team {
        self?.event = participant.currentEvent

        for member in team.members {
          group.enter()
          AKFCausesService.getParticipant(fbid: member.fbid) { (result) in
            if let part = Participant(json: result.response) {
              participant.teamMembers.append(part)
            }
            group.leave()
          }
        }
        group.notify(queue: .global()) { [weak self] in
          self?.participant = participant
          self?.configure()
          completion()
        }
      }
    }
  }

  func configure() {
    cells = [[
      ProfileCardCellContext(
        imageURL: imageURL,
        name: name,
        teamName: teamName,
        eventName: eventName,
        eventTimeline: eventTimelineString,
        disclosureLabel: Strings.Dashboard.badges),
      activityCell,
      MiniChallengeProgressCellContext(title: "Challenge Progress",
                                       teamProgressMiles: participant?.currentTeamProgressInMiles ?? 0,
                                       totalMiles: participant?.totalTeamCommitmentInMiles ?? 0,
                                       status: currentEventStatus)
    ]]
  }

  private var currentEventStatus: String {
    guard let event = event else { return "no event data available" }
    let differenceOfDays = Calendar.current.dateComponents([.day], from: event.challengePhase.start, to: Date()).day
    if event.challengePhase.end < Date() {
      return "Event is completed!"
    } else if event.challengePhase.start < Date() {
      return "You have completed \(differenceOfDays ?? 0) days!"
    } else {
      return "You have \(String(describing: abs(differenceOfDays ?? 0))) days remaining!"
    }
  }
  
  private var activityCell: CellContext {
    if UserInfo.pedometerSource != nil {
      return ActivityCardCellContext(title: Strings.Dashboard.Activity.title,
                                     stepsData: pedometerStepsData,
                                     milesData: pedometerDistanceData,
                                     commitment: commitment,
                                     eventLengthInDays: eventLengthInDays)
    } else {
      return EmptyActivityCellContext(title: Strings.Dashboard.Activity.title,
                                      body: Strings.Dashboard.Activity.disconnected,
                                      ctaTitle: Strings.Dashboard.Activity.connect)
    }
  }
  
  private func setStepsData(_ result: Result<[PedometerData], PedometerDataProviderError>) {
    switch result {
    case .success(let data):
      pedometerStepsData = data
    case .failure(let error):
      print(error)
      pedometerStepsData = []
    }
    
    configure()
    completion?()
  }
  
  private func setDistanceData(_ result: Result<[PedometerData], PedometerDataProviderError>) {
    switch result {
    case .success(let data):
      pedometerDistanceData = data
    case .failure(let error):
      print(error)
      pedometerStepsData = []
    }
    
    configure()
    completion?()
  }

  private func getPedometerData() {
    switch UserInfo.pedometerSource {
    case .healthKit:
      healthKitDataProvider.retrieveStepCount(forInterval: eventTimeline, setStepsData)
      healthKitDataProvider.retrieveDistance(forInterval: eventTimeline, setDistanceData)
    case .fitbit:
      fitBitDataProvider.retrieveStepCount(forInterval: eventTimeline, setStepsData)
      fitBitDataProvider.retrieveDistance(forInterval: eventTimeline, setDistanceData)
    case .none:
      pedometerStepsData = []
      pedometerDistanceData = []
    }
  }
}
