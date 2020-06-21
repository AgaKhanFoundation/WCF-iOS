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

class NotificationsViewController: TableViewController {
  override func commonInit() {
    super.commonInit()

    title = Strings.Notifications.title
    dataSource = NotificationsDataSource()
  }
}

class NotificationsDataSource: TableViewDataSource {
  let cache = Cache.shared
  var cells: [[CellContext]] = []
  var disposeBag = DisposeBag()
  
  init() {
    
    cache.participantRelay.subscribeOnNext { [weak self] (participant: Participant?) in
      guard let fbId = participant?.fbid, let eventId = participant?.currentEvent?.id else { return }
      
      AKFCausesService.getNotifications(fbId: fbId, eventId: eventId) { (result) in
        print(result)
        dump(self)
      }
    }.disposed(by: disposeBag)
    
  }
  
  func configure() {
    cells = [[]]
  }
  
  private func testData() -> [NotificationCellInfo] {
    [
      NotificationCellInfo(title: "FirstName LastName has joined your team",
                           date: Date(), isRead: false, isFirst: true),
      NotificationCellInfo(title: "You have been removed from [Team Name] Team.",
                           date: Date(timeIntervalSinceNow: -10*60), isRead: false),
      NotificationCellInfo(title: "Challenge [name of challenge] has ended.",
                           date: Date(timeIntervalSinceNow: -1*60*60)),
      NotificationCellInfo(title: "FirstName LastName has joined the team.",
                           date: Date(timeIntervalSinceNow: -1*24*60*60)),
      NotificationCellInfo(title: "Abigal Gates is going to Nike run club with 80 others.",
                           date: Date(timeIntervalSinceNow: -7*24*60*60)),
      NotificationCellInfo(title: "Last notification from long ago",
                           date: Date(timeIntervalSinceNow: -35*24*60*60)),
      NotificationCellInfo(title: "Notification from so long ago",
                           date: Date(timeIntervalSinceNow: -100*24*60*60), isLast: true)
    ]
  }
}
