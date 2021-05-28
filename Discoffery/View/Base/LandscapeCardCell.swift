//
//  LandscapeCardCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import UIKit
import Cosmos

class LandscapeCardCell: UITableViewCell {

  @IBOutlet weak var imageContainerView: UIView!

  @IBOutlet weak var cafeMainImage: UIImageView!

  @IBOutlet weak var cafeName: UILabel!

  @IBOutlet weak var starsView: CosmosView!

  @IBOutlet weak var distance: UILabel!

  @IBOutlet weak var openHours: UILabel!

  @IBOutlet weak var feature1: CustomUIButton!

  @IBOutlet weak var feature2: CustomUIButton!

  @IBOutlet weak var feature3: CustomUIButton!

  @IBOutlet weak var item1: CustomUIButton!

  @IBOutlet weak var item2: CustomUIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    layoutLandscapeCardCell()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func layoutLandscapeCardCell() {

    layoutImageView(for: cafeMainImage, with: imageContainerView)
  }
}
