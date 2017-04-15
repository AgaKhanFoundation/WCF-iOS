
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

    label.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.edges.equalToSuperview().inset(Style.Padding.p12)
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
    pictureView.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.height.width.equalTo(Style.Size.s32)
      ConstraintMaker.left.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.centerY.equalToSuperview()
    }

    nameLabel.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.left.equalTo(pictureView.snp.right)
          .offset(Style.Padding.p12)
      ConstraintMaker.right.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.centerY.equalTo(pictureView.snp.centerY)
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

    if (indexPath.row == 0) {
      let cell = cell as! UITableViewCell
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
    }

    cell.configure(info)
    return cell as! UITableViewCell
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
    tableView.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.leading.trailing.equalToSuperview()
          .inset(Style.Padding.p12)
      ConstraintMaker.top.equalToSuperview().inset(Style.Padding.p12)
    }

    inviteButton.contentEdgeInsets =
        UIEdgeInsetsMake(Style.Padding.p8, Style.Padding.p8, Style.Padding.p8,
                         Style.Padding.p8)
    inviteButton.layer.borderWidth = 1
    inviteButton.setTitle("Invite Members", for: .normal)
    inviteButton.snp.makeConstraints { (ConstraintMaker) in
      ConstraintMaker.top.equalTo(tableView.snp.bottom).offset(Style.Padding.p12)
      ConstraintMaker.bottom.equalToSuperview().inset(Style.Padding.p12)
      ConstraintMaker.centerX.equalToSuperview()
    }
  }

  private func configureNavigation() {
    navigationItem.title = Strings.NavBarTitles.teamMembers
    navigationItem.leftBarButtonItem =
        UIBarButtonItem(title: "Done", style: .done, target: self,
                        action: #selector(dismissView))
  }

  func dismissView() {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

