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

  func layoutRecommendItemCollectionViewCell(from: String) {

    itemBtn.setTitle(from, for: .normal)
  }

}
