//
//  AnimalData.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Foundation

class AnimalData {
   let breed: String
   let breedDescription: String
   let imagePath: String
   var isFavorite: Bool = false

   init(breed: String, breedDesc: String, imagePath: String) {
      self.breed = breed
      self.breedDescription = breedDesc
      self.imagePath = imagePath
   }
}
