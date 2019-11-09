//
//  BadgesViewController.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/2/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

private let badgeCellId = "BadgeCell"
private let headerCellId = "HeaderCell"

class BadgesCollectionViewController: CollectionViewController, UICollectionViewDelegateFlowLayout {

  var stepsBadges = [Badge]()
  var achievementBadges = [Badge]()
  var finalMedalBadge : Badge?

  var isChallengeCompledted : Bool = false

  override init(collectionViewLayout layout: UICollectionViewLayout) {
    super.init(collectionViewLayout: layout)
    dataSource = BadgesCollectionDataSource()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.Badges.title
    self.navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
		setupCollectionView()
  }
  
	
	func setupCollectionView() {

    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    /// Register collection view cells
		collectionView.register(BadgeCell.self, forCellWithReuseIdentifier: badgeCellId)
    collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)

    collectionView.backgroundColor = .white
  }

  override func reload() {
    dataSource?.reload { [weak self] in
      self?.updateSources(from: self?.dataSource)
      self?.collectionView.reloadOnMain()
    }
  }

  @objc override func refresh() {
    refreshControl.beginRefreshing()
    dataSource?.reload { [weak self] in
      self?.updateSources(from: self?.dataSource)
      self?.refreshControl.endRefreshing()
      self?.collectionView.reloadOnMain()
    }
  }

  func updateSources(from dataSource: CollectionViewDataSource?) {
    if let dataSource = dataSource, let badgeDataSource = dataSource as? BadgesCollectionDataSource {
      isChallengeCompledted = badgeDataSource.isChallengeCompleted
      finalMedalBadge = badgeDataSource.finalMedalBadge
      stepsBadges = badgeDataSource.stepsBadges
      achievementBadges = badgeDataSource.achievementBadges
    }
  }
}

// MARK: UICollectionViewDataSource
extension BadgesCollectionViewController {

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      if isChallengeCompledted, let _ = finalMedalBadge {
        return 1
      } else {
        return stepsBadges.count
      }
    } else {
      return achievementBadges.count
    }
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: badgeCellId, for: indexPath) as! BadgeCell
    if indexPath.section == 0 {
      if isChallengeCompledted, let _ = finalMedalBadge {
        cell.badge = finalMedalBadge
      } else {
        cell.badge = stepsBadges[indexPath.row]
      }
    } else {
      cell.badge = achievementBadges[indexPath.row]
    }
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! HeaderCell
    if indexPath.section == 0 {
      header.headerLabel.text = ""
    } else {
      header.headerLabel.text = "10,000 steps per day streak"
    }
    return header
  }

}

// MARK: UICollectionViewDelegate

extension BadgesCollectionViewController {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 0, isChallengeCompledted, let _ = finalMedalBadge {
      return CGSize(width: view.frame.width, height: (view.frame.height/2) - 100)
    } else {
      return CGSize(width: view.frame.width/3, height: 160)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

    if section == 0 {
        if (isChallengeCompledted && finalMedalBadge != nil) || (stepsBadges.count == 0 && achievementBadges.count == 0) {
          /// Hiding Top Section Header
          return CGSize(width: view.frame.width, height: 0)
        } else if stepsBadges.count == 0 {
          /// Making top header bigger to show bottom header in the middle
          return CGSize(width: view.frame.width, height: (view.frame.height/2) - 100)
        }
    } else if achievementBadges.count != 0 || stepsBadges.count != 0 {
      return CGSize(width: view.frame.width, height: 44)
    }
    return CGSize(width: view.frame.width, height: 0)
  }
}

