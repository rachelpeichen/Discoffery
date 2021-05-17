//
//  FeatureCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var featureHashtag: UIButton!

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  func layoutFeatureCollectionViewCell(hashTag: String) {

    featureHashtag.titleLabel?.text = hashTag
  }
}
