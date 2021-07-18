//
//  SearchResultViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/12.
//

import UIKit
import JGProgressHUD

class SearchResultViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var searchResultCount: UILabel!

  // MARK: - IBActions
  @IBAction func backToPreviousVC(_ sender: Any) {

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Properties
  var searchViewModel = SearchViewModel()

  var shopsAroundUserArr: [CoffeeShop] = []

  var searchResultArr: [CoffeeShop] = []

  var recommendItemsDic: [String: [RecommendItem]] = [:] // Use shop.id as key to find [RecommendItem] belongs to which shop

  var keyword: String?

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    // MARK: *Flow* fetch shop  -> fetch item for shop -> filter item == keyword -> sort by distance
    // 1: Search shops within distance on Firebase; default is 2000 m
    searchViewModel.getShopAroundUser(distance: 2000)

    searchViewModel.onSearchShopsData = { [weak self] shopsData in

      self?.shopsAroundUserArr = shopsData

      // 2: Search each shop's RecommendItem and *get successs call back*
      for index in 0..<shopsData.count {

        self?.fetchRecommendItemForShop(shop: shopsData[index])
      }
    }

      // 3: Filter shopsAroundUser by keyword
      if let keyword = self.keyword {
        self.filterShopsAroundUser(keyword: keyword)
      }

      // 4: Show filtered result in ascending order of distance between user
      self.sortSearchResult()
      self.setupTableView()
      self.tableView.reloadData()

  }

  // MARK: - Functions
  private func setupTableView() {

    tableView.register(UINib(nibName: LandscapeCardCell.identifier, bundle: nil),
                       forCellReuseIdentifier: LandscapeCardCell.identifier)

    tableView.register(UINib(nibName: ShopFeatureCell.identifier, bundle: nil),
                       forCellReuseIdentifier: ShopFeatureCell.identifier)

    tableView.delegate = self
    tableView.dataSource = self
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
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

    return shopsAroundUserArr.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(
        withIdentifier: "landscapeCardCell", for: indexPath) as? LandscapeCardCell {

      let shop = shopsAroundUserArr[indexPath.row]
      cell.layoutLandscapeCardCell(shop: shop)

      guard let recommendItemsArr = recommendItemsDic[shop.id] else { return UITableViewCell() }
      var itemLayoutArr: [String] = []
      itemLayoutArr.append(contentsOf: recommendItemsArr.map { $0.item })
      cell.configureItem(with: itemLayoutArr)

      cell.selectionStyle = .none

      return cell
    }
    return LandscapeCardCell()
  }
}

extension SearchResultViewController: UITableViewDelegate {

}

// MARK: - DZNEmptyDataSetDelegate
extension SearchResultViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

  func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    let str = "好像搜尋不到耶😣"
    let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
    return NSAttributedString(string: str, attributes: attrs)
  }

  func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return UIImage(named: "logo")
  }
}
