//
//  KeywordsCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var keywordBtn: UIButton!
  
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
