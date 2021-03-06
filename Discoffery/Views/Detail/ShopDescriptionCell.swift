//
//  ShopDescriptionCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Cosmos

class ShopDescriptionCell: ShopDetailBasicCell {

  @IBOutlet weak var checkAllReviewsBtn: UIButton!
  @IBOutlet weak var rateStars: CosmosView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var averageRatings: UILabel!
  @IBOutlet weak var reviewsCount: UILabel!
  @IBOutlet weak var openingStatus: UILabel!
  @IBOutlet weak var openingHours: UILabel!
  @IBOutlet weak var address: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

  func layoutShopDescriptionCell(shop: CoffeeShop) {
    name.text = shop.name
    address.text = shop.address
    rateStars.rating = shop.tasty
    openingHours.text = "因爲疫情暫停營業"
    averageRatings.text = String(Double(shop.tasty).rounded())
  }
}
