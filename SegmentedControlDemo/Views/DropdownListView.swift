//
//  DropdownListView.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//

import Combine
import UIKit

protocol DropdownListViewDelegate: AnyObject {
   func didSelectFromDropdown(title: String, atIndex index: Int)
   func didSelectFromTab(title: String, atIndex index: Int)
}
extension DropdownListViewDelegate {
   func didSelectFromDropdown(title: String, atIndex index: Int) {}
   func didSelectFromTab(title: String, atIndex index: Int) {}
}

class DropdownListView: UIView {
   @IBOutlet weak var contentView: UIView!
   @IBOutlet weak var buttonContainer: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var selectedLabel: UILabel!
   @IBOutlet weak var chevronImageView: UIImageView!
   @IBOutlet weak var collapseButton: UIButton!
   @IBOutlet weak var segmentedContainerHeightconstraint: NSLayoutConstraint!
   @IBOutlet weak var dropDown: Dropdown!
   @IBOutlet weak var verticalTab: CustomSegmentedControl! {
      didSet {
         verticalTab.isUnderline = true
      }
   }

   weak var delegate: DropdownListViewDelegate?
   var disposeBag = [AnyCancellable]()
   var isCollapsed = CurrentValueSubject<Bool, Never>(true)
   var title: String!
   var buttonTitles: [String] = []
   var subtitles: [String] = []
   var isCollapsable: Bool = false

   func configure(titles: [String], subtitles: [String] = [], isCollapsable: Bool = false) {
      guard titles.count > 0 else { return }

      dropDown.isHidden = !isCollapsable
      chevronImageView.isHidden = !isCollapsable
      collapseButton.isEnabled = isCollapsable

      if isCollapsable {
         dropDown.configure(withOption: titles)
         dropDown.delegate = self
      } else {
         setSelected(text: titles[0])
      }

      let display = subtitles.isEmpty ? titles : subtitles
      verticalTab.setButtonTitles(buttonTitles:display, isVertical: true)

      self.buttonTitles = titles
      self.subtitles = subtitles
      self.isCollapsable = isCollapsable
   }

   func setSelected(text: String) {
      self.selectedLabel.text = text
   }

   func refresh(titles: [String]) {
      self.subtitles = titles
      verticalTab.setButtonTitles(buttonTitles:titles, isVertical: true)
   }

   private func setupUI() {
      Bundle.main.loadNibNamed(className, owner: self, options: nil)
      addSubview(contentView)
      contentView.frame = self.bounds
      contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

      titleLabel.font = UIFont.preferredFont(forTextStyle: .callout, weight: .bold, maxSize: 13)
      titleLabel.textColor = UIColor.blue
      selectedLabel.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium, maxSize: 13)
      selectedLabel.textColor = UIColor.lightGray

      let cornerRadius = 11.0
      buttonContainer.layer.cornerRadius = cornerRadius
      buttonContainer.clipsToBounds = true
      buttonContainer.backgroundColor = .white
      buttonContainer.layer.borderWidth = 1
      buttonContainer.layer.borderColor = UIColor.lightGray.cgColor

      setupBinding()
      verticalTab.delegate = self
   }

   private func setupBinding() {
      self.isCollapsed.sink { [weak self] collapsed in
         guard let self = self else { return }
         guard self.isCollapsable else { return }
         let name = collapsed ? "chev-down" : "chev-up"
         self.chevronImageView.image = UIImage(named: name)
         self.showTable(isCollapsed: collapsed)
      }
      .store(in: &disposeBag)
   }

   private func showTable(isCollapsed: Bool) {
      if isCollapsed {
         UIView.animate(withDuration: 0.3, delay: 0 , options: .curveEaseOut, animations: {[weak self] in
            self?.segmentedContainerHeightconstraint.constant = 0
         }, completion: nil)
      } else {
         UIView.animate(withDuration: 0.3, delay: 0 , options: .curveEaseOut, animations: {[weak self] in
            self?.segmentedContainerHeightconstraint.constant = 516
            self?.layoutIfNeeded()
         }, completion: nil)
      }
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

// MARK: CustomSegmentedControlDelegate handling
extension DropdownListView: CustomSegmentedControlDelegate {
   func change(to index: Int) {
      let display = subtitles.isEmpty ? buttonTitles : subtitles
      let title = display[index]
      delegate?.didSelectFromTab(title: title, atIndex: index)
   }
}

extension DropdownListView: DropdownDelegate {
   func dropDown(_ dropDown: Dropdown, selectedOption: Int?) {
      guard let index = selectedOption, buttonTitles.count > index else { return }
      let title = buttonTitles[index]
      delegate?.didSelectFromDropdown(title: title, atIndex: index)
   }
}

