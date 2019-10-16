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
  var facebookService = FacebookService.shared
  var disposeBag = DisposeBag()
  var cells = [[CellContext]]()
  var completion: (() -> Void)?

  private var name: String = " "
  private var imageURL: URL?
  private var teamName: String = " "
  private var eventName: String = " "
  private var eventTimeline: String = " "

  enum DashboardContext: Context {
    case inviteSupporters
  }

  init() {
    let update = Observable.combineLatest(
      cache.facebookNamesRelay,
      cache.facebookProfileImageURLsRelay,
      cache.participantRelay)

    update.subscribeOnNext { [weak self] (names, imageURLs, participant) in
      self?.name = names["me"] ?? " "
      self?.imageURL = imageURLs["me"]
      self?.teamName = participant?.team?.name ?? " "
      if let event = participant?.currentEvent {
        self?.eventName = event.name
        self?.eventTimeline = DataFormatters
          .formatDateRange(value: (start: event.challengePhase.start, end: event.challengePhase.end))
      }
      self?.configure()
      self?.completion?()
    }.disposed(by: disposeBag)
  }

  func reload(completion: @escaping () -> Void) {
    self.completion = completion
    self.name = " "
    self.imageURL = nil
    self.teamName = " "
    self.eventName = " "
    self.eventTimeline = " "

    configure()
    completion()

    facebookService.getRealName(fbid: "me")
    facebookService.getProfileImageURL(fbid: "me")
    AKFCausesService.getParticipant(fbid: facebookService.id) { [weak self] (result) in
      self?.cache.participantRelay.accept(Participant(json: result.response))
    }
  }

  func configure() {
    var activityCellContext: CellContext =
        EmptyActivityCellContext(title: Strings.Dashboard.Activity.title,
                                 body: Strings.Dashboard.Activity.disconnected,
                                 ctaTitle: Strings.Dashboard.Activity.connect)
    if UserInfo.pedometerSource != nil {
      activityCellContext =
        InfoCellContext(
          title: Strings.Dashboard.Activity.title,
          body: Strings.Dashboard.ChallengeProgress.unavailable)
    }

    cells = [[
      ProfileCardCellContext(
        imageURL: imageURL,
        name: name,
        teamName: teamName,
        eventName: eventName,
        eventTimeline: eventTimeline,
        disclosureLabel: Strings.Dashboard.badges),
      activityCellContext,
      InfoCellContext(
        title: Strings.Dashboard.ChallengeProgress.title,
        body: Strings.Dashboard.ChallengeProgress.unavailable),
      DisclosureCellContext(
        title: Strings.Dashboard.FundraisingProgress.title,
        body: Strings.Dashboard.FundraisingProgress.unavailable,
        disclosureTitle: Strings.Dashboard.FundraisingProgress.invite,
        context: DashboardContext.inviteSupporters)
    ]]
  }
}
