//
//  ItemData.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Foundation

class ItemData {
   let title: String
   var isSelected: Bool

   init(title: String, isSelected: Bool = false) {
      self.title = title
      self.isSelected = isSelected
   }
}
