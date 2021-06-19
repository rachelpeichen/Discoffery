//
//  SearchResultViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/12.
//

import UIKit
import JGProgressHUD

class SearchResultViewController: UIViewController {

  // MARK: - Properties
  var searchViewModel = SearchViewModel()

  var shopsAroundUserArr: [CoffeeShop] = []

  var searchResultArr: [CoffeeShop] = []

  var recommendItemsDic: [String: [RecommendItem]] = [:] // Use shop.id as key to find [RecommendItem] belongs to which shop

  var featureDic: [String: [Feature]] = [:] // now no use this

  var keyword: String?

  var mockImages = ["rect1", "rect2", "rect3", "rect4", "rect5"]

  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var searchResultCount: UILabel!

  // MARK: - IBActions
  @IBAction func backToPreviousVC(_ sender: Any) {

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - View Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.

    showLoadingHUD()
    
    setupTableView()

    // MARK: *Flow* fetch shop  -> fetch item for shop -> filter item == keyword -> sort by distance
    // 1: Search shops within distance on Firebase; default is 2000 m 我家偏僻用3000
    searchViewModel.getShopAroundUser(distance: 3000)

    let dispatchGroup = DispatchGroup()

    searchViewModel.onSearchShopsData = { [weak self] shopsData in

      self?.shopsAroundUserArr = shopsData

      // 2: Search each shop's RecommendItem and *get successs call back*
      for index in 0..<shopsData.count {

        let shop = shopsData[index]

        dispatchGroup.enter() // Enter before fetching on Firebase

        self?.searchViewModel.fetchRecommendItemForShop(shop: shop)

        self?.searchViewModel.onShopRecommendItem = { result in

          self?.recommendItemsDic[shop.id] = result

          dispatchGroup.leave()
        }
      }
    }

    dispatchGroup.notify(queue: .main) {

      // 3: Filter shopsAroundUser by keyword
      if let keyword = self.keyword {

        self.filterShopsAroundUser(keyword: keyword)
      }

      // 4: Show filtered result in ascending order of distance between user
      self.sortSearchResult()
      self.tableView.reloadData()
    }
  }

  // MARK: - Functions
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

  func filterShopsAroundUser(keyword: String) {

    for index in 0..<shopsAroundUserArr.count {

      let shop = shopsAroundUserArr[index]

      if let recommendItemsArrForEachShop = recommendItemsDic[shop.id] {

        for index in 0..<recommendItemsArrForEachShop.count {

          if recommendItemsArrForEachShop[index].item == keyword {

            searchResultArr.append(shop)
          }
        }
        print("篩選完關鍵字的shop array = \(searchResultArr)")
      }
    }

    descriptionLabel.text = keyword + "的搜尋結果如下："
    searchResultCount.text = String(self.searchResultArr.count)
  }

  func sortSearchResult() {

    for index in 0..<searchResultArr.count {

      if let coordinate = self.searchViewModel.userCurrentCoordinate {

        let distance = self.calDistanceBetweenTwoLocations(

          location1Lat: coordinate.latitude,

          location1Lon: coordinate.longitude,

          location2Lat: searchResultArr[index].latitude,

          location2Lon: searchResultArr[index].longitude)

        searchResultArr[index].cheap = distance
      }
    }
    searchResultArr.sort { $0.cheap < $1.cheap }
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
extension SearchResultViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return searchResultArr.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(
        withIdentifier: "landscapeCardCell", for: indexPath) as? LandscapeCardCell {

      let shop = searchResultArr[indexPath.row]
      // swiftlint:disable force_unwrapping
      cell.imgView.image = UIImage(named: mockImages.randomElement()!)
      cell.name.text = shop.name
      cell.distance.text = "距離\(shop.cheap.rounded().formattedValue)公尺"
      cell.rateStarsView.rating = shop.tasty
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
    return LandscapeCardCell()
  }
}

// MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate {
}
