//
//  DetailView.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Combine
import UIKit

protocol DetailViewDelegate: AnyObject {
   func dismissDetail()
}

class DetailView: UIView {
   @IBOutlet weak var contentView: UIView!
   @IBOutlet weak var backLabel: UILabel!
   @IBOutlet weak var animalLabel: UILabel!
   @IBOutlet weak var descLabel: UILabel!
   @IBOutlet weak var imageView: UIImageView!

   private var isCollapsed = CurrentValueSubject<Bool, Never>(true)
   var disposeBag = [AnyCancellable]()
   weak var delegate: DetailViewDelegate?

   func configure(animal: AnimalData) {
      animalLabel.text = animal.breed
      descLabel.text = animal.breedDescription
      imageView.fetchImage(path: animal.imagePath)
   }

   @IBAction func backButtonTapped(_ sender: Any) {
      delegate?.dismissDetail()
   }

   @IBAction func toggleCollapsable(_ sender: Any) {
      let collapse = self.isCollapsed.value
      self.isCollapsed.send(!collapse)
   }

   private func setupUI() {
      Bundle.main.loadNibNamed(className, owner: self, options: nil)
      addSubview(contentView)
      contentView.frame = self.bounds
      contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

      backLabel.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .bold, maxSize: 13)
      backLabel.textColor = UIColor.blue

      animalLabel.font = UIFont.preferredFont(forTextStyle: .callout, weight: .bold, maxSize: 13)
      animalLabel.textColor = UIColor.black

      descLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium, maxSize: 15)
      descLabel.textColor = UIColor.black
   }

   // MARK: Init

   override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
      setupUI()
   }
}
