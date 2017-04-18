
import SnapKit

struct TeamMemberCount: CellInfo {
  var cellIdentifier: String = TeamMemberCountCell.identifier

  var count: Int

  init(count: Int) {
    self.count = count
  }
}

class TeamMemberCountCell: UITableViewCell, IdentifiedUITableViewCell {
  static var identifier: String = "TeamMemberCountCell"

  let label: UILabel = UILabel(.header)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    contentView.addSubview(label)
    backgroundColor = .clear

    label.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(Style.Padding.p12)
    }
  }
}

extension TeamMemberCountCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let info = data as? TeamMemberCount else { return }
    // TODO(compnerd) make this localisable
    label.text = "Members (\(info.count))"
  }
}

struct TeamMember: CellInfo {
  var cellIdentifier: String = TeamMemberCell.identifier

  let name: String
  let picture: URL?

  init(name: String, picture: URL? = nil) {
    self.name = name
    self.picture = picture
  }
}

class TeamMemberCell: UITableViewCell, IdentifiedUITableViewCell {
  static var identifier: String = "TeamMemberCell"

  let pictureView = UIImageView()
  let nameLabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    contentView.addSubviews([pictureView, nameLabel])
    backgroundColor = .clear

    pictureView.layer.borderColor = Style.Colors.grey.cgColor
    pictureView.layer.borderWidth = 1
    pictureView.layer.cornerRadius = Style.Size.s32 / 2
    pictureView.layer.masksToBounds = true
    pictureView.snp.makeConstraints { (make) in
      make.height.width.equalTo(Style.Size.s32)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.centerY.equalToSuperview()
    }

    nameLabel.snp.makeConstraints { (make) in
      make.left.equalTo(pictureView.snp.right)
          .offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.centerY.equalTo(pictureView.snp.centerY)
    }
  }
}

extension TeamMemberCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let info = data as? TeamMember else { return }
    nameLabel.text = info.name
  }
}

class TeamMembersDataSource: NSObject {
  // TODO(compnerd) fetch this from the backend
  let members = [TeamMember(name: "Member 1"), TeamMember(name: "Member 2"),
                 TeamMember(name: "Member 3"), TeamMember(name: "Member 4"),
                 TeamMember(name: "Member 5"), TeamMember(name: "Member 6"),
                 TeamMember(name: "Member 7")]

  var cells: [CellInfo]

  override init() {
    self.cells = [TeamMemberCount(count: members.count)] + members
    super.init()
  }
}

extension TeamMembersDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }

  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let info = cells[safe: indexPath.row],
      let cell =
          tableView.dequeueReusableCell(withIdentifier: info.cellIdentifier,
                                        for: indexPath)
              as? ConfigurableUITableViewCell
    else { return UITableViewCell() }
    
    cell.configure(info)
    //TODO: Sami fix this using CellInfo pattern
    if let cell = cell as? UITableViewCell {
      if indexPath.row == 0 {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
      }
      
      return cell
    } else {
      return UITableViewCell()
    }
  }
}

class TeamMembersViewController: UIViewController {
  let tableView = UITableView()
  let inviteButton = UIButton(type: .system)

  let teamMembersDataSource = TeamMembersDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
    configureNavigation()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    view.addSubviews([tableView, inviteButton])

    tableView.allowsSelection = false
    tableView.dataSource = teamMembersDataSource
    tableView.register(TeamMemberCountCell.self,
                       forCellReuseIdentifier: TeamMemberCountCell.identifier)
    tableView.register(TeamMemberCell.self,
                       forCellReuseIdentifier: TeamMemberCell.identifier)
    tableView.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview()
          .inset(Style.Padding.p12)
      make.top.equalToSuperview().inset(Style.Padding.p12)
    }

    inviteButton.contentEdgeInsets =
        UIEdgeInsetsMake(Style.Padding.p8, Style.Padding.p8, Style.Padding.p8,
                         Style.Padding.p8)
    inviteButton.layer.borderWidth = 1
    inviteButton.setTitle("Invite Members", for: .normal)
    inviteButton.addTarget(self, action: #selector(inviteFriends),
                           for: .touchUpInside)
    inviteButton.snp.makeConstraints { (make) in
      make.top.equalTo(tableView.snp.bottom).offset(Style.Padding.p12)
      make.bottom.equalToSuperview().inset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
  }

  private func configureNavigation() {
    navigationItem.title = Strings.NavBarTitles.teamMembers
    navigationItem.leftBarButtonItem =
        UIBarButtonItem(title: "Done", style: .done, target: self,
                        action: #selector(dismissView))
  }

  func inviteFriends() {
    Facebook.invite(url: "http://www.google.com")
  }

  func dismissView() {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

