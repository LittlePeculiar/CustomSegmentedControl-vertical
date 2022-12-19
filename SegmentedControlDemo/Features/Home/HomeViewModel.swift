//
//  HomeViewModel.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Combine
import UIKit

class HomeViewModel {
    var animals = CurrentValueSubject<[AnimalData]?, Never>(nil)
    var selectedCategory = CurrentValueSubject<String?, Never>(nil)
    var selectedSubCategory = CurrentValueSubject<String?, Never>(nil)
    var homeOption = CurrentValueSubject<HomeTabOption, Never>(.favorites)

    var categories = ["German Shepherd", "Huskies", "Labs"]
   
    func getData() {
       API.shared.fetch(payload: Dog.self, endpoint: APIEndpoint.fetchDogs) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let response):
              if let data = response  {
                 let dog = data as Dog
                 let animal = AnimalData(breed: "Awesome Doggo", breedDesc: "A very cool breed", imagePath: dog.message)

                 self.animals.send([animal])
              }
          case .failure(let error):
              print(error.localizedDescription)
                self.animals.send(nil)
          }
       }
    }

   func getSubcategories(forCategory cat: String) -> [String] {
      return ["Extra Large", "Large", "Medium", "Small"]
   }
}
