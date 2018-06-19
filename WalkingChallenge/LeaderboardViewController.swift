/**
 * Copyright © 2017 Aga Khan Foundation
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

import SnapKit

fileprivate class TeamLeaderboardDataSource: LeaderBoardDataSource {
  var leaders: [LeaderBoardEntry] = []

  func reloadData() {
    // TODO(compnerd) fetch information from the backend
  }
}

class LeaderboardViewController: UIViewController {
  fileprivate let dataSource: TeamLeaderboardDataSource =
      TeamLeaderboardDataSource()
  internal let leaderboard: LeaderBoard = LeaderBoard()

  override func viewWillAppear(_ animated: Bool) {
    dataSource.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureView()
  }

  private func configureNavigation() {
    navigationController?.navigationBar.barTintColor = Style.Colors.darkGreen
    navigationController?.navigationBar.tintColor = Style.Colors.white
    navigationController?.navigationBar.titleTextAttributes =
      [.foregroundColor: Style.Colors.white]
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.leaderboard

    view.addSubview(leaderboard)
    leaderboard.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(Style.Padding.p12)
    }
  }
}
