//
//  HomeListViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit
import MapKit
import ESPullToRefresh

class HomeListViewController: UIViewController {

  // MARK: - Properties
  var homeViewModel = HomeViewModel()
  
  var shopsDataForList: [CoffeeShop] = []
  
  // Use shop.id as the key to find [Feature] belongs to which shop
  var featureDic: [String: [Feature]] = [:]

  var recommendItemsDic: [String: [RecommendItem]] = [:]

  var userCurrentCoordinate = CLLocationCoordinate2D()

  var userSavedShopsArr: [String] = []

  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setupTableView()

    homeViewModel.onShopsDataForList = { [weak self] shopsData in

      self?.shopsDataForList = shopsData

      for index in 0..<shopsData.count {

        self?.fetchFeatureForShop(shop: shopsData[index])

        self?.fetchRecommendItemForShop(shop: shopsData[index])

        if let coordinate = self?.homeViewModel.userCurrentCoordinate {

          if let distance = self?.calDistanceBetweenTwoLocations(location1Lat: coordinate.latitude,
                                                                 location1Lon: coordinate.longitude,
                                                                 location2Lat: shopsData[index].latitude,
                                                                 location2Lon: shopsData[index].longitude) {
            self?.shopsDataForList[index].cheap = distance
          }
        }
      }
      self?.shopsDataForList.sort { $0.cheap < $1.cheap }
    }

    // MARK: Header to show last updated time for refreshing data
    tableView.es.addPullToRefresh { [unowned self] in

      print(0) // Do update data stuff
      self.tableView.es.stopPullToRefresh()
    }

    // MARK: Footer to show loading more data and no more data
    tableView.es.addInfiniteScrolling { [unowned self] in

      print(1) // Do load more data stuff
      tableView.es.stopLoadingMore()
      tableView.es.noticeNoMoreData()
    }
  }

  // MARK: - Prepare Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let selectedRow = sender as? Int {

      let selectedShop = shopsDataForList[selectedRow]
      let featureForSelectedShop = featureDic[selectedShop.id]?[0]
      let recommendItemsForSelectedShop = recommendItemsDic[selectedShop.id]

      if let detailVC = segue.destination as? DetailViewController {

        guard let feature = featureForSelectedShop else { return }
        guard let recommendItemsArr = recommendItemsForSelectedShop else { return }

        detailVC.shop = selectedShop
        detailVC.feature = feature
        detailVC.recommendItemsArr = recommendItemsArr
      }
    }
  }

  // TODO: Need to move to HomeViewModel
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

  // MARK: - Private Functions
  private func setupTableView() {
    
    tableView.register(UINib(nibName: LandscapeCardCell.identifier, bundle: nil),
                       forCellReuseIdentifier: LandscapeCardCell.identifier)

    tableView.register(UINib(nibName: ShopFeatureCell.identifier, bundle: nil),
                       forCellReuseIdentifier: ShopFeatureCell.identifier)

    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 320
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension HomeListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return shopsDataForList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(
        withIdentifier: LandscapeCardCell.identifier, for: indexPath) as? LandscapeCardCell {
      
      let shop = shopsDataForList[indexPath.row]

      cell.layoutLandscapeCell(shop: shop)

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

    performSegue(withIdentifier: "navigateToDetailVC", sender: indexPath.row)
  }
}

// MARK: - UITableViewDelegate
extension HomeListViewController: UITableViewDelegate {
}
