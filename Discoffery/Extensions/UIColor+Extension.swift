//
//  UIColor+Extension.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/28.
//

import UIKit

private enum BaseColor: String {
  // swiftlint:disable identifier_name
  case B1
  case B2
  case B3
  case B4
  case B5
  case G1
  case G2
  case G3
  case G4
}

extension UIColor {
  
  // swiftlint:disable identifier_name
  static let B1 = baseColor(.B1)
  static let B2 = baseColor(.B2)
  static let B3 = baseColor(.B3)
  static let B4 = baseColor(.B4)
  static let B5 = baseColor(.B5)
  static let G1 = baseColor(.G1)
  static let G2 = baseColor(.G2)
  static let G3 = baseColor(.G3)
  static let G4 = baseColor(.G4)

  private static func baseColor(_ color: BaseColor) -> UIColor? {
    return UIColor(named: color.rawValue)
  }
}
