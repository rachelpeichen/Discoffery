//
//  SelectedShopViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import UIKit
import Cosmos

class SelectedShopViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var backgroundView: UIView!

  @IBOutlet weak var imageView: UIImageView!

  @IBOutlet weak var selectedShopName: UILabel!

  @IBOutlet weak var distanceLabel: UILabel!

  @IBOutlet weak var averageRating: CosmosView!

  @IBOutlet weak var featureOneBtn: CustomUIButton!

  @IBOutlet weak var featureTwoBtn: CustomUIButton!

  @IBOutlet weak var featureThreeBtn: CustomUIButton!

  // MARK: - Properties
  var selectedShop: CoffeeShop?

  var selectedShopfeature: Feature?

  var selectedShopRecommendItem: RecommendItem?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  func setUpSelectedShopVC(shop: CoffeeShop, feature: Feature, recommendItem: RecommendItem) {

    selectedShop = shop

    selectedShopfeature = feature

    selectedShopRecommendItem = recommendItem

    layoutSelecetedShopViewController()
  }

  func layoutSelecetedShopViewController() {

    imageView.clipsToBounds = true

    imageView.layer.cornerRadius = 20

    backgroundView.addShadow()

    averageRating.rating = Double.random(in: 1...5)

    distanceLabel.text = "\(selectedShop!.cheap.rounded().formattedValue)公尺"

    selectedShopName.text = selectedShop?.name

    featureOneBtn.setTitle(selectedShopRecommendItem?.item, for: .normal)

    featureTwoBtn.setTitle(selectedShopfeature?.special[0], for: .normal)

    featureThreeBtn.setTitle(selectedShopfeature?.special[1], for: .normal)
  }
}
