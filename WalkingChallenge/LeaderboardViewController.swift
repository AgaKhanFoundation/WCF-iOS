
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
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.leaderboard

    view.addSubview(leaderboard)
    leaderboard.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.edges.equalToSuperview().inset(Style.Padding.p12)
    }
  }
}

