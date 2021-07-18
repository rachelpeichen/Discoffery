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

  // MARK: - IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: - View Life Cycle
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

  // MARK: - Private Functions
  private func setupCollectionView() {

    collectionView.register(UINib(nibName: ProtraitCardCollectionCell.identifier, bundle: nil),
                            forCellWithReuseIdentifier: ProtraitCardCollectionCell.identifier)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.emptyDataSetDelegate = self
    collectionView.emptyDataSetSource = self
    collectionView.reloadWithoutAnimation()

    setUpWaterfallCollectionView()
  }

  private func setUpWaterfallCollectionView() {

    let layout = CHTCollectionViewWaterfallLayout()
    layout.minimumColumnSpacing = 16.0
    layout.minimumInteritemSpacing = 16.0
    self.collectionView.collectionViewLayout = layout
  }
}

// MARK: - UICollectionViewDataSource
extension FirstRecommendViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return shopsForRecommend.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProtraitCardCollectionCell.identifier,
                                                     for: indexPath) as? ProtraitCardCollectionCell {

      let shop = shopsForRecommend[indexPath.row]
      let mockImages =
        ["protrait1", "protrait2", "protrait3", "protrait4", "protrait5", "protrait6"]

      // swiftlint:disable force_unwrapping
      cell.image.image = UIImage.init(named: mockImages.randomElement()!)
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

// MARK: - DZNEmptyDataSet
extension FirstRecommendViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  // Now cannot show below
  func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "目前沒有可以推薦給您的店家"
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
    return NSAttributedString(string: str, attributes: attrs)
  }

  func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "試試別的頁面吧"
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
    return NSAttributedString(string: str, attributes: attrs)
  }

  func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return UIImage(named: "logo")
  }
}
