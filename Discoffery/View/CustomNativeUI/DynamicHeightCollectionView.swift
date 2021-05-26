//
//  DynamicHeightCollectionView.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {

  override func layoutSubviews() {
    super.layoutSubviews()

    if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {

      self.invalidateIntrinsicContentSize()
    }
  }

  override var intrinsicContentSize: CGSize {
    return contentSize
  }
}
