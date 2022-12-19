//
//  Object+ext.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

extension NSObject {
   @nonobjc public class var className: String {
      return String(describing: self)
   }
   @nonobjc public var className: String {
      return String(describing: type(of: self))
   }
}
