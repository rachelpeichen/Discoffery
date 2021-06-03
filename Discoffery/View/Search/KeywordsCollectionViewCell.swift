//
//  KeywordsCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import UIKit

class KeywordsCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var keywordBtn: UIButton!

  @IBAction func didTouchKeywordBtn(_ sender: UIButton) {
    // 把文字帶入搜尋欄
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    // Initialization code
    keywordBtn.layoutViewWithShadow()
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

  func layoutKeywordCollectionViewCell(from: String) {

    keywordBtn.setTitle(from, for: .normal)
  }
}
