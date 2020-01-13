//
//  BadgesViewController.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/2/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

class BadgesCollectionViewController: CollectionViewController {

  var finalMedalBadge = Badge(finalMedalAchieved: .unknown, badgeType: .finalMedal)
  var isChallengeCompledted: Bool = false

  override func commonInit() {
    super.commonInit()
    title = Strings.Badges.title
    dataSource = BadgesCollectionDataSource()
    setupCollectionView()
  }
  func setupCollectionView() {
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.minimumLineSpacing = 0
      layout.minimumInteritemSpacing = 0
      layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    /// Register Header Cell
    // swiftlint:disable:next line_length
    collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCell.identifier)
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
      if let badge = badgeDataSource.finalMedalBadge {
        finalMedalBadge = badge
      }
    }
  }
}

extension BadgesCollectionViewController {
  // swiftlint:disable:next line_length
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? BadgeCell {
      cell.delegate = self
    }
  }
  // swiftlint:disable:next line_length
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 0, isChallengeCompledted, finalMedalBadge.finalMedalAchieved != .unknown {
      return CGSize(width: view.frame.width, height: (view.frame.height/2) - 100)
    } else {
      return CGSize(width: view.frame.width/3, height: 160)
    }
  }
  // swiftlint:disable:next line_length
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    // swiftlint:disable:next line_length
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell else { return UICollectionViewCell() }
    if indexPath.section == 0 {
      if dataSource?.numberOfItems(in: 0) == 0 && dataSource?.numberOfItems(in: 1) == 0 {
        header.headerLabel.text = Strings.Badges.HeaderTittes.noBadges
      } else {
        header.headerLabel.text = ""
      }
    } else {
      header.headerLabel.text = Strings.Badges.HeaderTittes.bottomSectionTitle
    }
    return header
  }
  // swiftlint:disable:next line_length
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 0 {
      if isChallengeCompledted && finalMedalBadge.finalMedalAchieved != .unknown {
        /// Hiding Top Section Header
        return CGSize(width: view.frame.width, height: 0)
      } else if dataSource?.numberOfItems(in: 0) == 0 && dataSource?.numberOfItems(in: 1) != 0 {
        /// Making top header bigger to show bottom header in the middle
        return CGSize(width: view.frame.width, height: (view.frame.height/2) - 100)
      } else if dataSource?.numberOfItems(in: 0) == 0 && dataSource?.numberOfItems(in: 1) == 0 {
        return CGSize(width: view.frame.width, height: 44)
      }
    } else if section == 1 && (dataSource?.numberOfItems(in: 1) != 0 || dataSource?.numberOfItems(in: 0) != 0) {
      return CGSize(width: view.frame.width, height: 44)
    }
    return CGSize(width: view.frame.width, height: 0)
  }
}

extension BadgesCollectionViewController: BadgeCellDelegate {
  func badgeCellTapped() {
  }
}
