
import SnapKit

class LeaderboardCell: UITableViewCell {
  var indexLabel = UILabel(.body)
  var profileImage = UIImageView()
  var nameLabel = UILabel(.body)
  var distanceLabel = UILabel(.body)
  var amountRaisedLabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([indexLabel, profileImage, nameLabel,
                 distanceLabel, amountRaisedLabel])

    indexLabel.textAlignment = .right
    indexLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.width.height.equalTo(Style.Size.s32)
      ConstraintMaker.centerY.equalToSuperview()
    }

    profileImage.layer.borderColor = Style.Colors.grey.cgColor
    profileImage.layer.borderWidth = 1
    profileImage.layer.cornerRadius = Style.Size.s32 / 2.0
    profileImage.layer.masksToBounds = true
    profileImage.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(indexLabel.snp.right)
          .offset(Style.Padding.p8)
      ConstraintMaker.height.width.equalTo(Style.Size.s32)
      ConstraintMaker.centerY.equalToSuperview()
    }

    nameLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(profileImage.snp.right)
          .offset(Style.Padding.p8)
      ConstraintMaker.centerY.equalToSuperview()
    }

    distanceLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(nameLabel.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.bottom.equalTo(nameLabel.snp.centerY)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    amountRaisedLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(nameLabel.snp.right).offset(Style.Padding.p8)
      ConstraintMaker.top.equalTo(distanceLabel.snp.bottom)
      ConstraintMaker.top.equalTo(nameLabel.snp.centerY)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }
  }
}

class TeamViewController: UIViewController {
  let teamImage = UIImageView()
  let teamName = UILabel(.header)
  let memberCount = UIButton(type: .system)

  let leaderboardLabel = UILabel(.header)
  // TODO(compnerd) should these be the same or different?
  static let ranges = [Strings.Team.thisWeek, Strings.Team.thisMonth,
                       Strings.Team.thisEvent, Strings.Team.overall]
  let rangeSelector = DropDownPickerView(data: ranges)
  let leaderboardTable = UITableView()

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
                      leaderboardLabel, rangeSelector,
                      leaderboardTable])

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

    // TODO(compnerd) make this localizable, get a better chevron
    memberCount.setTitle("\(Team.size) Members >", for: .normal)
    memberCount.contentHorizontalAlignment = .left
    memberCount.addTarget(self, action: #selector(showMembers),
                          for: .touchUpInside)
    memberCount.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(teamName.snp.bottom)
      ConstraintMaker.left.equalTo(teamImage.snp.right)
          .offset(Style.Padding.p12)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    leaderboardLabel.text = Strings.Team.leaderboard
    leaderboardLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.centerY.equalTo(rangeSelector.snp.centerY)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) make this look better ...
    rangeSelector.layer.borderColor = Style.Colors.grey.cgColor
    rangeSelector.layer.borderWidth = 1
    rangeSelector.inset =
        UIEdgeInsetsMake(0, Style.Padding.p8, 0, Style.Padding.p8)
    rangeSelector.selection = UserInfo.teamLeaderStatsRange
    rangeSelector.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(memberCount.snp.bottom)
          .offset(Style.Padding.p24)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    leaderboardTable.allowsSelection = false
    leaderboardTable.dataSource = self
    leaderboardTable.contentInset =
        UIEdgeInsetsMake(Style.Padding.p8, Style.Padding.p8, Style.Padding.p8,
                         Style.Padding.p8)
    leaderboardTable.layer.borderColor = Style.Colors.grey.cgColor
    leaderboardTable.layer.borderWidth = 1
    leaderboardTable.register(LeaderboardCell.self,
                              forCellReuseIdentifier: "LeaderboardCell")
    leaderboardTable.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(rangeSelector.snp.bottom)
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

extension TeamViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return Team.leaders.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell =
          tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell",
                                        for: indexPath)
              as? LeaderboardCell
      else { return UITableViewCell() }

    cell.indexLabel.text = "\(indexPath.row + 1)."
    if let name = Team.leaders[safe: indexPath.row] {
      cell.nameLabel.text = name
    }
    cell.distanceLabel.text = "0 miles"
    cell.amountRaisedLabel.text = "$0"

    return cell
  }
}

extension TeamViewController: ContactPickerViewControllerDelegate {
  func contactPickerSelected(friends: [String]) {
    print(friends)
  }
}

