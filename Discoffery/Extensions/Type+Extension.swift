//
//  Type+Extension.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import Foundation

import UIKit

extension Double {

  var formattedValue: String {
    return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
  }
}

extension UITableViewCell {

  static var identifier: String {
    return String(describing: self)
  }
}

extension UICollectionViewCell {

  static var identifier: String {
    return String(describing: self)
  }
}
