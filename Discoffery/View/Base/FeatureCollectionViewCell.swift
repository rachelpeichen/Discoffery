//
//  FeatureCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/24.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var featureLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    // featureLabel.sizeToFit()

    featureLabel.layer.cornerRadius = 10
  }

  func layoutFeatureCollectionViewCell(feature: String) {

    featureLabel.text = feature
  }

}
