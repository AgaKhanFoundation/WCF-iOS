
import SnapKit
import FBSDKLoginKit

class ConfigurationViewController: UIViewController {
  let logoutButton = FBSDKLoginButton()
  let deviceLabel = UILabel(.header)

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureView()
  }

  private func configureNavigation() {
    navigationItem.leftBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .done, target: self,
                        action: #selector(dismissView))
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.configuration

    view.addSubview(deviceLabel)
    deviceLabel.text = Strings.Configuration.device
    deviceLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.left.right.equalToSuperview().inset(Style.Padding.p12)
    }

    view.addSubview(logoutButton)
    logoutButton.delegate = self
    logoutButton.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.centerX.equalToSuperview()
      ConstraintMaker.bottom.equalTo(bottomLayoutGuide.snp.top)
          .offset(-Style.Padding.p12)
    }
  }

  func dismissView() {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

extension ConfigurationViewController: FBSDKLoginButtonDelegate {
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    AppController.shared.logout()
  }

  func loginButton(_ loginButton: FBSDKLoginButton!,
                   didCompleteWith result: FBSDKLoginManagerLoginResult!,
                   error: Error!) {
    // Left blank because the user should be logged in when reaching this point
  }
}

