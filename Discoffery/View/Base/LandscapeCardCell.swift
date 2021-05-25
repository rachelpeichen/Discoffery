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

  @IBOutlet weak var distance: UILabel!

  @IBOutlet weak var openHours: UILabel!

  @IBOutlet weak var featureOne: UILabel!

  @IBOutlet weak var featureTwo: UILabel!

  @IBOutlet weak var itemOne: UILabel!

  @IBOutlet weak var itemTwo: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    layoutMainImage()

    layoutFeatureLabel()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func layoutMainImage() {

    // corner radius
    cafeMainImage.layer.cornerRadius = 20

    // shadow
    cafeMainImage.layer.shadowColor = UIColor.darkGray.cgColor

    cafeMainImage.layer.shadowOffset = .zero

    cafeMainImage.layer.shadowOpacity = 0.3

    cafeMainImage.layer.shadowRadius = 4.0

    cafeMainImage.layer.shadowPath = UIBezierPath(rect: cafeMainImage.bounds).cgPath
  }

  func layoutFeatureLabel() {

    featureOne.layer.cornerRadius = 5

    featureOne.layer.masksToBounds = true

    featureOne.layer.shadowColor = UIColor.darkGray.cgColor

    featureOne.layer.shadowOffset = CGSize(width: 5, height: 5)

    featureOne.layer.shadowOpacity = 0.3

    featureOne.layer.shadowRadius = 4.0

    featureTwo.layer.cornerRadius = 10

    itemOne.layer.cornerRadius = 10

    itemTwo.layer.cornerRadius = 10
  }
}
