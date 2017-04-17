
import SnapKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
  let titleLabel = UILabel(.header)
  let desciptionLabel = UILabel(.body)
  let loginButton = FBSDKLoginButton()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureLabels()
    configureButton()
    configureView()
  }

  // MARK: - Configure

  private func configureLabels() {
    titleLabel.text = Strings.Login.title
    desciptionLabel.text = Strings.Login.desciption

    titleLabel.textAlignment = .center
    desciptionLabel.textAlignment = .center
  }

  private func configureButton() {
    loginButton.delegate = self
    loginButton.readPermissions = [
      "public_profile", "email", "user_friends", "user_location"
    ]
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    view.addSubviews([titleLabel, desciptionLabel, loginButton])

    titleLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.centerY.equalToSuperview().offset(-Style.Padding.p48)
    }

    desciptionLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p24)
    }

    loginButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(desciptionLabel.snp.bottom).offset(Style.Padding.p24)
    }
  }
}

// MARK: - FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
  func loginButton(_ loginButton: FBSDKLoginButton!,
                   didCompleteWith result: FBSDKLoginManagerLoginResult!,
                   error: Error!) {
    guard error == nil else {
      alert(message: "Error logging in: \(error)", style: .cancel)
      return
    }
    
    if(FBSDKAccessToken.current() == nil){
      return;
      
    } else{
      AppController.shared.login()
    }
  }

  func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    // Left blank on purpose since the user shouldn't be logged in on this view
    // controller
  }
}

