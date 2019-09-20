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

class ChallengeViewController: TableViewController {
  override func commonInit() {
    super.commonInit()

    title = Strings.Challenge.title
    dataSource = ChallengeDataSource()
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    if let cell = cell as? TeamNeededCell {
      cell.delegate = self
    }
  }
}

extension ChallengeViewController: TeamNeededCellDelegate {
  func teamNeededCellPrimaryTapped() {
    present(NavigationController(rootVC: CreateTeamViewController()), animated: true, completion: nil)
  }

  func teamNeededCellSecondaryTapped() {
    present(NavigationController(rootVC: JoinTeamViewController()), animated: true, completion: nil)
  }
}

class ChallengeDataSource: TableViewDataSource {
  var cells: [[CellContext]] = []
  
  private var participant: Participant?
  
  func reload(completion: @escaping () -> Void) {
    configure()
    completion()
    
    AKFCausesService.getParticipant(fbid: Facebook.id) { [weak self] (result) in
      self?.participant = Participant(json: result.response)
      self?.configure()
      completion()
    }
  }
  
  func configure() {
    cells.removeAll()
    
    if participant?.team == nil {
      cells.append([
        TeamNeededCellContext(
          title: Strings.Challenge.TeamNeededCard.title,
          body: Strings.Challenge.TeamNeededCard.body,
          primaryButtonTitle: Strings.Challenge.TeamNeededCard.primaryButton,
          secondaryButtonTitle: Strings.Challenge.TeamNeededCard.secondaryButton)
        ])
    }
  }
}
