//
//  DetailViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class DetailViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: Properties
  var coffeeShop: CoffeeShop?

  private let shopsDetail: [CoffeeShopContentCategory] = [.images, .description, .recommend, .feature, .route, .writeReview]

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupTableView()
  }

  // MARK: Functions
  private func setupTableView() {

    tableView.register(UINib(nibName: "ShopImagesCell", bundle: nil), forCellReuseIdentifier: "shopImagesCell")

    tableView.register(UINib(nibName: "ShopDescriptionCell", bundle: nil), forCellReuseIdentifier: "shopDescriptionCell")

    tableView.register(UINib(nibName: "ShopFeatureCell", bundle: nil), forCellReuseIdentifier: "shopFeatureCell")

    tableView.register(UINib(nibName: "ShopRouteCell", bundle: nil), forCellReuseIdentifier: "shopRouteCell")

    tableView.register(UINib(nibName: "WriteReviewCell", bundle: nil), forCellReuseIdentifier: "writeReviewCell")

    tableView.estimatedRowHeight = 280

    tableView.rowHeight = UITableView.automaticDimension

    tableView.reloadData()
  }
}

extension DetailViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shopsDetail.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    //    guard let coffeeShop = coffeeShop else { return UITableViewCell() }

    switch indexPath.row {

    case 0:

      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopImagesCell", for: indexPath) as? ShopImagesCell {

        cell.selectionStyle = .none

        return cell
      }

    case 1:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopDescriptionCell", for: indexPath) as? ShopDescriptionCell {

        cell.name.text = "Cafe MDFKKKKKKK"

        cell.selectionStyle = .none

        return cell
      }

    case 2:
      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopFeatureCell", for: indexPath) as? ShopFeatureCell {

        cell.selectionStyle = .none

        return cell
      }

    case 3:

      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopFeatureCell", for: indexPath) as? ShopFeatureCell {

        cell.categoryLabel.text = "特色服務"

        cell.selectionStyle = .none
        
        return cell
      }

    case 4:

      if let cell = tableView.dequeueReusableCell(withIdentifier: "shopRouteCell", for: indexPath) as? ShopRouteCell {

        cell.selectionStyle = .none

        return cell
      }

    case 5:

      if let cell = tableView.dequeueReusableCell(withIdentifier: "writeReviewCell", for: indexPath) as? WriteReviewCell {

        cell.selectionStyle = .none

        return cell
      }

    default:
      return UITableViewCell()
    }
    return UITableViewCell()
  }
}