//
//  CollectionViewController.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/3/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: ViewController {

  var dataSource: CollectionViewDataSource? = EmptyCollectionViewDataSource()

  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  let refreshControl = UIRefreshControl()

  // Cached Heights
  var heights = [IndexPath: CGFloat]()

  override func viewDidLoad() {
    super.viewDidLoad()
    reload()
  }

  override func configureView() {
    view.backgroundColor = Style.Colors.Background
    extendedLayoutIncludesOpaqueBars = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    refreshControl.tintColor = Style.Colors.black
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    collectionView.configure(with: self)
    view.addSubview(collectionView) {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // Bug related to https://github.com/lionheart/openradar-mirror/issues/20208
    collectionView.refreshControl = refreshControl
  }

  @objc func refresh() {
    refreshControl.beginRefreshing()
    dataSource?.reload { [weak self] in
      onMain {
        self?.refreshControl.endRefreshing()
        self?.collectionView.reloadData()
      }
    }
  }

  func reload() {
    dataSource?.reload { [weak self] in
      self?.collectionView.reloadOnMain()
    }
  }
  func handle(context: Context) {
    // Override point for subclasses
  }
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataSource?.numberOfSections() ?? 0
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.numberOfItems(in: section) ?? 0
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueAndConfigureReusableCell(dataSource: dataSource, indexPath: indexPath)
  }
  // swiftlint:disable:next line_length
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return collectionView.dequeueAndConfigureReusableCell(dataSource: dataSource, indexPath: indexPath)
  }
}
