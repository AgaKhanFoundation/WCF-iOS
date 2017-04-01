
import UIKit
import SnapKit
import Contacts

struct FriendCellInfo : CellInfo {
  let cellIdentifier: String = FriendCell.identifier
  let fbid: String
  let name: String
  let picture: String
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

  var selectedFriends = [String]()
  var sortedFriends = [String: [String]]()

  func reload(completion: @escaping () -> Void) {
    if cells.isEmpty {
      let sortOrder = CNContactsUserDefaults.shared().sortOrder
      Facebook.getTaggableFriends(limit: .none) { (friend) in
        self.cells.append(FriendCellInfo(fbid: friend.fbid,
                                         name: friend.display_name,
                                         picture: friend.picture_url))
        var sorted = [String]()

        var key: String
        switch (sortOrder) {
        case .givenName:
          key = String(friend.first_name.characters.first!).uppercased()
        case .none:
          fallthrough
        case .familyName:
          key = String(friend.last_name.characters.first!).uppercased()
        case .userDefault:
          key = "#"
        }

        if let friends = self.sortedFriends[key] {
          sorted = friends
        }
        sorted.append(friend.fbid)
        self.sortedFriends[key] = sorted
        onMain {
          completion()
        }
      }
    }
  }
}

class ContactPicker : UIViewController {
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

    configureNavigationBar()
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

  private func configureNavigationBar() {
    navigationItem.title = "Select Friends"
    navigationItem.leftBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                        action: #selector(cancelTapped))
    navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .done, target: self,
                        action: #selector(doneTapped))
  }

  private func configureTableView() {
    // TODO(compnerd) create a constant for this value
    tableView.rowHeight = 40.0
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = Style.Colors.white
    tableView.register(FriendCell.self,
                       forCellReuseIdentifier: FriendCell.identifier)
    tableView.allowsMultipleSelection = true
  }

  func cancelTapped() {
    self.dismiss(animated: true, completion: nil)
  }

  func doneTapped() {
    self.dismiss(animated: true, completion: nil)
  }
}

extension ContactPicker {
  fileprivate func contact(for indexPath: IndexPath) -> String? {
    guard
      let key = dataSource.sortedFriends.keys.sorted()[safe: indexPath.section],
      let contacts = dataSource.sortedFriends[key]
    else {
        return nil
    }
    return contacts[safe: indexPath.row]!
  }
}

extension ContactPicker : UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
      -> UITableViewCell {
    guard
      let contact = self.contact(for: indexPath),
      let cell =
          tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier,
                                        for: indexPath)
              as? ConfigurableTableViewCell
    else {
      return UITableViewCell()
    }

    let cellInfo = dataSource.cells.filter { (ci) in
      return (ci as! FriendCellInfo).fbid == contact
    }.first! as! FriendCellInfo
    cell.configure(cellInfo: cellInfo)
    cell.accessoryType =
        dataSource.selectedFriends.contains(cellInfo.fbid) ? .checkmark : .none
    return cell
  }

  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return dataSource.sortedFriends.keys.sorted()
  }
}

extension ContactPicker : UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.sortedFriends.keys.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
      -> String? {
    return dataSource.sortedFriends.keys.sorted()[section]
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
      -> Int {
    let key = dataSource.sortedFriends.keys.sorted()[section]
    return (dataSource.sortedFriends[key]?.count)!
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    let contact = self.contact(for: indexPath)
    let cellInfo = dataSource.cells.filter { (ci) in
      return (ci as! FriendCellInfo).fbid == contact
    }.first! as! FriendCellInfo
    cell.accessoryType =
        dataSource.selectedFriends.contains(cellInfo.fbid) ? .checkmark : .none
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
      let cellInfo = dataSource.cells[safe: indexPath.row] as! FriendCellInfo
      dataSource.selectedFriends.append(cellInfo.fbid)
      cell.accessoryType = .checkmark
    }
  }

  func tableView(_ tableView: UITableView,
                 didDeselectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let cellInfo = dataSource.cells[safe: indexPath.row] as! FriendCellInfo
      dataSource.selectedFriends =
          dataSource.selectedFriends.filter { (fbid) -> Bool in
            return fbid != cellInfo.fbid
          }
      cell.accessoryType = .none
    }
  }
}

extension ContactPicker : UISearchBarDelegate {
}

