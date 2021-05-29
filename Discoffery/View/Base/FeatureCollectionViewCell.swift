//
//  FeatureCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/24.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var featureBtn: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    featureBtn.addShadow()
  }

  func layoutFeatureCollectionViewCell(from: String) {

    featureBtn.setTitle(from, for: .normal)
  }

}
