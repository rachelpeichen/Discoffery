//
//  CategoryCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/5.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var mainImgView: UIImageView!

  @IBOutlet weak var mainImgContainerView: UIView!

  @IBOutlet weak var categoryLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    mainImgView.layoutImageViewWithShadow(for: mainImgView, with: mainImgContainerView)
  }

  func layoutCategoryCollectionViewCell(from: String) {

    categoryLabel.text = from
  }
}
