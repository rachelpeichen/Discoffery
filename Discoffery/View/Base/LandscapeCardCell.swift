//
//  LandscapeCardCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import UIKit
import Cosmos

class LandscapeCardCell: UITableViewCell {

  @IBOutlet weak var cafeMainImage: UIImageView!

  @IBOutlet weak var cafeName: UILabel!

  @IBOutlet weak var starsView: CosmosView!

  @IBOutlet weak var averageRatings: UILabel!

  @IBOutlet weak var distance: UILabel!

  @IBOutlet weak var openHours: UILabel!

  @IBOutlet weak var featureOne: UILabel!

  @IBOutlet weak var featureTwo: UILabel!

  @IBOutlet weak var itemOne: UILabel!

  @IBOutlet weak var itemTwo: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
