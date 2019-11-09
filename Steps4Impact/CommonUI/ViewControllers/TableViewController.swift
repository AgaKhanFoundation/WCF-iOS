/**
 * Copyright © 2019 Aga Khan Foundation
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

import UIKit

class TableViewController: ViewController {
  var dataSource: TableViewDataSource? = EmptyTableViewDataSource()

  // Views
  let tableView = UITableView()
  private let refreshControl = UIRefreshControl()

  // Cached Heights
  var heights = [IndexPath: CGFloat]()

  // MARK: - Configure

  override func viewDidLoad() {
    super.viewDidLoad()
    reload()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // Bug related to https://github.com/lionheart/openradar-mirror/issues/20208
    tableView.refreshControl = refreshControl
  }

  override func configureView() {
    super.configureView()
    
    extendedLayoutIncludesOpaqueBars = true
    refreshControl.tintColor = Style.Colors.black
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.configure(with: self)
    view.addSubview(tableView) {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  // MARK: - Actions

  @objc
  private func refresh() {
    refreshControl.beginRefreshing()
    dataSource?.reload { [weak self] in
      onMain {
        self?.refreshControl.endRefreshing()
        self?.tableView.reloadData()
      }
    }
  }

  func reload() {
    dataSource?.reload { [weak self] in
      self?.tableView.reloadOnMain()
    }
  }

  func handle(context: Context) {
    // Override point for subclasses
  }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource?.numberOfSections() ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource?.numberOfItems(in: section) ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueAndConfigureReusableCell(dataSource: dataSource, indexPath: indexPath)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    heights[indexPath] = cell.frame.height
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return heights[indexPath] ?? Style.Padding.p40
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let context = (tableView.cellForRow(at: indexPath) as? Contextable)?.context else { return }
    handle(context: context)
  }
}
