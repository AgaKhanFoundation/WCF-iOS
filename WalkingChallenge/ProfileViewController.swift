
import SnapKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {
  let dataSource = ProfileDataSource()

  // Views
  let nameLabel = UILabel(.header)
  let teamLabel = UILabel(.body)
  let teamNameLabel = UILabel(.title)
  let logoutButton = FBSDKLoginButton()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    updateProfile()
  }

  // MARK: - Configure

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.profile
    logoutButton.delegate = self

    view.addSubviews([nameLabel, teamLabel, teamNameLabel, logoutButton])

    nameLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(topLayoutGuide.snp.bottom).offset(Style.Padding.p12)
    }

    teamLabel.text = "My Team"
    teamLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(nameLabel.snp.bottom).offset(Style.Padding.p12)
    }
    teamNameLabel.snp.makeConstraints { (make) in
      make.rightMargin.equalTo(-Style.Padding.p12)
      make.top.equalTo(nameLabel.snp.bottom).offset(Style.Padding.p12)
    }

    logoutButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-Style.Padding.p12)
    }
  }

  private func updateProfile() {
    dataSource.updateProfile { [weak self] (success: Bool) in
      if success {
        self?.nameLabel.text = self?.dataSource.realName
        self?.teamNameLabel.text = self?.dataSource.teamName
      } else {
        self?.presentErrorAlert()
      }
    }
  }

  // Error

  private func presentErrorAlert() {
    let alertVC = UIAlertController(title: "Error",
                                    message: "Error loading profile",
                                    preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    present(alertVC, animated: true, completion: nil)
  }
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    AppController.shared.logout()
  }

  func loginButton(_ loginButton: FBSDKLoginButton!,
                   didCompleteWith result: FBSDKLoginManagerLoginResult!,
                   error: Error!) {
    // Left blank because the user should be logged in when reaching this point
  }
}

