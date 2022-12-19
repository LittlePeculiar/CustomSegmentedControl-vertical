//
//  ButtonSelectionView.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Combine
import UIKit

protocol ButtonSelectionViewDelegate: AnyObject {
   func didSelect(item: ItemData)
}

class ButtonSelectionView: UIView {
   @IBOutlet weak var contentView: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var selectImageView: UIImageView!

   weak var delegate: ButtonSelectionViewDelegate?
   private var disposeBag = [AnyCancellable]()
   var item: ItemData!
   var isSelected = CurrentValueSubject<Bool, Never>(true)

   func configure(item: ItemData) {
      self.item = item
      titleLabel.text = item.title
      isSelected.send(item.isSelected)
   }

   private func setupBinding() {
      self.isSelected.sink { [weak self] selected in
         guard let self = self else { return }
         DispatchQueue.main.async {
            let name = selected ? "checkboxOn" : "checkbox"
            self.selectImageView.image = UIImage(named: name)
         }
      }
      .store(in: &disposeBag)
   }

   @IBAction func itemSelectedTapped() {
      item.isSelected = !item.isSelected
      isSelected.send(item.isSelected)

      if let delegate = delegate {
         delegate.didSelect(item: self.item)
      }
   }

   // MARK: Init

   private func setupUI() {
      Bundle.main.loadNibNamed(className, owner: self, options: nil)
      addSubview(contentView)
      contentView.frame = self.bounds
      contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

      titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium, maxSize: 13)
      titleLabel.textColor = UIColor.lightGray

      setupBinding()
   }

   override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
      setupUI()
   }
}

