//
//  CollectionViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class CollectionViewController: UIViewController {

  // MARK: Outlets

  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: Properties
  var collectionViewModel = CollectionViewModel()

  var savedShopsForDefaultCategory: [CoffeeShop]?

  var inputCategory: String?

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupNavigation()

    setupCollectionView()

    collectionViewModel.fetchUserSavedShopForDefaultCategory(user: UserManager.shared.user)

    collectionViewModel.onFetchUserSavedShopsForDefaultCategory = { result in

      self.savedShopsForDefaultCategory = result

      self.setupCollectionView()
    }
  }

  // MARK: - Functions
  func setupNavigation() {

    navigationController?.navigationBar.barTintColor = .G3

    let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navigateToNextVC))

    addBtn.tintColor = .G1

    navigationItem.rightBarButtonItem = addBtn
  }

 @objc func navigateToNextVC() {

    performSegue(withIdentifier: "navigateToAddCategoryVC", sender: self)
  }

  private func setupCollectionView() {

    collectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)

    collectionView.delegate = self

    collectionView.dataSource = self

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

    return savedShopsForDefaultCategory?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell {

      guard let savedShops = savedShopsForDefaultCategory else { return

        CategoryCollectionViewCell()
      }

      let savedShop = savedShops[indexPath.row]

      cell.mainImgView.image = UIImage(named: "unsplash_protrait_1")

      cell.layoutCategoryCollectionViewCell(from: savedShop.name)

      return cell
    }
    return CategoryCollectionViewCell()
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

extension CollectionViewController: AddCategoryViewControllerDelegate {

  func finishAddCategory(input: String) {
    
    inputCategory = input
  }
}
