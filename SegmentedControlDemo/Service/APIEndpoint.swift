//
//  APIEndpoint.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Foundation

enum APIEndpoint: Hashable {
   case fetchDogs
   case fetchCats
   case fetchBirds
   case fetchDinosaurs
   case fetchFish
}

extension APIEndpoint {
   private var baseUrl: String {
      return "https://"
   }

   var path: String {
      switch self {
         case .fetchDogs:
            return "https://dog.ceo/api/breeds/image/random"
         default:
            return "https://dog.ceo/api/breeds/image/random"
      }
   }
}
