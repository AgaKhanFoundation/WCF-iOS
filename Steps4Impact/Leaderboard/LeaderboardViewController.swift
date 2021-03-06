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

class LeaderboardViewController: TableViewController {

  var isListCollapsed = true
  var myTeamId: Int?

  override func commonInit() {
    super.commonInit()
    dataSource = LeaderboardDataSource()
    _ = NotificationCenter.default.addObserver(forName: .teamChanged,
                                               object: nil, queue: nil) { [weak self] (_) in
                                                self?.reload()
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.Leaderboard.title
    view.backgroundColor = .white
    tableView.backgroundColor = .white
  }

  override func reload() {
    dataSource?.reload { [weak self] in
      self?.tableView.reloadOnMain()
    }
  }
}

extension LeaderboardViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 2, indexPath.row == 0 {
      let sections = IndexSet.init(integer: indexPath.section)
      if isListCollapsed {
        // Expand the list
        isListCollapsed = false
        guard let dataSource = dataSource as? LeaderboardDataSource else { return }
        dataSource.cells[2] = dataSource.expandListDataSource
        tableView.reloadSections(sections, with: .fade)
      } else {
        // Collapse the list
        isListCollapsed = true
        dataSource?.cells[2] = [ExpandCollapseCellContext()]
        tableView.reloadSections(sections, with: .fade)
      }
    }
  }
}
