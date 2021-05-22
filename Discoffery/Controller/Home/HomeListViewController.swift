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

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupTableView()

    homeViewModel?.getShopsData = { [weak self] shopsData in

      self?.shopsDataForList = shopsData
      self?.tableView.reloadData()
    }
  }

  // MARK: - Functions
  func setupTableView() {

    tableView.delegate = self
    tableView.dataSource = self

    tableView.register(UINib(nibName: "LandscapeCardCell", bundle: nil), forCellReuseIdentifier: "landscapeCardCell")

    tableView.estimatedRowHeight = 280
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none

    tableView.reloadData()
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

      cell.cafeMainImage.image = UIImage(named: "mock_2")
      cell.cafeName.text = shop.name
      cell.starsView.rating = 4.3
      cell.averageRatings.text = "4.3"
      cell.distance.text = "距離 500 m"
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

    guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "navigateToDetailVC") as? DetailViewController else { return }

    self.show(detailVC, sender: self)
  }
}

extension HomeListViewController: UITableViewDelegate {
  // Do sth
}
