
import SnapKit

struct ContactCellInfo: CellInfo {
  let cellIdentifier: String = ContactCell.identifier
  
  let fbid: String
  let name: String
  let picture: String
  var isSelected: Bool = false
  
  init(from friend: Friend) {
    self.fbid = friend.fbid
    self.name = friend.display_name
    self.picture = friend.picture_url
  }
}


class ContactCell: ConfigurableTableViewCell {
  static let identifier: String = "ContactCell"
  
  let picture = UIImageView()
  let name = UILabel(.body)
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialize()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  private func initialize() {
    contentView.addSubviews([picture, name])
    backgroundColor = .clear
    
    picture.snp.makeConstraints { (make) in
      make.height.width.equalTo(Style.Size.s32)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    name.snp.makeConstraints { (make) in
      make.left.equalTo(picture.snp.right).offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.height.equalTo(picture.snp.height)
    }
  }
  
  override func configure(cellInfo: CellInfo) {
    guard let info = cellInfo as? ContactCellInfo else { return }
    
    name.text = info.name
    onBackground {
      guard
        let url = URL(string: info.picture),
        let data = try? Data(contentsOf: url)
      else { return }
      
      let image = UIImage(data: data)
      
      onMain {
        self.picture.image = image
      }
    }
  }
}
