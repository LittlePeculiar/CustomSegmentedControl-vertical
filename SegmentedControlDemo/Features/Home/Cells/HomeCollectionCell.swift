//
//  HomeCollectionCell.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import UIKit

protocol HomeCollectionCellDelegate: AnyObject {
   func didSelect(favorite: Bool, atIndexPath indexPath: IndexPath)
}

class HomeCollectionCell: UICollectionViewCell {
   @IBOutlet weak var breedLabel: UILabel!
   @IBOutlet weak var breedDescLabel: UILabel!
   @IBOutlet weak var imageView: UIImageView!

   private let favoriteImage = UIImage(named: "favoriteSelected")
   private let unFavoriteImage = UIImage(named: "favoriteUnselected")
   private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 10.0)
   private var indexPath: IndexPath!

   weak var delegate: HomeCollectionCellDelegate?

   var isFavorite: Bool = false {
      didSet {
         let image = isFavorite ? favoriteImage : unFavoriteImage
         imageView.image = image
      }
   }

   override func awakeFromNib() {
      super.awakeFromNib()
      setupUI()
   }

   override func prepareForReuse() {
      super.prepareForReuse()
      breedLabel.text = nil
      breedDescLabel.text = nil
      imageView.image = nil
   }

   func configure(withAnimal animal: AnimalData, atIndexPath indexpath: IndexPath) {
      breedLabel.text = animal.breed
      breedDescLabel.text = animal.breedDescription
      imageView.fetchImage(path: animal.imagePath)
   }

   private func setupUI() {
      breedLabel.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold, maxSize: 22)
      breedDescLabel.font = UIFont.preferredFont(forTextStyle: .title2, weight: .regular, maxSize: 17)
   }

   @IBAction func toggleFavorite(_ sender: Any) {
      self.isFavorite = !self.isFavorite
      delegate?.didSelect(favorite: isFavorite, atIndexPath: indexPath)
   }
}
