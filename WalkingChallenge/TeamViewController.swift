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
import FacebookCore

fileprivate class StatisticsRangeDataSource: SelectionButtonDataSource {
  // TODO(compnerd) should these be the same or different?
  static let ranges = [Strings.Profile.thisWeek, Strings.Profile.thisMonth,
                       Strings.Profile.thisEvent, Strings.Profile.overall]

  var items: [String] = StatisticsRangeDataSource.ranges
  var selection: Int?
}

fileprivate class TeamLeaderboardDataSource: LeaderBoardDataSource {
  private let team: Team

  init(team: Team) {
    self.team = team
  }

  var leaders: [LeaderBoardEntry] {
    var standing: Int = 1
    var result: [LeaderBoardEntry] = []

    // TODO(compnerd) sort members according to distance, ramount raised? magic?
    for member in team.members {
      Facebook.profileImage(for: member.fbid) { (url: URL?) in
        Facebook.getRealName(for: member.fbid) { (name: String?) in
          // FIXME(compnerd) model and display distance and amount raised
          result.append(LeaderBoardEntry(imageURL: url ?? nil,
                                         name: name ?? member.fbid,
                                         standing: standing,
                                         distance: 0, raised: 0))
        }
      }

      standing += 1
    }

    return result
  }
}

class TeamViewController: UIViewController {
  fileprivate var leaderboardDataSource: TeamLeaderboardDataSource?
  fileprivate let statisticsRangeDataSource: StatisticsRangeDataSource =
      StatisticsRangeDataSource()

  let imgTeamImage: UIImageView = UIImageView()
  let lblTeamName: UILabel = UILabel(.header)
  let btnTeamMembers: UIButton = UIButton(type: .system)

  let lblRaisedSymbol: UILabel = UILabel()
  let lblRaisedAmount: UILabel = UILabel(.header)
  let prgProgress: ProgressRing = ProgressRing(radius: 64.0, width: 16.0)
  let lblAchievementsSymbol: UILabel = UILabel()
  let lblAchievements: UILabel = UILabel(.header)
  let lblAchievementsUnits: UILabel = UILabel(.caption)

  let btnStatisticsRange: SelectionButton = SelectionButton(type: .system)
  let lblLeaderboardTitle: UILabel = UILabel(.section)
  let tblLeaderboard: LeaderBoard = LeaderBoard()

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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
      [.foregroundColor: Style.Colors.white]
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
    lblTeamName.snp.makeConstraints { (make) in
      make.bottom.equalTo(imgTeamImage.snp.centerY)
      make.left.equalTo(imgTeamImage.snp.right).offset(Style.Padding.p12)
    }

    view.addSubview(btnTeamMembers)
    btnTeamMembers.contentHorizontalAlignment = .left
    btnTeamMembers.addTarget(self, action: #selector(showMembers),
                             for: .touchUpInside)
    btnTeamMembers.snp.makeConstraints { (make) in
      make.top.equalTo(imgTeamImage.snp.centerY)
      make.left.equalTo(imgTeamImage.snp.right).offset(Style.Padding.p12)
    }
  }

  private func configureTeamStatistics(_ top: inout ConstraintRelatableTarget) {
    view.addSubviews([lblRaisedSymbol, lblRaisedAmount])

    lblRaisedSymbol.text =
        "\(String(describing: Locale.current.currencySymbol!))"
    lblRaisedSymbol.textColor = Style.Colors.green
    lblRaisedSymbol.font = UIFont.boldSystemFont(ofSize: 32.0)
    lblRaisedSymbol.snp.makeConstraints { (make) in
      make.centerY.equalTo(lblRaisedAmount.snp.centerY)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) calculate this properly
    lblRaisedAmount.text = "2073.30"
    lblRaisedAmount.snp.makeConstraints { (make) in
      make.centerY.equalTo(lblRaisedSymbol.snp.centerY)
      make.left.equalTo(lblRaisedSymbol.snp.right).offset(Style.Padding.p8)
    }

    view.addSubview(prgProgress)
    prgProgress.summary =
        ProgressRingSummaryDistance(value: 900, max: 1200, units: "miles")
    prgProgress.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalTo(lblRaisedAmount.snp.centerY)
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.size.equalTo(Style.Size.s128)
    }

    view.addSubviews([lblAchievementsSymbol, lblAchievements,
                      lblAchievementsUnits])

    lblAchievementsSymbol.text = "\u{1f3c6}" // :trophy:
    lblAchievementsSymbol.font = UIFont.systemFont(ofSize: 32.0)
    lblAchievementsSymbol.snp.makeConstraints { (make) in
      make.centerY.equalTo(prgProgress.snp.centerY)
      make.right.equalTo(lblAchievements.snp.left).offset(-Style.Padding.p8)
    }

    // TODO(compnerd) calculate this properly
    lblAchievements.text = "12/30"
    lblAchievements.snp.makeConstraints { (make) in
      make.top.equalTo(lblAchievementsSymbol.snp.top)
      make.bottom.equalTo(lblAchievementsUnits.snp.top)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalTo(lblAchievementsUnits.snp.left)
    }
    // FIXME(compnerd) localise this properly
    lblAchievementsUnits.text = "milestones"
    lblAchievementsUnits.snp.makeConstraints { (make) in
      make.bottom.equalTo(lblAchievementsSymbol.snp.bottom)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }

    top = prgProgress.snp.bottom
  }

  private func configureTeamLeaderboard(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(btnStatisticsRange)
    btnStatisticsRange.dataSource = statisticsRangeDataSource
    btnStatisticsRange.delegate = self
    btnStatisticsRange.selection = UserInfo.teamLeaderStatsRange
    btnStatisticsRange.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }
    top = btnStatisticsRange.snp.bottom

    view.addSubview(lblLeaderboardTitle)
    lblLeaderboardTitle.text = Strings.Team.leaderboard
    lblLeaderboardTitle.snp.makeConstraints { (make) in
      make.top.equalTo(top)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblLeaderboardTitle.snp.bottom

    view.addSubview(tblLeaderboard)
    tblLeaderboard.data = leaderboardDataSource
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

    AKFCausesService.getParticipant(fbid: Facebook.id) { [weak self] (result) in
      switch result {
      case .success(_, let response):
        guard let response = response else { return }
        if let participant = Participant(json: response) {
          if let team = participant.team {
            self?.lblTeamName.text = team.name
            // TODO(compnerd) make this localizable
            self?.btnTeamMembers.setTitle("\(team.members.count) Members \u{203a}",
                                          for: .normal)
            self?.leaderboardDataSource =
                TeamLeaderboardDataSource(team: team)
          }
        }
      case .failed(let error):
        print("unable to get participant \(String(describing: error?.localizedDescription))")
      }
    }
  }

  // MARK: - Actions

  @objc func addTapped() {
  }

  @objc func showMembers() {
    navigationController?.pushViewController(TeamMembersViewController(),
                                             animated: true)
  }
}

extension TeamViewController: SelectionButtonDelegate {
}
