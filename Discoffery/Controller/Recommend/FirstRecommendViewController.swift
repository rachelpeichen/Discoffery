//
//  FirstRecommendViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/8.
//

import UIKit

class FirstRecommendViewController: UIViewController {

  // MARK: - Properties
  var recommendViewModel = RecommendViewModel()

  var shopsForRecommend: [CoffeeShop] = []

  var featureDic: [String: [Feature]] = [:] // Use shop.id as key to find [Feature] belongs to which shop

  var recommendItemsDic: [String: [RecommendItem]] = [:]

  @IBOutlet weak var collectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    recommendViewModel.getShopAroundUser(distance: 2000)

    recommendViewModel.onRecommendShopAroundUser = { [weak self] shopsData in

      self?.shopsForRecommend = shopsData

      for index in 0..<shopsData.count {

        let shop = shopsData[index]

        self?.recommendViewModel.fetchRecommendItemsForShop(shop: shop)

        self?.recommendViewModel.onShopRecommendItems = { result in

          self?.recommendItemsDic[shop.id] = result
        }
      }
      self?.setupCollectionView()
    }
  }

  // MARK: - Functions
  private func setupCollectionView() {

    collectionView.register(UINib(nibName: ProtraitCardCollectionCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProtraitCardCollectionCell.identifier)

    collectionView.delegate = self

    collectionView.dataSource = self

    collectionView.reloadWithoutAnimation()

    let layout = CHTCollectionViewWaterfallLayout()

    layout.minimumColumnSpacing = 16.0

    layout.minimumInteritemSpacing = 16.0

    self.collectionView.collectionViewLayout = layout
  }
}
extension FirstRecommendViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return shopsForRecommend.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProtraitCardCollectionCell.identifier, for: indexPath) as? ProtraitCardCollectionCell {

      let shop = shopsForRecommend[indexPath.row]

      // MARK: 這是為了demo上app store要改掉！
      let mockImages = ["mock_protrait_1", "mock_protrait_2", "mock_protrait_3", "mock_protrait_4", "mock_protrait_5", "mock_protrait_6", "mock_protrait_1", "mock_protrait_2", "mock_protrait_3", "mock_protrait_4", "mock_protrait_5", "mock_protrait_6", "mock_protrait_4", "mock_protrait_5", "mock_protrait_6","mock_protrait_4", "mock_protrait_5", "mock_protrait_6"]

      cell.image.image = UIImage.init(named: mockImages[indexPath.row])

      cell.name.text = shop.name
      return cell
    }
    return CategoryCollectionViewCell()
  }
}

extension FirstRecommendViewController: CHTCollectionViewDelegateWaterfallLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let itemHeight = Int.random(in: 200...300)

    return CGSize(width: 150, height: itemHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int {
    return 2
  }
}

extension FirstRecommendViewController: UICollectionViewDelegate {
}
