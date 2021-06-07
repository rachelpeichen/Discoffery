//
//  CollectionViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import JGProgressHUD

class CollectionViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: - Properties
  var collectionViewModel = CollectionViewModel()

  var savedShopsForDefaultCategory: [CoffeeShop] = [] {

    didSet {

      setupCollectionView()
    }
  }

  var featureDic: [String: [Feature]] = [:]

  var recommendItemsDic: [String: [RecommendItem]] = [:]

  var inputCategory: String?

  var selectedShopIndex: Int?

  // MARK: - Life Cycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

    let hud = JGProgressHUD()
    hud.textLabel.text = "Loading"
    hud.show(in: self.view)
    hud.dismiss(afterDelay: 1.0)

    collectionViewModel.fetchUserSavedShopForDefaultCategory(user: UserManager.shared.user)

    collectionViewModel.onFetchUserSavedShopsForDefaultCategory = {

      self.savedShopsForDefaultCategory = self.collectionViewModel.savedShopsForDefaultCategory

      let result = self.savedShopsForDefaultCategory

      for index in 0..<result.count {

        self.fetchFeatureForShop(shop: result[index])

        self.fetchRecommendItemForShop(shop: result[index])
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupNavigation()
  }

  // MARK: - Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    guard let selectedShopIndex = selectedShopIndex else { return }

    let selectedShop = savedShopsForDefaultCategory[selectedShopIndex]

    if segue.identifier == "navigateFromCollectionVC" {

      if let detailVC = segue.destination as? DetailViewController {

        detailVC.shop = selectedShop

        guard let featureArr = featureDic[selectedShop.id] else { return }

        detailVC.feature = featureArr[0]

        guard let recommendItemsArr = recommendItemsDic[selectedShop.id] else { return }

        detailVC.recommendItemsArr = recommendItemsArr
      }
    }
  }
  
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

    collectionView.reloadWithoutAnimation()

    let layout = UICollectionViewFlowLayout()

    layout.scrollDirection = .vertical

    layout.minimumLineSpacing = 8

    layout.minimumInteritemSpacing = 8

    collectionView.setCollectionViewLayout(layout, animated: true)
  }

  // MARK: TODO這兩個是否能夠寫到HomeViewModel去～現在趕時間ＴＡＴ
  func fetchFeatureForShop(shop: CoffeeShop) {

    FeatureManager.shared.fetchFeatureForShop(shop: shop) { [weak self] result in

      switch result {

      case .success(let getFeature):

        self?.featureDic[shop.id] = getFeature

      case .failure(let error):

        print("fetchFeatureForShop: \(error)")
      }
    }
  }

  func fetchRecommendItemForShop(shop: CoffeeShop) {

    RecommendItemManager.shared.fetchRecommendItemForShop(shop: shop) { result in

      switch result {

      case .success(let getItems):

        self.recommendItemsDic[shop.id] = getItems

      case .failure(let error):

        print("fetchFeatureForShop: \(error)")
      }
    }
  }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return savedShopsForDefaultCategory.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell {

      let savedShop = savedShopsForDefaultCategory[indexPath.row]

      cell.layoutCategoryCollectionViewCell(from: savedShop.name)

      // MARK: 這是暫時的！！！為了Demo好看用的！！

      let mockImages = ["mock_rect1", "mock_rect2", "mock_rect3", "mock_rect4", "mock_rect5"]

      cell.mainImgView.image = UIImage(named: mockImages [indexPath.row])

      return cell
    }
    return CategoryCollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    selectedShopIndex = indexPath.row

    let storyboard = UIStoryboard.main

    if storyboard.instantiateViewController(withIdentifier: "DetailVC") is DetailViewController {

      performSegue(withIdentifier: "navigateFromCollectionVC", sender: indexPath.row)
    }
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
