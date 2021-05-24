//
//  HomeListViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit
import MapKit

class HomeListViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Properties
  var homeViewModel: HomeViewModel?
  
  var shopsDataForList: [CoffeeShop] = []

  var reviews: [Review] = []

  var featureDic: [String: [Feature]] = [:] // 用shop.id去對

  var userCurrentCoordinate = CLLocationCoordinate2D()

  var mockImages = ["mock_rect1", "mock_rect2", "mock_rect3", "mock_rect4", "mock_rect5"]
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setupTableView()
    
    LocationManager.shared.onCurrentCoordinate = { coordinate in
      
      self.userCurrentCoordinate = coordinate
    }
    
    homeViewModel?.getShopsData = { [weak self] shopsData in
      
      self?.shopsDataForList = shopsData

      for index in 0..<shopsData.count {

        self?.fetchFeatureForShop(shop: shopsData[index])
      }

      self?.tableView.reloadData()
    }
  }

  // MARK: - Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    let selectedRow = sender as? Int

    let selectedShop = shopsDataForList[selectedRow!]

    let featureForSelectedShop = featureDic[selectedShop.id]![0]
    
    if let detailVC = segue.destination as? DetailViewController {
      
      detailVC.shop = selectedShop

      detailVC.feature = featureForSelectedShop
    }
  }

  // MARK: TODO--這兩個是否能夠寫到HomeViewModel去～現在趕時間ＴＡＴ
  func fetchReviewsForShop(shop: CoffeeShop) {

    ReviewManager.shared.fetchReviewsForShop(shop: shop) { [weak self] result in

      switch result {

      case .success(let getReviews):

        self?.reviews = getReviews

      case .failure(let error):

        print("fetchReviewsForShop: \(error)")
      }
    }
  }

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

  func setupTableView() {
    
    tableView.delegate = self

    tableView.dataSource = self
    
    tableView.register(UINib(nibName: "LandscapeCardCell", bundle: nil), forCellReuseIdentifier: "landscapeCardCell")
    
    tableView.estimatedRowHeight = 280

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

      let feature = featureDic[shop.id]
      
      let distance = Int(calDistanceBetweenTwoLocations(location1Lat: userCurrentCoordinate.latitude, location1Lon: userCurrentCoordinate.longitude, location2Lat: shop.latitude, location2Lon: shop.longitude))
      
      cell.cafeMainImage.image = UIImage(named: mockImages.randomElement()!)
      cell.cafeName.text = shop.name

      cell.distance.text = "距離" + String(distance) + "公尺"

      // 先暫時用它ㄉ
      cell.starsView.rating = shop.quiet

      // 這邊是我的Features
      // 營業時間還沒弄原本資料有的會是空的
      cell.openHours.text = shop.openTime
      cell.featureOne.text = feature?[0].atmosphere
      cell.featureTwo.text = feature?[0].socket

      // 這個要計算最多推ㄉ 先顯示就好
      cell.itemOne.text = "燕麥奶拿鐵"
      cell.itemTwo.text = "冷萃咖啡"
      
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
