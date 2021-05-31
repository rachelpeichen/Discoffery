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

  @IBOutlet weak var featureOneBtn: CustomUIButton!

  @IBOutlet weak var featureTwoBtn: CustomUIButton!

  @IBOutlet weak var featureThreeBtn: CustomUIButton!

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

    imageView.layer.cornerRadius = 20

    backgroundView.addShadow()

    if let selectedShop = selectedShop {

      averageRating.rating = selectedShop.tasty  // 還沒算出全部評價的平均先用api的

      distanceLabel.text = "\(selectedShop.cheap.rounded().formattedValue)公尺"

      selectedShopName.text = selectedShop.name
    }

    let assignedItem = selectedShopRecommendItem?[0]

    featureOneBtn.setTitle(assignedItem?.item, for: .normal)

    featureTwoBtn.setTitle(selectedShopfeature?.special[0], for: .normal)

    featureThreeBtn.setTitle(selectedShopfeature?.special[1], for: .normal)
  }
}
