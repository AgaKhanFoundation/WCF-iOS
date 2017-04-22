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

fileprivate class StatisticsRangeDataSource: SelectionButtonDataSource {
  // TODO(compnerd) should these be the same or different?
  static let ranges = [Strings.Profile.thisWeek, Strings.Profile.thisMonth,
                       Strings.Profile.thisEvent, Strings.Profile.overall]

  var items: [String] = StatisticsRangeDataSource.ranges
  var selection: Int?
}

class TeamViewController: UIViewController, LeaderBoardDataSource {
  fileprivate let statisticsRangeDataSource: StatisticsRangeDataSource =
      StatisticsRangeDataSource()

  let imgTeamImage: UIImageView = UIImageView()
  let lblTeamName: UILabel = UILabel(.header)
  let btnTeamMembers: UIButton = UIButton(type: .system)

  let btnStatisticsRange: SelectionButton = SelectionButton(type: .system)
  let lblRaisedSymbol: UILabel = UILabel()
  let lblRaisedAmount: UILabel = UILabel(.header)
  let lblAcchievementsSymbol: UILabel = UILabel()
  let lblAcchievements: UILabel = UILabel(.header)
  let lblAcchievementsUnits: UILabel = UILabel(.caption)

  let lblLeaderboardTitle: UILabel = UILabel(.section)
  let tblLeaderboard: LeaderBoard = LeaderBoard()

  // TODO(compnerd) provide a separate dataSource for the leadrboard by sorting
  // team member entries
  var leaders: [LeaderBoardEntry] = [
  ]

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigationBar()
    configureView()
  }

  // MARK: - Configure

  private func configureNavigationBar() {
    title = Strings.NavBarTitles.team

    navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add, target: self,
                        action: #selector(addTapped))

    navigationController?.navigationBar.barTintColor = Style.Colors.darkGreen
    navigationController?.navigationBar.tintColor = Style.Colors.white
    navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: Style.Colors.white]
  }

  private func configureTeamHeader(_ top: inout ConstraintRelatableTarget) {
    // FIXME(compnerd) get this value programatically
    view.addSubview(imgTeamImage)
    imgTeamImage.layer.cornerRadius = Style.Size.s56 / 2
    imgTeamImage.layer.masksToBounds = true
    imgTeamImage.layer.borderColor = Style.Colors.grey.cgColor
    imgTeamImage.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.height.width.equalTo(Style.Size.s56)
    }
    top = imgTeamImage.snp.bottom

    // TODO(compnerd) use a placeholder instead of the filled bordered area
    imgTeamImage.layer.borderWidth = 1
    imgTeamImage.layer.backgroundColor = Style.Colors.grey.cgColor

    view.addSubview(lblTeamName)
    lblTeamName.text = Team.name
    lblTeamName.snp.makeConstraints { (make) in
      make.bottom.equalTo(imgTeamImage.snp.centerY)
      make.left.equalTo(imgTeamImage.snp.right).offset(Style.Padding.p12)
    }

    // TODO(compnerd) make this localizable
    view.addSubview(btnTeamMembers)
    btnTeamMembers.setTitle("\(Team.size) Members \u{203a}", for: .normal)
    btnTeamMembers.contentHorizontalAlignment = .left
    btnTeamMembers.addTarget(self, action: #selector(showMembers),
                             for: .touchUpInside)
    btnTeamMembers.snp.makeConstraints { (make) in
      make.top.equalTo(imgTeamImage.snp.centerY)
      make.left.equalTo(imgTeamImage.snp.right).offset(Style.Padding.p12)
    }
  }

  private func configureTeamStatistics(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(btnStatisticsRange)
    btnStatisticsRange.dataSource = statisticsRangeDataSource
    btnStatisticsRange.delegate = self
    btnStatisticsRange.selection = UserInfo.teamLeaderStatsRange
    btnStatisticsRange.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p24)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }
    top = btnStatisticsRange.snp.bottom

    view.addSubview(lblRaisedSymbol)
    lblRaisedSymbol.text =
        "\(String(describing: Locale.current.currencySymbol!))"
    lblRaisedSymbol.textColor = Style.Colors.green
    lblRaisedSymbol.font = UIFont.boldSystemFont(ofSize: 32.0)
    lblRaisedSymbol.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblRaisedSymbol.snp.bottom

    view.addSubview(lblRaisedAmount)
    // TODO(compnerd) calculate this properly
    lblRaisedAmount.text = "2073.30"
    lblRaisedAmount.snp.makeConstraints { (make) in
      make.centerY.equalTo(lblRaisedSymbol.snp.centerY)
      make.left.equalTo(lblRaisedSymbol.snp.right).offset(Style.Padding.p8)
    }

    view.addSubviews([lblAcchievementsSymbol, lblAcchievements,
                      lblAcchievementsUnits])

    lblAcchievementsSymbol.text = "\u{1f3c6}" // :trophy:
    lblAcchievementsSymbol.font = UIFont.systemFont(ofSize: 32.0)
    lblAcchievementsSymbol.snp.makeConstraints { (make) in
      make.top.equalTo(btnStatisticsRange.snp.bottom).offset(Style.Padding.p8)
      make.right.equalTo(lblAcchievements.snp.left).offset(-Style.Padding.p8)
    }

    // TODO(compnerd) calculate this properly
    lblAcchievements.text = "12/30"
    lblAcchievements.snp.makeConstraints { (make) in
      make.top.equalTo(btnStatisticsRange.snp.bottom).offset(Style.Padding.p8)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalTo(lblAcchievementsUnits.snp.left)
    }
    // FIXME(compnerd) localise this properly
    lblAcchievementsUnits.text = "milestones"
    lblAcchievementsUnits.snp.makeConstraints { (make) in
      make.top.equalTo(lblAcchievements.snp.bottom)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }
  }

  private func configureTeamLeaderboard(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(lblLeaderboardTitle)
    lblLeaderboardTitle.text = Strings.Team.leaderboard
    lblLeaderboardTitle.snp.makeConstraints { (make) in
      make.top.equalTo(top)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblLeaderboardTitle.snp.bottom

    view.addSubview(tblLeaderboard)
    tblLeaderboard.data = self
    tblLeaderboard.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = tblLeaderboard.snp.bottom
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureTeamHeader(&top)
    configureTeamStatistics(&top)
    configureTeamLeaderboard(&top)
  }

  // MARK: - Actions

  func addTapped() {
    let picker: ContactPickerViewController = ContactPickerViewController()
    picker.delegate = self

    present(UINavigationController(rootViewController: picker), animated: true,
            completion: nil)
  }

  func showMembers() {
    navigationController?.pushViewController(TeamMembersViewController(),
                                             animated: true)
  }
}

extension TeamViewController: ContactPickerViewControllerDelegate {
  func contactPickerSelected(friends: [String]) {
    print(friends)
  }
}

extension TeamViewController: SelectionButtonDelegate {
}
