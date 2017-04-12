
import SnapKit

class LeaderboardViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.leaderboard
  }
}

