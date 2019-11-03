//
//  BadgesViewController.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/2/19.
//  Copyright © 2019 AKDN. All rights reserved.
//

import UIKit

class Badge {
  var isCompleted: Bool = true
  var title: String = ""
}

private let badgeCellId = "BadgeCell"
private let headerCellId = "HeaderCell"

class BadgesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {


  var stepsBadges = [BadgeCell]()
  var achievementBadges = [BadgeCell]()

  override func viewDidLoad() {
    
    super.viewDidLoad()
		setupCollectionView()
  }
	
	func setupCollectionView() {

    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    /// Register collection view cells
		collectionView.register(BadgeCell.self, forCellWithReuseIdentifier: badgeCellId)
    collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)

    collectionView.backgroundColor = .white

  }
  
  // MARK: UICollectionViewDataSource
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
	
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 1 {
      return 9 //stepsBadges.count
    } else {
      return 9 //achievementBadges.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width/3, height: 160)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: badgeCellId, for: indexPath) as! BadgeCell
		return cell
  }
}

class BadgeCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  let badgeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "badge_icon")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = UIColor.green.cgColor
    return imageView
  }()
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {


    backgroundColor = .white

    addSubview(badgeImageView)

    badgeImageView.widthAnchor.constraint(equalToConstant: 72).isActive = true
    badgeImageView.heightAnchor.constraint(equalToConstant: 72).isActive = true
    badgeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    badgeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true

  }
}
