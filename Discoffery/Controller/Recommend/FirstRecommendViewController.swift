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

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//
//    // Do any additional setup after loading the view.
//    recommendViewModel.fetchShopByRecommendItem()
//
//    recommendViewModel.onShopsByRecommendItem = {
//
//      self.shopsForRecommend = self.recommendViewModel.shopsByRecommendItem
//
//      let result = self.shopsForRecommend
//
//      for index in 0..<result.count {
//
//        self.fetchFeatureForShop(shop: result[index])
//
//        self.fetchRecommendItemForShop(shop: result[index])
//      }
//    }
//    setupTableView()
  }

  // MARK: TODO!!!!這兩個是否能夠寫到HomeViewModel去～現在趕時間ＴＡＴ
  func fetchFeatureForShop(shop: CoffeeShop) {

    FeatureManager.shared.fetchFeatureForShop(shop: shop) { [weak self] result in

      switch result {

      case .success(let getFeature):

        self?.featureDic[shop.id] = getFeature

        self?.tableView.reloadData()

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

        self.tableView.reloadData()

      case .failure(let error):

        print("fetchFeatureForShop: \(error)")
      }
    }
  }

  private func setupTableView() {

    tableView.delegate = self

    tableView.dataSource = self

    tableView.register(UINib(nibName: "LandscapeCardCell", bundle: nil), forCellReuseIdentifier: "landscapeCardCell")

    tableView.register(UINib(nibName: "ShopFeatureCell", bundle: nil), forCellReuseIdentifier: "shopFeatureCell")

    tableView.estimatedRowHeight = 320

    tableView.rowHeight = UITableView.automaticDimension

    tableView.separatorStyle = .none

    tableView.reloadData()
  }

}

extension FirstRecommendViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return shopsForRecommend.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(
        withIdentifier: "landscapeCardCell", for: indexPath) as? LandscapeCardCell {

      let shop = shopsForRecommend[indexPath.row]

      let mockImages = ["mock_rect1", "mock_rect2", "mock_rect3", "mock_rect4", "mock_rect5"]

      cell.cafeMainImage.image = UIImage(named: mockImages.randomElement()!)

      cell.cafeName.text = shop.name

      cell.distance.text = ""

      cell.starsView.rating = shop.tasty

      cell.openHours.text = "疫情暫停營業"

      guard let recommendItemsArr = recommendItemsDic[shop.id] else { return UITableViewCell() }

      var itemLayoutArr: [String] = []

      itemLayoutArr.append(contentsOf: recommendItemsArr.map { $0.item })

      cell.configureItem(with: itemLayoutArr)

      guard let featureArr = featureDic[shop.id] else { return UITableViewCell() }

      var featureLayoutArr = featureArr[0].special

      featureLayoutArr.append(featureArr[0].timeLimit)

      cell.configureFeature(with: featureLayoutArr)

      cell.selectionStyle = .none

      return cell
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    // 連接到Detail VC
//    performSegue(withIdentifier: "navigateToDetailVC", sender: indexPath.row)
  }
}

extension FirstRecommendViewController: UITableViewDelegate {
  // Do sth
}
