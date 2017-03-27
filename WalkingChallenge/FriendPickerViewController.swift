
import UIKit
import SnapKit
import ContactsUI

struct FriendCellInfo : CellInfo {
  let cellIdentifier: String = FriendCell.identifier
  let name: String
  let picture: String
  var selected: Bool
}

class FriendCell: ConfigurableTableViewCell {
  static let identifier: String = "FriendCell"

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
      // TODO(compnerd) create a constant for the photo size
      make.height.width.equalTo(32)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    name.snp.makeConstraints { (make) in
      make.left.equalTo(picture.snp.right).offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.height.equalTo(picture.snp.height)
    }
  }

  override func configure(cellInfo: CellInfo) {
    guard let cell = cellInfo as? FriendCellInfo else { return }

    name.text = cell.name
    do {
      let data = try Data(contentsOf: URL(string: cell.picture)!)
      picture.image = UIImage(data: data)
    } catch {
    }
  }
}

class FriendsDataSource: TableDataSource {
  var cells = [CellInfo]()

  func reload(completion: @escaping () -> Void) {
    if cells.isEmpty {
      Facebook.getTaggableFriends(limit: .none) { (friend) in
        self.cells.append(FriendCellInfo(name: friend.display_name,
                          picture: friend.picture_url, selected: false))
        onMain {
          completion()
        }
      }
    }
  }
}

class FriendPickerViewController : UIViewController {
  var tableView = UITableView()
  let dataSource = FriendsDataSource()
  let search = UISearchBar()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    dataSource.reload { [weak self] () in
      self?.tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureTableView()

    // TODO(compnerd) color the background to .clear
    search.delegate = self

    view.backgroundColor = Style.Colors.white
    view.addSubviews([search, tableView])

    search.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalToSuperview().inset(Style.Padding.p12)
    }
    tableView.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(search.snp.bottom).offset(Style.Padding.p12)
      make.bottom.equalToSuperview().inset(Style.Padding.p12)
    }
  }

  private func configureTableView() {
    tableView.estimatedRowHeight = Style.Padding.p32
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = Style.Colors.white
    tableView.register(FriendCell.self,
                       forCellReuseIdentifier: FriendCell.identifier)
    tableView.allowsMultipleSelection = true
  }
}

extension FriendPickerViewController : UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
      -> UITableViewCell {
    guard
      let cellInfo = dataSource.cells[safe: indexPath.row],
      let cell =
          tableView.dequeueReusableCell(withIdentifier: cellInfo.cellIdentifier,
                                        for: indexPath)
              as? ConfigurableTableViewCell
    else {
      return UITableViewCell()
    }

    cell.configure(cellInfo: cellInfo)
    cell.accessoryType =
        (cellInfo as! FriendCellInfo).selected ? .checkmark : .none
    return cell
  }

  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
            "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
  }
}

extension FriendPickerViewController : UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
      -> Int {
    return dataSource.cells.count
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    let cellInfo = dataSource.cells[safe: indexPath.row] as! FriendCellInfo
    cell.accessoryType = cellInfo.selected ? .checkmark : .none
  }

  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath)
      -> IndexPath? {
    if let selected = tableView.indexPathsForSelectedRows {
      if selected.count == 11 {
        let alert = UIAlertController(title: "Error",
                                      message: "You are limited to 11 members",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
        return nil
      }
    }

    return indexPath
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      var cellInfo = dataSource.cells[safe: indexPath.row] as! FriendCellInfo
      cellInfo.selected = true
      cell.accessoryType = .checkmark
    }
  }

  func tableView(_ tableView: UITableView,
                 didDeselectRowAt indexPath: IndexPath) {
    var cellInfo = dataSource.cells[safe: indexPath.row] as! FriendCellInfo
    if let cell = tableView.cellForRow(at: indexPath) {
      cellInfo.selected = false
      cell.accessoryType = .none
    }
  }
}

extension FriendPickerViewController : UISearchBarDelegate {
}

