
import SnapKit

struct TeamMemberCellInfo: CellInfo {
  let cellIdentifier: String = TeamMemberCell.identifier

  let name: String
  let picture: String

  init(for friend: Friend) {
    self.name = friend.display_name
    self.picture = friend.picture_url
  }
}

class TeamMemberCell: ConfigurableTableViewCell {
  static let identifier: String = "TeamMemberCell"

  // Views
  let picture = UIImageView()
  let nameLabel = UILabel(.body)

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    contentView.addSubviews([picture, nameLabel])
    backgroundColor = .clear

    picture.snp.makeConstraints { (make) in
      make.height.equalTo(32)
      make.width.equalTo(32)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    nameLabel.snp.makeConstraints { (make) in
      make.left.equalTo(picture.snp.right).offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.height.equalTo(picture.snp.height)
    }
  }

  // MARK: - Configure

  override func configure(cellInfo: CellInfo) {
    guard let cell = cellInfo as? TeamMemberCellInfo else { return }

    nameLabel.text = cell.name

    onBackground {
      do {
        let data = try Data(contentsOf: URL(string: cell.picture)!)
        self.picture.image = UIImage(data: data)
      } catch {
      }
    }
  }
}

