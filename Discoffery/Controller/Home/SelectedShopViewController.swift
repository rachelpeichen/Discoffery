//
//  SelectedShopViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import UIKit
import Cosmos

protocol SelectedShopViewControllerDelegate: AnyObject {

  func didTouchSelectedVC(_ sender: Any)
}

class SelectedShopViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var backgroundView: UIView!

  @IBOutlet weak var imageView: UIImageView!

  @IBOutlet weak var selectedShopName: UILabel!

  @IBOutlet weak var distanceLabel: UILabel!

  @IBOutlet weak var averageRating: CosmosView!

  @IBOutlet weak var featureOne: UILabel!

  @IBOutlet weak var featureTwo: UILabel!

  @IBOutlet weak var featureThree: UILabel!

  @IBAction func didTouchSelectedVC(_ sender: Any) {

    delegate?.didTouchSelectedVC(sender)
  }

  // MARK: - Properties
  weak var delegate: SelectedShopViewControllerDelegate?

  var selectedShop: CoffeeShop?

  var selectedShopfeature: Feature?

  var selectedShopRecommendItem: [RecommendItem]?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  // MARK: - Functions
  func setUpSelectedShopVC(shop: CoffeeShop, feature: Feature, recommendItem: [RecommendItem]) {

    selectedShop = shop

    selectedShopfeature = feature

    selectedShopRecommendItem = recommendItem

    layoutSelecetedShopViewController()
  }

  func layoutSelecetedShopViewController() {

    imageView.clipsToBounds = true

    imageView.layer.cornerRadius = 10

    backgroundView.addShadow()

    if let selectedShop = selectedShop {

      averageRating.rating = selectedShop.tasty  // TODO: 還沒算出全部評價的平均先用api的

      distanceLabel.text = "\(selectedShop.cheap.rounded().formattedValue)公尺"

      selectedShopName.text = selectedShop.name
    }

    if let selectedShopRecommendItem = selectedShopRecommendItem {

      let assignedItem = selectedShopRecommendItem[0]

      featureOne.text = assignedItem.item
    }

    if let selectedShopfeature = selectedShopfeature {

      featureTwo.text = selectedShopfeature.special[0]

      featureThree.text = selectedShopfeature.special[1]
    }
  }
}
