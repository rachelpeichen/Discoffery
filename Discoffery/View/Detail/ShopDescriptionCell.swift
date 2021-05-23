//
//  ShopDescriptionCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Cosmos

class ShopDescriptionCell: ShopDetailBasicCell {

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var rateStars: CosmosView!
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
}
