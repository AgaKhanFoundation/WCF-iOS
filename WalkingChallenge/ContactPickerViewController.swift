
import SnapKit

protocol ContactPickerViewControllerDelegate: class {
  func contactPickerSelected(friends: [String])
}

class ContactPickerViewController: UIViewController {
  fileprivate let tableView = UITableView()
  fileprivate let dataSource = ContactDataSource()
  private let searchBar = UISearchBar()
  
  weak var delegate: ContactPickerViewControllerDelegate?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
    configureNavigationBar()
    configureTableView()
    configureSearcBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    dataSource.reload { [weak self] in
      self?.tableView.reloadData()
    }
  }
  
  // MARK: - Configure
  
  private func configureView() {
    view.backgroundColor = Style.Colors.white
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(Style.Padding.p12)
    }
  }
  
  private func configureNavigationBar() {
    navigationItem.title = Strings.ContactPicker.title
    updateNavigationBar()
  }
  
  private func configureTableView() {
    tableView.rowHeight = Style.Size.s40
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = Style.Colors.white
    tableView.register(ContactCell.self,
                       forCellReuseIdentifier: ContactCell.identifier)
    tableView.allowsMultipleSelection = true
  }
  
  private func configureSearcBar() {
    searchBar.placeholder = "Search"
    searchBar.delegate = self
    navigationItem.titleView = searchBar
  }
  
  fileprivate func updateNavigationBar() {
    if dataSource.anyFriendsSelected {
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                         target: self,
                                                         action: #selector(addTapped))
    } else {
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                         target: self,
                                                         action: #selector(cancelTapped))
    }
  }
  
  // MARK: - Actions
  
  func cancelTapped() {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  func addTapped() {
    delegate?.contactPickerSelected(friends: dataSource.selectedFriendsIDs)
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

extension ContactPickerViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    dataSource.filter = searchText.isEmpty ? nil : searchText
    tableView.reloadData()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    dataSource.filter = nil
    tableView.reloadData()
  }
}

extension ContactPickerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.cells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cellInfo = dataSource.cells[safe: indexPath.row],
      let cell = tableView.dequeueReusableCell(withIdentifier: cellInfo.cellIdentifier, for: indexPath) as? ConfigurableTableViewCell
    else { return UITableViewCell() }
    
    cell.configure(cellInfo: cellInfo)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dataSource.changeSelection(at: indexPath, select: true)
    updateNavigationBar()
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    dataSource.changeSelection(at: indexPath, select: false)
    updateNavigationBar()
  }
}
