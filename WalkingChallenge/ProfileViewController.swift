
import SnapKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {
  let dataSource = ProfileDataSource()

  // Views
  let profileImage = UIImageView()
  let nameLabel = UILabel(.header)
  let teamLabel = UILabel(.title)
  let logoutButton = FBSDKLoginButton()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    updateProfile()
    onBackground {
      Facebook.profileImage(for: "me") { [weak self] (url) in
        guard (url != nil) else { return }

        let data = try? Data(contentsOf: url!)
        onMain { self?.profileImage.image = UIImage(data: data!) }
      }
    }
  }

  // MARK: - Configure

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.profile
    logoutButton.delegate = self

    view.addSubviews([profileImage, nameLabel, teamLabel])

    profileImage.contentMode = .scaleAspectFill
    profileImage.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(topLayoutGuide.snp.bottom).offset(Style.Padding.p12)
      ConstraintMaker.size.equalTo(Style.Size.s128)
      ConstraintMaker.centerX.equalToSuperview()
    }

    nameLabel.textAlignment = .center
    nameLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(profileImage.snp.bottom).offset(Style.Padding.p12)
      ConstraintMaker.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }

    teamLabel.textAlignment = .center
    teamLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(nameLabel.snp.bottom).offset(Style.Padding.p12)
      ConstraintMaker.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) move this to settings view
    view.addSubview(logoutButton)
    logoutButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-Style.Padding.p12)
    }
  }

  private func updateProfile() {
    dataSource.updateProfile { [weak self] (success: Bool) in
      guard success else {
        self?.alert(message: "Error loading profile")
        return
      }

      self?.nameLabel.text = self?.dataSource.realName
      self?.teamLabel.text = Team.name
    }
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

