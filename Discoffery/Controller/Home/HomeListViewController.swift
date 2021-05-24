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
      
      self?.tableView.reloadData()
    }
  }

  // MARK: - Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let selectedRow = sender as? Int
    
    if let detailVC = segue.destination as? DetailViewController {
      
      detailVC.shop = self.shopsDataForList[selectedRow!]
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
      
      let distance = Int(calDistanceBetweenTwoLocations(location1Lat: userCurrentCoordinate.latitude, location1Lon: userCurrentCoordinate.longitude, location2Lat: shop.latitude, location2Lon: shop.longitude))
      
      cell.cafeMainImage.image = UIImage(named: mockImages.randomElement()!)
      cell.cafeName.text = shop.name
      cell.starsView.rating = 4.3
      cell.distance.text = "距離" + String(distance) + "公尺"
      cell.openHours.text = shop.limitedTime
      cell.featureOne.text = "插座：" + shop.socket
      cell.featureTwo.text = "冷氣超涼讚啦"
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
