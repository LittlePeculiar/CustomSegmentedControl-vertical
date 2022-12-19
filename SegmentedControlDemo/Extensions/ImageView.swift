//
//  ImageView.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

extension UIImageView {
   func fetchImage(path: String) {
      DispatchQueue.global().async { [weak self] in
         ImageDownloader.shared.fetchImage(urlPath: path) { image in
            DispatchQueue.main.async {
               self?.image = image
            }
         }
      }
   }
}
