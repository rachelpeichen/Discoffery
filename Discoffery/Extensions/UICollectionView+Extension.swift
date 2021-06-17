//
//  UICollectionView+Extension.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/7.
//

import Foundation

import UIKit

extension UICollectionView {

  func reloadWithoutAnimation() {

    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    self.reloadData()
    CATransaction.commit()
  }
}
