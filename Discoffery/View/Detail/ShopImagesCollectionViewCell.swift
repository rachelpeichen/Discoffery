//
//  ShopImagesCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ShopImagesCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var mainImgContainerView: UIView!

  @IBOutlet weak var mainImg: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    // corner radius
    mainImg.layoutImageViewWithShadow(for: mainImg, with: mainImgContainerView)
  }
}
