
import SnapKit

class TeamViewController: UIViewController {
  let teamImage = UIImageView()
  let teamName = UILabel(.header)
  let memberCount = UILabel(.body)

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigationBar()
    configureView()
  }

  // MARK: - Configure

  private func configureNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.team

    view.addSubviews([teamImage, teamName, memberCount])

    teamImage.layer.cornerRadius = Style.Size.s56 / 2
    teamImage.layer.masksToBounds = true
    teamImage.layer.borderColor = Style.Colors.grey.cgColor
    teamImage.layer.borderWidth = 1
    teamImage.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(topLayoutGuide.snp.bottom).offset(Style.Padding.p12)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.height.width.equalTo(Style.Size.s56)
    }

    teamName.text = Team.name
    teamName.textAlignment = .left
    teamName.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(teamImage.snp.top)
      ConstraintMaker.left.equalTo(teamImage.snp.right).offset(Style.Padding.p12)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }

    // TODO(compnerd) make this localizable, get a better chevron
    memberCount.text = "\(Team.size) Members >"
    memberCount.textAlignment = .left
    memberCount.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(teamName.snp.bottom).offset(Style.Padding.p8)
      ConstraintMaker.left.equalTo(teamImage.snp.right).offset(Style.Padding.p12)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
    }
  }

  // MARK: - Actions

  func addTapped() {
    let picker = UINavigationController(rootViewController: ContactPicker())
    self.present(picker, animated: true, completion: nil)
  }
}

