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

class DashboardDataSource: TableViewDataSource {
  var cells = [[CellContext]]()

  private var name: String?
  private var image: UIImage?

  func reload(completion: @escaping GenericBlock) {
    configureCells()
    completion()

    onBackground { [weak self] in
      Facebook.profileImage(for: "me") { (url) in
        guard
          let url = url,
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data)
        else { return }

        self?.image = image
        self?.configureCells()
        completion()
      }
    }

    onBackground { [weak self] in
      Facebook.getRealName(for: "me") { (name) in
        self?.name = name ?? "Could not load"
        self?.configureCells()
        completion()
      }
    }
  }

  func configureCells() {
    cells = [[
      ProfileCardCellContext(
        image: image,
        name: name ?? "Loading...",
        teamName: "Team: Global Walkers",
        eventName: "AKF Spring 2019",
        eventTimeline: "Current Challenge",
        disclosureLabel: "View Badges"),
      EmptyActivityCellContext(
        title: "Activity",
        body: "No activity yet. You will need to connect a fitness tracker to track your miles",
        ctaTitle: "Connect an App or Device"),
      InfoCellContext(
        title: "Challenge Progress",
        body: "No data available. You will be able to see your team's progress once the challenge has started"),
      DisclosureCellContext(
        title: "Fundraising Progress",
        body: "No data available. You will be able to see your progress once the challenge has started.",
        disclosureTitle: "Invite supporters to pledge",
        context: nil)
    ]]
  }
}
