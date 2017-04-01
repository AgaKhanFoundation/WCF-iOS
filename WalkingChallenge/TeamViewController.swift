
import SnapKit

class TeamViewController: UIViewController {
  let tableView = UITableView()
  let dataSource = TeamDataSource()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigationBar()
    configureTableView()
    configureView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    dataSource.reload { [weak self] (success: Bool) in
      self?.tableView.reloadData()
    }
  }

  // MARK: - Configure

  private func configureNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
  }

  private func configureTableView() {
    tableView.estimatedRowHeight = Style.Padding.p32
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = Style.Colors.white
    tableView.register(TeamNameCell.self, forCellReuseIdentifier: TeamNameCell.identifier)
    tableView.register(TeamMemberCell.self, forCellReuseIdentifier: TeamMemberCell.identifier)
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white
    title = Strings.NavBarTitles.team

    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Actions

  func addTapped() {
    let picker = UINavigationController(rootViewController: ContactPicker())
    self.present(picker, animated: true, completion: nil)
  }
}

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
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
}

