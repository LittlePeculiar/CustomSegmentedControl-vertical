//
//  ImageDownloader.swift
//
//  Created by Gina Mullins on 11/1/22.
//

import UIKit

class ImageDownloader {
   static var shared = ImageDownloader()
   private let cache = NSCache<NSString, NSData>()
   private let fileManager = LocalFileManager.shared
    
    func saveImage(image: UIImage, imagePath: String){
        if let data = image.jpegData(compressionQuality: 0.8) {
            self.fileManager.save(data: data, urlPath: imagePath)
        }
    }
   
   func fetchImage(urlPath: String, onSuccess: @escaping (UIImage?) -> Void) {
      guard let imagePath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
         onSuccess(nil)
         return
      }
      let cacheID = NSString(string: imagePath)
      
      if let imageData = cache.object(forKey: cacheID) as Data? {
         let image = UIImage(data: imageData)
         onSuccess(image)
      } else {
         if let data = fileManager.getData(urlPath: imagePath) {
            let image = UIImage(data: data)
            onSuccess(image)
         } else {
            guard let url = URL(string: imagePath) else {
               onSuccess(nil)
               return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
               DispatchQueue.main.async { [weak self] in
                  guard let imageData = data else { return }
                  self?.cache.setObject(imageData as NSData, forKey: cacheID)
                  if let image = UIImage(data: imageData),
                     let data = image.jpegData(compressionQuality: 1.0) {
                     self?.fileManager.save(data: data, urlPath: imagePath)
                     onSuccess(image)
                  } else {
                     onSuccess(nil)
                  }
               }
            }.resume()
         }
      }
   }
}
