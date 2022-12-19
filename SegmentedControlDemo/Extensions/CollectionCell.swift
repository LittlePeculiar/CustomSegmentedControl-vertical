//
//  CollectionCell.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

extension UICollectionViewCell {
   static var cellIdentifier: String {
      return String(describing: self)
   }

   static func registerWithCollectionView(collectionView: UICollectionView) {
      collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
   }
}


