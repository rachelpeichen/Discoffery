//
//  RecommendItemCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/30.
//

import UIKit

class RecommendItemCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var itemBtn: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    itemBtn.layoutViewWithShadow()
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

  func layoutRecommendItemCollectionViewCell(from: String) {
    itemBtn.setTitle(from, for: .normal)
  }
}
