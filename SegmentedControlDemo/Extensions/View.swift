//
//  View.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

extension UIView {
   func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      layer.masksToBounds = true
      layer.maskedCorners = corners.cornerMask
      layer.cornerRadius = radius
   }
}

extension UIRectCorner {
   var cornerMask: CACornerMask {
      var cornerMask: CACornerMask = []

      if contains(.topLeft) {
         cornerMask.formUnion(.layerMinXMinYCorner)
      }
      if contains(.topRight) {
         cornerMask.formUnion(.layerMaxXMinYCorner)
      }
      if contains(.bottomLeft) {
         cornerMask.formUnion(.layerMinXMaxYCorner)
      }
      if contains(.bottomRight) {
         cornerMask.formUnion(.layerMaxXMaxYCorner)
      }
      return cornerMask
   }
}
