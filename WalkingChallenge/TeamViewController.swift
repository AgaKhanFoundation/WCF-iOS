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

class TeamViewController: UIViewController, SelectionButtonDataSource, LeaderBoardDataSource {
  let teamImage = UIImageView()
  let teamName = UILabel(.header)
  let memberCount = UIButton(type: .system)

  // TODO(compnerd) should these be the same or different?
  static let ranges = [Strings.Team.thisWeek, Strings.Team.thisMonth,
                       Strings.Team.thisEvent, Strings.Team.overall]
  let rangeSelector = SelectionButton(type: .system)

  let leaderboardLabel = UILabel(.section)
  let leaderboard = LeaderBoard()

  var leaders: [LeaderBoardEntry] = [
  ]

  var items: [String] = TeamViewController.ranges
  var selection: Int? {
    didSet {
      if let value = selection {
        rangeSelector.setTitle(TeamViewController.ranges[safe: value], for: .normal)
      }
    }
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigationBar()
    configureView()
  }

  // MARK: - Configure

  private func configureNavigationBar() {
    navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add, target: self,
                        action: #selector(addTapped))

    navigationController?.navigationBar.barTintColor = Style.Colors.darkGreen
    navigationController?.navigationBar.tintColor = Style.Colors.white
    navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: Style.Colors.white]
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.team

    view.addSubviews([teamImage, teamName, memberCount,
                      rangeSelector,
                      leaderboardLabel, leaderboard])

    teamImage.layer.cornerRadius = Style.Size.s56 / 2
    teamImage.layer.masksToBounds = true
    teamImage.layer.borderColor = Style.Colors.grey.cgColor
    teamImage.layer.borderWidth = 1
    teamImage.snp.makeConstraints { (make) in
      make.top.equalTo(topLayoutGuide.snp.bottom)
          .offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.height.width.equalTo(Style.Size.s56)
    }

    teamName.text = Team.name
    teamName.textAlignment = .left
    teamName.snp.makeConstraints { (make) in
      make.top.equalTo(teamImage.snp.top)
      make.left.equalTo(teamImage.snp.right)
          .offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) make this localizable
    memberCount.setTitle("\(Team.size) Members \u{203a}", for: .normal)
    memberCount.contentHorizontalAlignment = .left
    memberCount.addTarget(self, action: #selector(showMembers),
                          for: .touchUpInside)
    memberCount.snp.makeConstraints { (make) in
      make.top.equalTo(teamName.snp.bottom)
      make.left.equalTo(teamImage.snp.right)
          .offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }

    rangeSelector.dataSource = self
    rangeSelector.delegate = self
    rangeSelector.selection = UserInfo.teamLeaderStatsRange
    rangeSelector.snp.makeConstraints { (make) in
      make.top.equalTo(memberCount.snp.bottom)
          .offset(Style.Padding.p24)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }

    leaderboardLabel.text = Strings.Team.leaderboard
    leaderboardLabel.snp.makeConstraints { (make) in
      make.top.equalTo(rangeSelector.snp.bottom)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }

    leaderboard.data = self
    leaderboard.snp.makeConstraints { (make) in
      make.top.equalTo(leaderboardLabel.snp.bottom)
          .offset(Style.Padding.p8)
      make.bottom.equalTo(bottomLayoutGuide.snp.top)
          .offset(-Style.Padding.p12)
      make.leading.trailing.equalToSuperview()
          .inset(Style.Padding.p12)
    }
  }

  // MARK: - Actions

  func addTapped() {
    let contactPickerVC = ContactPickerViewController()
    contactPickerVC.delegate = self
    let picker = UINavigationController(rootViewController: contactPickerVC)
    present(picker, animated: true, completion: nil)
  }

  func showMembers() {
    let members = TeamMembersViewController()
    navigationController?.pushViewController(members, animated: true)
  }
}

extension TeamViewController: ContactPickerViewControllerDelegate {
  func contactPickerSelected(friends: [String]) {
    print(friends)
  }
}

extension TeamViewController: SelectionButtonDelegate {
}
