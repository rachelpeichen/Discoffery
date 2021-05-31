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

  @IBOutlet weak var selectedShopName: UILabel!

  // MARK: - Properties

  var selectedShop: CoffeeShop?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  func setUpSelectedShopVC(shop: CoffeeShop) {

    selectedShop = shop

    layoutSelecetedShopViewController()
  }

  func layoutSelecetedShopViewController() {

    selectedShopName.text = selectedShop?.name

    backgroundView.addShadow()
  }
}
