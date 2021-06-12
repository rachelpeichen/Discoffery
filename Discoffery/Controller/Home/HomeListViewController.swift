//
//  HomeListViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit
import MapKit

class HomeListViewController: UIViewController {

  // MARK: - Properties
  var homeViewModel: HomeViewModel?
  
  var shopsDataForList: [CoffeeShop] = []

  var featureDic: [String: [Feature]] = [:] // Use shop.id as key to find [Feature] belongs to which shop

  var recommendItemsDic: [String: [RecommendItem]] = [:]

  var userCurrentCoordinate = CLLocationCoordinate2D()

  var mockImages = ["mock_rect1", "mock_rect2", "mock_rect3", "mock_rect4", "mock_rect5"]

  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!

  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setupTableView()
    
    // HomeMapVC和HomeListVC共用一個HomeViewModel 不能各自呼叫HomeViewModel的方法 會覆蓋掉 當HomeListVC 呼叫方法時 shopsdata就已經存進HomeViewModel了！！ LocationManager也是 所以直接去拿HomeViewModel的屬性
    homeViewModel?.onShopsData = { [weak self] shopsData in

      self?.shopsDataForList = shopsData

      for index in 0..<shopsData.count {

        self?.fetchFeatureForShop(shop: shopsData[index])

        self?.fetchRecommendItemForShop(shop: shopsData[index])

        if let coordinate = self?.homeViewModel?.userCurrentCoordinate {

         if let distance = self?.calDistanceBetweenTwoLocations(

            location1Lat: coordinate.latitude,

            location1Lon: coordinate.longitude,

            location2Lat: shopsData[index].latitude,

            location2Lon: shopsData[index].longitude) {

          self?.shopsDataForList[index].cheap = distance
         }
        }
      }
      self?.shopsDataForList.sort { $0.cheap < $1.cheap }
    }
  }

  // MARK: - Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    // MARK: 處理驚嘆號
    let selectedRow = sender as? Int

    let selectedShop = shopsDataForList[selectedRow!]

    let featureForSelectedShop = featureDic[selectedShop.id]![0]

    let recommendItemsForSelectedShop = recommendItemsDic[selectedShop.id]!
    
    if let detailVC = segue.destination as? DetailViewController {
      
      detailVC.shop = selectedShop

      detailVC.feature = featureForSelectedShop

      detailVC.recommendItemsArr = recommendItemsForSelectedShop
    }
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

extension HomeListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return shopsDataForList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(
        withIdentifier: "landscapeCardCell", for: indexPath) as? LandscapeCardCell {
      
      let shop = shopsDataForList[indexPath.row]
      
      cell.cafeMainImage.image = UIImage(named: mockImages.randomElement()!)
      
      cell.cafeName.text = shop.name

      cell.distance.text = "距離\(shop.cheap.rounded().formattedValue)公尺"

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
    
    performSegue(withIdentifier: "navigateToDetailVC", sender: indexPath.row)
  }
}

extension HomeListViewController: UITableViewDelegate {
  // Do sth
}
