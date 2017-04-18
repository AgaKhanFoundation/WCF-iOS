
import SnapKit

class TeamLeaderboardDataSource: LeaderBoardDataSource {
  var leaders: Array<LeaderBoardEntry> = []

  func reloadData() {
    // TODO(compnerd) fetch information from the backend
  }
}

class LeaderboardViewController: UIViewController {
  internal let dataSource: TeamLeaderboardDataSource = TeamLeaderboardDataSource()
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
      [NSForegroundColorAttributeName: Style.Colors.white]
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

