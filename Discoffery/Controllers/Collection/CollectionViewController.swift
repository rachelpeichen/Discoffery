//
//  CollectionViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import JGProgressHUD
import ESPullToRefresh

class CollectionViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: - Properties
  var collectionViewModel = CollectionViewModel()

  var savedShopsForAllCategory: [UserSavedShops] = []

  var inputCategory: String?

  var selectedCategoryIndex: Int?

  // MARK: - Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

    collectionViewModel.fetchCollectionsForAllCategories(user: UserManager.shared.user)

    collectionViewModel.onFetchSavedShopsForAllCategory = {

      self.savedShopsForAllCategory = self.collectionViewModel.savedShopsForAllCategory

      self.setupCollectionView()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupNavigation()

    let notificationName = Notification.Name("didAddNewCategory")
    NotificationCenter.default.addObserver(self, selector: #selector(updateAllCategories), name: notificationName, object: nil)
  }

  // MARK: - Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    guard let index = selectedCategoryIndex else { return }

    let selectedCategory = savedShopsForAllCategory[index]

    if segue.identifier == "navigateToCategoryVC" {

      if let nextVC = segue.destination as? CategoryViewController {

        nextVC.shopsDocForThisCategory = selectedCategory
      }
    }
  }
  
  func setupNavigation() {

    navigationController?.navigationBar.barTintColor = .G3
    let addCategoryBtn = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(self.navigateToNextVC))
    addCategoryBtn.tintColor = .G1
    navigationItem.rightBarButtonItem = addCategoryBtn
  }

  @objc func navigateToNextVC() {

    performSegue(withIdentifier: "navigateToAddCategoryVC", sender: self)
  }

  @objc func updateAllCategories() {

    collectionViewModel.fetchCollectionsForAllCategories(user: UserManager.shared.user)

    collectionViewModel.onFetchSavedShopsForAllCategory = {

      self.savedShopsForAllCategory = self.collectionViewModel.savedShopsForAllCategory

      self.setupCollectionView()
    }
  }

  private func setupCollectionView() {

    collectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil),
                            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.reloadWithoutAnimation()

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 8

    collectionView.setCollectionViewLayout(layout, animated: true)
  }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedShopsForAllCategory.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier,
                                                     for: indexPath) as? CategoryCollectionViewCell {

      let savedShopByCategory = savedShopsForAllCategory[indexPath.row]

      cell.layoutCategoryCollectionViewCell(from: savedShopByCategory.category)

      return cell
    }
    return CategoryCollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    selectedCategoryIndex = indexPath.row
    performSegue(withIdentifier: "navigateToCategoryVC", sender: indexPath.row)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let minimumInteritemSpacing = 16
    let sectionInsetLeft = 16
    let sectionInsetRight = 16
    let space = CGFloat(minimumInteritemSpacing + sectionInsetLeft + sectionInsetRight)
    let sizePerItem: CGFloat = (collectionView.frame.size.width - space) / 2.0

    return CGSize(width: sizePerItem, height: sizePerItem + 35)
  }
}

extension CollectionViewController: UICollectionViewDelegate {

}
