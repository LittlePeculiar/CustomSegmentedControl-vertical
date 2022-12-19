//
//  HomeTabOptions.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

enum HomeTabOption: Int {
   case favorites
   case dogs
   case cats
   case fish
   case dinosaurs
   case birds

   static let allOptions = [favorites, dogs, cats, fish, dinosaurs, birds]

   var name: String {
      switch self {
         case .favorites: return "Favorites"
         case .dogs: return "Dogs"
         case .cats: return "Cats"
         case .fish: return "Fish"
         case .dinosaurs: return "Dinosaurs"
         case .birds: return "Birds"
      }
   }
   var icon: UIImage? {
      switch self {
         case .favorites: return UIImage(named: "tab-star")
         case .dogs: return UIImage(named: "tab-dog")
         case .cats: return UIImage(named: "tab-cat")
         case .fish: return UIImage(named: "tab-fish")
         case .dinosaurs: return UIImage(named: "tab-dinosaur")
         case .birds: return UIImage(named: "tab-bird")
      }
   }
}
