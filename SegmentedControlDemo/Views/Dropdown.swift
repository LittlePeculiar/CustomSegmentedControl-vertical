//
//  Dropdown.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Combine
import UIKit

protocol DropdownDelegate: AnyObject {
   func dropDown(_ dropDown: Dropdown, selectedOption: Int?)
   func isCollapsed(collapsed: Bool)
}
extension DropdownDelegate {
   func isCollapsed(collapsed: Bool) {}
}

class Dropdown: UIView {
   @IBOutlet weak var contentView: UIView!
   @IBOutlet weak var selectedLabel: UILabel!
   @IBOutlet weak var chevronImageView: UIImageView!
   @IBOutlet weak var collapsableStackView: UIStackView!
   @IBOutlet weak var listStackView: UIStackView!
   @IBOutlet weak var buttonContainerView: UIView!

   weak var delegate: DropdownDelegate?
   var disposeBag = [AnyCancellable]()
   var isCollapsed = CurrentValueSubject<Bool, Never>(true)
   var options = [String]()

   func configure(withOption options: [String]) {
      guard !options.isEmpty else { return }

      self.options = options
      isCollapsed.send(true)
      build(options: options)

      let option = options[0]
      self.selectedLabel.text = option
   }

   private func build(options: [String]) {
      listStackView.arrangedSubviews.forEach {
         $0.removeFromSuperview()
      }

      let stacks = UIStackView()
      stacks.axis = .vertical

      for (index, option) in options.enumerated() {
         let item = ItemData(title: option)
         let buttonSelectionView = ButtonSelectionView()
         buttonSelectionView.configure(item: item)
         buttonSelectionView.tag = index
         buttonSelectionView.delegate = self
         stacks.addArrangedSubview(buttonSelectionView)
      }
      self.listStackView.addArrangedSubview(stacks)
      self.layoutIfNeeded()
   }

   private func setupUI() {
      Bundle.main.loadNibNamed(className, owner: self, options: nil)
      addSubview(contentView)
      contentView.frame = self.bounds
      contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

      selectedLabel.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium, maxSize: 13)
      selectedLabel.textColor = UIColor.lightGray

      let cornerRadius = 11.0
      buttonContainerView.layer.cornerRadius = cornerRadius
      buttonContainerView.clipsToBounds = true
      buttonContainerView.backgroundColor = .white

      setupBinding()
   }

   private func setupBinding() {

      self.isCollapsed.sink { [weak self] collapsed in
         guard let self = self else { return }
         DispatchQueue.main.async {
             self.delegate?.isCollapsed(collapsed: collapsed)
            // if using something other than default chevron
            let name = collapsed ? "chevronDown" : "chevronUp"
            self.chevronImageView.image = UIImage(named: name)
            self.collapsableStackView.isHidden = collapsed
         }
      }
      .store(in: &disposeBag)
   }

   @IBAction func toggleCollapsable(_ sender: Any) {
      let collapse = self.isCollapsed.value
      self.isCollapsed.send(!collapse)
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

extension Dropdown: ButtonSelectionViewDelegate {
   func didSelect(item: ItemData) {
      self.selectedLabel.text = item.title

      // unselect all except the one currently selected
      if !listStackView.arrangedSubviews.isEmpty {
         if let stack = listStackView.arrangedSubviews.first as? UIStackView {
            for view in stack.arrangedSubviews {
               if let buttonView = view as? ButtonSelectionView {
                  let isSelected = buttonView.item.title == item.title
                  buttonView.isSelected.send(isSelected)
                  if isSelected {
                     delegate?.dropDown(self, selectedOption: buttonView.tag)
                     isCollapsed.send(true)
                  }
               }
            }
         }
      }
   }
}
