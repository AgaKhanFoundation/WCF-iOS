//
//  UICollectionView.swift
//  Steps4Impact
//
//  Created by Aalim Mulji on 11/3/19.
//  Copyright © 2019 AKDN. All rights reserved.
//


import Foundation

import UIKit

extension UICollectionView {

  func configure<V>(with viewController: V) where V: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
     backgroundColor = Steps4Impact.Style.Colors.Background
     delegate = viewController
     dataSource = viewController
     registerAllCells()
   }

   func registerAllCells() {
     [
       BadgeCell.self,
     ].forEach { register($0) }
   }

   func register(_ cellType: ReusableCell.Type) {
    register(cellType, forCellWithReuseIdentifier: cellType.identifier)
   }

  func reloadOnMain() {
    onMain {
      self.reloadData()
    }
  }

  func dequeueAndConfigureReusableCell(dataSource: CollectionViewDataSource?, indexPath: IndexPath) -> ConfigurableCollectionViewCell {
      guard let cellContext = dataSource?.cell(for: indexPath),
        let cell = dequeueReusableCell(withReuseIdentifier: cellContext.identifier, for: indexPath) as? ConfigurableCollectionViewCell
        else {
          assertionFailure("Trying to dequeue a cell that was not registered")
          return EmptyCollectionViewCell()
      }

      cell.configure(context: cellContext)
      return cell
    }
  }

