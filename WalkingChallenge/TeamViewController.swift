
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

  var leaders: Array<LeaderBoardEntry> = [
  ]

  var items: Array<String> = TeamViewController.ranges
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
    teamImage.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(topLayoutGuide.snp.bottom)
          .offset(Style.Padding.p12)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.height.width.equalTo(Style.Size.s56)
    }

    teamName.text = Team.name
    teamName.textAlignment = .left
    teamName.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(teamImage.snp.top)
      ConstraintMaker.left.equalTo(teamImage.snp.right)
          .offset(Style.Padding.p12)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) make this localizable
    memberCount.setTitle("\(Team.size) Members \u{203a}", for: .normal)
    memberCount.contentHorizontalAlignment = .left
    memberCount.addTarget(self, action: #selector(showMembers),
                          for: .touchUpInside)
    memberCount.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(teamName.snp.bottom)
      ConstraintMaker.left.equalTo(teamImage.snp.right)
          .offset(Style.Padding.p12)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    rangeSelector.dataSource = self
    rangeSelector.delegate = self
    rangeSelector.selection = UserInfo.teamLeaderStatsRange
    rangeSelector.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(memberCount.snp.bottom)
          .offset(Style.Padding.p24)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    leaderboardLabel.text = Strings.Team.leaderboard
    leaderboardLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(rangeSelector.snp.bottom)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
    }

    leaderboard.data = self
    leaderboard.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(leaderboardLabel.snp.bottom)
          .offset(Style.Padding.p8)
      ConstraintMaker.bottom.equalTo(bottomLayoutGuide.snp.top)
          .offset(-Style.Padding.p12)
      ConstraintMaker.leading.trailing.equalToSuperview()
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
    let memberListVC = TeamMembersViewController()
    let memberList = UINavigationController(rootViewController: memberListVC)
    present(memberList, animated: true, completion: nil)
  }
}

extension TeamViewController: ContactPickerViewControllerDelegate {
  func contactPickerSelected(friends: [String]) {
    print(friends)
  }
}

extension TeamViewController: SelectionButtonDelegate {
}


