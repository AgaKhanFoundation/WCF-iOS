//
//  CollectionViewController.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/3/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

  var dataSource: CollectionViewDataSource? = EmptyCollectionViewDataSource()

  let refreshControl = UIRefreshControl()

  // Cached Heights
  var heights = [IndexPath: CGFloat]()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reload()
  }

  func configureView() {
    view.backgroundColor = Style.Colors.Background
    extendedLayoutIncludesOpaqueBars = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    refreshControl.tintColor = Style.Colors.black
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
  }

  func commonInit() {
     // Override point for subclasses - need to call super.commonInit() first
     // Hide name next to back button
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
