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

