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

  @IBOutlet weak var featureOne: UILabel!

  @IBOutlet weak var featureTwo: UILabel!

  @IBOutlet weak var itemOne: UILabel!

  @IBOutlet weak var itemTwo: UILabel!

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

    layoutFeatureLabel()
  }

  func layoutFeatureLabel() {

    featureOne.clipsToBounds = true

    featureOne.layer.cornerRadius = 5


    featureTwo.clipsToBounds = true

    featureTwo.layer.cornerRadius = 6


    itemOne.clipsToBounds = true

    itemOne.layer.cornerRadius = 15


    itemTwo.clipsToBounds = true

    itemTwo.layer.cornerRadius = 20
  }
}
