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

    featureBtn.layoutViewWithShadow()
  }

  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

      setNeedsLayout()

      layoutIfNeeded()

      let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)

      var frame = layoutAttributes.frame

      frame.size.height = ceil(size.height)

      layoutAttributes.frame = frame

      return layoutAttributes
  }

  func layoutFeatureCollectionViewCell(from: String) {

    featureBtn.setTitle(from, for: .normal)
  }
}
