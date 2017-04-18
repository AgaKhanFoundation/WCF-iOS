
import UIKit
import SnapKit

class SupportersViewController: UIViewController {
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
  }
}
