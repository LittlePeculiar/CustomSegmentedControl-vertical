//
//  LeftAlignFlowLayout.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

class LeftAlignFlowLayout: UICollectionViewFlowLayout {
   var rightInset: CGFloat = 8.0

   override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      minimumLineSpacing = rightInset
      let attributes = super.layoutAttributesForElements(in: rect)

      var leftMargin = sectionInset.left
      var maxY: CGFloat = -1.0
      attributes?.forEach { layoutAttribute in
         if layoutAttribute.frame.origin.y >= maxY {
            leftMargin = sectionInset.left
         }
         layoutAttribute.frame.origin.x = leftMargin
         leftMargin += layoutAttribute.frame.width + minimumLineSpacing
         maxY = max(layoutAttribute.frame.maxY, maxY)
      }
      return attributes
   }
}
