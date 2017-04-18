/**
 * Copyright © 2017 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

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
      navigationItem.leftBarButtonItem =
          UIBarButtonItem(barButtonSystemItem: .add, target: self,
                          action: #selector(addTapped))
    } else {
      navigationItem.leftBarButtonItem =
          UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
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

extension ContactPickerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return dataSource.cells.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cellInfo = dataSource.cells[safe: indexPath.row],
      let cell =
          tableView.dequeueReusableCell(withIdentifier: cellInfo.cellIdentifier,
                                        for: indexPath)
              as? ConfigurableTableViewCell
    else { return UITableViewCell() }

    cell.configure(cellInfo: cellInfo)
    return cell
  }
}

extension ContactPickerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    dataSource.changeSelection(at: indexPath, select: true)
    updateNavigationBar()
  }

  func tableView(_ tableView: UITableView,
                 didDeselectRowAt indexPath: IndexPath) {
    dataSource.changeSelection(at: indexPath, select: false)
    updateNavigationBar()
  }
}
