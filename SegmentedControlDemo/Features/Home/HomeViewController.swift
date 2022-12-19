//
//  HomeViewController.swift
//  SegmentedControlDemo
//
//  Created by Gina Mullins on 12/14/22.
//


import Combine
import UIKit

class HomeViewController: UIViewController {
   @IBOutlet weak var collectionView: UICollectionView!
   @IBOutlet weak var sidePanelView: UIView!
   @IBOutlet weak var collectionContainer: UIView!
   @IBOutlet weak var noFavoritesContainer: UIView!
   @IBOutlet weak var noFavoritesTitle: UILabel!
   @IBOutlet weak var noFavoritesText: UILabel!
   @IBOutlet weak var dropdownListView: DropdownListView!
   @IBOutlet weak var detailView: DetailView!
   @IBOutlet weak var productDetailXConstraint: NSLayoutConstraint!

   @IBOutlet weak var tabControl: CustomSegmentedControl! {
      didSet {
         let options = HomeTabOption.allOptions.map({ $0.name })
         let icons = HomeTabOption.allOptions.map({ $0.icon })
         tabControl.setButtonTitles(buttonTitles: options)
         tabControl.setButtonIcons(buttonIcons: icons)
      }
   }

   private var disposeBag = [AnyCancellable]()
   private var viewModel = HomeViewModel()
   private var pendingRequestWorkItem: DispatchWorkItem?

   override func viewDidLoad() {
      super.viewDidLoad()
      self.navigationController?.navigationBar.isHidden = true

      setupUI()
      setupBinding()
   }

   func setupUI() {
      registerCollectionCells()

      tabControl.delegate = self
      dropdownListView.delegate = self
      detailView.delegate = self
      productDetail(show: false)

      noFavoritesTitle.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold, maxSize: 22)
      noFavoritesTitle.textColor = UIColor.blue
      noFavoritesText.font = UIFont.preferredFont(forTextStyle: .headline, weight: .medium, maxSize: 17)
      noFavoritesText.textColor = UIColor.blue
   }

   private func registerCollectionCells() {
      collectionView?.collectionViewLayout = LeftAlignFlowLayout()
      collectionView?.contentInsetAdjustmentBehavior = .always

      HomeCollectionCell.registerWithCollectionView(collectionView: collectionView)
      collectionView.delegate = self
      collectionView.dataSource = self
   }

   private func setupBinding() {
      viewModel.animals
         .receive(on: DispatchQueue.main).sink  { [weak self] animalData in
            guard let animals = animalData else { return }
            guard let self = self else { return }
            let option = self.viewModel.homeOption.value
            if option == .favorites {
              self.noFavoritesContainer.isHidden = !animals.isEmpty
            }
            self.collectionView.reloadData()
         }
         .store(in: &disposeBag)

      viewModel.homeOption
         .receive(on: DispatchQueue.main).sink{ [weak self] selectedOption in
            guard let self = self else { return }
            self.noFavoritesContainer.isHidden = true
            self.viewModel.getData()
            let titles = self.viewModel.categories
            let title = titles.first ?? ""
            let subtitles = self.viewModel.getSubcategories(forCategory: title)
            self.dropdownListView.configure(titles: titles, subtitles: subtitles, isCollapsable: true)
            self.viewModel.selectedCategory.send(title)
         }
        .store(in: &disposeBag)

      viewModel.selectedCategory
         .receive(on: DispatchQueue.main).sink { selected in
            print("selectedCategory triggered")
      }
      .store(in: &disposeBag)

      viewModel.selectedSubCategory
         .receive(on: DispatchQueue.main).sink { selected in
            print("selectedSubCategory triggered")
      }
      .store(in: &disposeBag)
   }

   private func productDetail(show: Bool) {
      if show {
         UIView.animate(withDuration: 0.3, delay: 0 , options: .curveEaseOut, animations: {[weak self] in
            self?.productDetailXConstraint.constant = 0
            self?.view.layoutIfNeeded()
         }, completion: nil)
      } else {
         UIView.animate(withDuration: 0.3, delay: 0 , options: .curveEaseOut, animations: {[weak self] in
            let posX = (self?.view.frame.size.width ?? 1500) + CGFloat(100)
            self?.productDetailXConstraint.constant = posX
            self?.view.layoutIfNeeded()
         }, completion: nil)
      }
   }
}

// MARK: - CollectionView Handling
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      guard let animals = viewModel.animals.value else { return 0}
      return animals.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let animals = viewModel.animals.value else { return UICollectionViewCell() }
      let option = viewModel.homeOption.value
      print("loading for \(option)")

      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell else { return UICollectionViewCell() }

      let animal = animals[indexPath.row]
      cell.configure(withAnimal: animal, atIndexPath: indexPath)
      cell.delegate = self
      return cell
   }

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      guard let animals = viewModel.animals.value else { return }
      let animal = animals[indexPath.row]
      detailView.configure(animal: animal)
      productDetail(show: true)
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 250, height: 400)
   }
}

extension HomeViewController: HomeCollectionCellDelegate {
   func didSelect(favorite: Bool, atIndexPath indexPath: IndexPath) {
      print("favorite: \(favorite) at \(indexPath)")
   }
}

extension HomeViewController: CustomSegmentedControlDelegate {
   func change(to index: Int) {
      if let option = HomeTabOption(rawValue: index) {
         viewModel.homeOption.send(option)
      }
   }
}

extension HomeViewController: DetailViewDelegate {
   func dismissDetail() {
      productDetail(show: false)
   }
}

extension HomeViewController: DropdownListViewDelegate {
   func didSelectFromDropdown(title: String, atIndex index: Int) {
      viewModel.selectedCategory.send(title)
      viewModel.selectedSubCategory.send(nil)
   }
   func didSelectFromTab(title: String, atIndex index: Int) {
      viewModel.selectedSubCategory.send(title)
   }
}


