//
//  CategoryViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/8.
//

import UIKit

class CategoryViewController: UIViewController {

  // MARK: - Properties
  var collectionViewModel = CollectionViewModel()

  var shopsDocForThisCategory = UserSavedShops()

  var savedShopsInThisCategory: [CoffeeShop] = [] {

    didSet {

      setupTableView()
    }
  }

  var featureDic: [String: [Feature]] = [:] // Use shop.id as key to find [Feature] belongs to which shop

  var recommendItemsDic: [String: [RecommendItem]] = [:]

  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    navigationController?.navigationBar.barTintColor = .G3
    navigationController?.navigationBar.tintColor = .G1

    if !shopsDocForThisCategory.savedShopsByCategory.isEmpty {

      collectionViewModel.fetchSavedShop(shopid: shopsDocForThisCategory.savedShopsByCategory)

      collectionViewModel.onFetchSavedShopsForSpecificCategory = {

        self.savedShopsInThisCategory = self.collectionViewModel.savedShopsForSpecificCategory

        let result = self.savedShopsInThisCategory

        for index in 0..<result.count {

          self.fetchFeatureForShop(shop: result[index])

          self.fetchRecommendItemForShop(shop: result[index])

          let distance = self.calDistanceBetweenTwoLocations(

                location1Lat: LocationManager.shared.currentCoordinate.latitude,

                location1Lon: LocationManager.shared.currentCoordinate.longitude,

                location2Lat: result[index].latitude,

                location2Lon: result[index].longitude)

          self.savedShopsInThisCategory[index].cheap = distance

        }
        self.savedShopsInThisCategory.sort { $0.cheap < $1.cheap }
      }
      setupTableView()

    } else {

      tableView.emptyDataSetSource = self
      tableView.emptyDataSetDelegate = self
      tableView.tableFooterView = UIView()
    }
  }

  // MARK: - Functions
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

  func calDistanceBetweenTwoLocations(location1Lat: Double, location1Lon: Double, location2Lat: Double, location2Lon: Double) -> Double {

    // Use Haversine Formula to calculate the distance in meter between two locations
    // φ is latitude, λ is longitude, R is earth’s radius (mean radius = 6,371km)
    let lat1 = location1Lat
    let lat2 = location2Lat
    let lon1 = location1Lon
    let lon2 = location2Lon

    let earthRadius = 6371000.0

    // swiftlint:disable identifier_name
    let φ1 = lat1 * Double.pi / 180 // φ, λ in radians
    let φ2 = lat2 * Double.pi / 180
    let Δφ = (lat2 - lat1) * Double.pi / 180
    let Δλ = (lon2 - lon1) * Double.pi / 180

    let parameterA = sin(Δφ / 2) * sin(Δφ / 2) + cos(φ1) * cos(φ2) * sin(Δλ / 2) * sin(Δλ / 2)
    let parameterC = 2 * atan2(sqrt(parameterA), sqrt(1 - parameterA))

    let distance = earthRadius * parameterC

    return distance
  }
}
// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return savedShopsInThisCategory.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(
        withIdentifier: "landscapeCardCell", for: indexPath) as? LandscapeCardCell {

      let shop = savedShopsInThisCategory[indexPath.row]
      cell.layoutLandscapeCardCell(shop: shop)

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
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {

}

// MARK: - DZNEmptyDataSet
extension CategoryViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

  func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "此分類目前沒有任何收藏"
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
    return NSAttributedString(string: str, attributes: attrs)
  }

  func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "快把想去的咖啡廳加入收藏吧☺️"
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
    return NSAttributedString(string: str, attributes: attrs)
  }

  func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return UIImage(named: "logo")
  }
}
