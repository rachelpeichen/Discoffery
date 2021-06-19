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

  // MARK: - Properties
  weak var delegate: SelectedShopViewControllerDelegate?

  var selectedShop: CoffeeShop?

  var selectedShopfeature: Feature?

  var selectedShopRecommendItem: [RecommendItem]?

  // MARK: - IBOutlets & IBActions
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var rateStarsView: CosmosView!

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var featureOneLabel: UILabel!
  @IBOutlet weak var featureTwoLabel: UILabel!
  @IBOutlet weak var featureThreeLabel: UILabel!

  @IBAction func didTouchSelectedVC(_ sender: Any) {

    delegate?.didTouchSelectedVC(sender)
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  // MARK: - Functions
  func layoutSelectedShopVC(shop: CoffeeShop, feature: Feature, recommendItem: [RecommendItem]) {

    selectedShop = shop
    selectedShopfeature = feature
    selectedShopRecommendItem = recommendItem

    imgView.clipsToBounds = true
    imgView.layer.cornerRadius = 10
    backgroundView.layoutViewWithShadow()

    if let selectedShop = selectedShop {

      rateStarsView.rating = selectedShop.tasty
      distanceLabel.text = "\(selectedShop.cheap.rounded().formattedValue)公尺"
      nameLabel.text = selectedShop.name
    }

    if let selectedShopRecommendItem = selectedShopRecommendItem {

      let assignedItem = selectedShopRecommendItem[0]
      featureOneLabel.text = assignedItem.item
    }

    if let selectedShopfeature = selectedShopfeature {

      featureTwoLabel.text = selectedShopfeature.special[0]
      featureThreeLabel.text = selectedShopfeature.special[1]
    }
  }
}
