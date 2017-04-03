
import UIKit
import SnapKit
import Contacts

struct ContactCellInfo {
  let cellIdentifier = ContactCell.identifier

  let fbid: String
  let name: String
  let picture: String

  init(from friend: Friend) {
    self.fbid = friend.fbid
    self.name = friend.display_name
    self.picture = friend.picture_url
  }
}

class ContactCell: UITableViewCell {
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

  func configure(info: ContactCellInfo) {
    name.text = info.name
    do {
      let data = try Data(contentsOf: URL(string: info.picture)!)
      picture.image = UIImage(data: data)
    } catch {
    }
  }
}

class ContactDataSource {
  var cells = [ContactCellInfo]()

  var selectedContacts = [String]()
  var sortedContacts = [String: [String]]()

  var filteredContacts = [String]()

  func reload(completion: @escaping () -> Void) {
    if cells.isEmpty {
      let sortOrder = CNContactsUserDefaults.shared().sortOrder
      Facebook.getTaggableFriends(limit: .none) { (friend) in
        self.cells.append(ContactCellInfo(from: friend))

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

        var sorted = [String]()
        if let friends = self.sortedContacts[key] {
          sorted = friends
        }
        sorted.append(friend.fbid)

        self.sortedContacts[key] = sorted

        onMain {
          completion()
        }
      }
    }
  }
}

class ContactPicker: UIViewController {
  var tableView = UITableView()
  let searchController = UISearchController(searchResultsController: nil)
  let dataSource = ContactDataSource()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    dataSource.reload { [weak self] () in
      self?.tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigationBar()
    configureSearchController()
    configureTableView()

    view.backgroundColor = Style.Colors.white
    view.addSubview(tableView)

    tableView.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.bottom.equalToSuperview().inset(Style.Padding.p12)
    }
  }

  private func configureNavigationBar() {
    navigationItem.title = Strings.ContactPicker.title
    navigationItem.leftBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                        action: #selector(cancelTapped))
    navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .done, target: self,
                        action: #selector(doneTapped))
  }

  private func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.delegate = self
    searchController.searchBar.isTranslucent = true
  }

  private func configureTableView() {
    tableView.tableHeaderView = searchController.searchBar
    tableView.rowHeight = Style.Size.s40
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = Style.Colors.white
    tableView.register(ContactCell.self,
                       forCellReuseIdentifier: ContactCell.identifier)
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
  fileprivate var isSearchActive: Bool {
    return searchController.isActive &&
           !(searchController.searchBar.text?.isEmpty)!
  }

  fileprivate func cell(for fbid: String) -> ContactCellInfo? {
    return dataSource.cells.filter { (info) in
      return info.fbid == fbid
    }.first
  }

  fileprivate func contact(for indexPath: IndexPath) -> String? {
    guard
      let key =
          dataSource.sortedContacts.keys.sorted()[safe: indexPath.section],
      let contacts = isSearchActive ? dataSource.filteredContacts
                                    : dataSource.sortedContacts[key]
    else {
        return nil
    }
    return contacts[safe: indexPath.row]
  }

  fileprivate func selectContact(fbid: String) {
    dataSource.selectedContacts.append(fbid)
  }

  fileprivate func unselectContact(fbid: String) {
    dataSource.selectedContacts =
        dataSource.selectedContacts.filter { (contact) in
          return !(contact == fbid)
        }
  }

  fileprivate func isSelected(fbid: String) -> Bool {
    return dataSource.selectedContacts.contains(fbid)
  }
}

extension ContactPicker: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let contact = self.contact(for: indexPath),
      let info = self.cell(for: contact),
      let cell =
          tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier,
                                        for: indexPath) as? ContactCell
    else {
      return UITableViewCell()
    }

    cell.configure(info: info)
    cell.accessoryType =
        dataSource.selectedContacts.contains(info.fbid) ? .checkmark : .none
    return cell
  }

  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    if isSearchActive {
      return nil
    } else {
      return dataSource.sortedContacts.keys.sorted()
    }
  }
}

extension ContactPicker: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    if isSearchActive {
      return 1
    } else {
      return dataSource.sortedContacts.keys.count
    }
  }

  func tableView(_ tableView: UITableView,
                 titleForHeaderInSection section: Int) -> String? {
    if isSearchActive {
      return nil
    } else {
      return dataSource.sortedContacts.keys.sorted()[section]
    }
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    if isSearchActive {
      return dataSource.filteredContacts.count
    } else {
      let key = dataSource.sortedContacts.keys.sorted()[section]
      return (dataSource.sortedContacts[key]?.count)!
    }
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    guard let contact = self.contact(for: indexPath) else {
      cell.accessoryType = .none
      return
    }
    cell.accessoryType = isSelected(fbid: contact) ? .checkmark : .none
  }

  func tableView(_ tableView: UITableView,
                 willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    guard let selected = tableView.indexPathsForSelectedRows else { return nil }

    if selected.count == Team.limit {
      let alert =
          UIAlertController(title: "Error",
                            message: "You are limited to \(Team.limit) members",
                            preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return nil
    }

    return indexPath
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      guard let contact = self.contact(for: indexPath) else { return }
      selectContact(fbid: contact)
      cell.accessoryType = .checkmark
    }
  }

  func tableView(_ tableView: UITableView,
                 didDeselectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      guard let contact = self.contact(for: indexPath) else { return }
      unselectContact(fbid: contact)
      cell.accessoryType = .none
    }
  }
}

extension ContactPicker: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let string = searchController.searchBar.text?.lowercased() else {
      return
    }

    dataSource.filteredContacts = dataSource.cells.filter { (cell) in
      return cell.name.lowercased().contains(string)
    }.map { return $0.fbid }

    tableView.reloadData()
  }
}

extension ContactPicker: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    tableView.reloadData()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    tableView.reloadData()
  }
}

