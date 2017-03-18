
import SnapKit

struct TeamNameCellInfo: CellInfo {
  let cellIdentifier: String = TeamNameCell.identifier
  let name: String
}

class TeamNameCell: ConfigurableTableViewCell {
  static let identifier: String = "TeamNameCell"

  // Views
  let nameLabel = UILabel(.header)

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
    contentView.addSubview(nameLabel)
    backgroundColor = .clear

    nameLabel.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(Style.Padding.p12)
    }
  }

  // MARK: - Configure

  override func configure(cellInfo: CellInfo) {
    guard let cellInfo = cellInfo as? TeamNameCellInfo else { return }

    nameLabel.text = cellInfo.name
  }
}
