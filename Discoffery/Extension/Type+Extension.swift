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
//
//extension String {
//
//  public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
//
//    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//
//    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
//
//    return ceil(boundingBox.height)
//  }
//
//  public func width(withConstrainedHeight height: CGFloat, font: UIFont, minimumTextWrapWidth:CGFloat) -> CGFloat {
//
//    var textWidth:CGFloat = minimumTextWrapWidth
//
//    let incrementWidth:CGFloat = minimumTextWrapWidth * 0.1
//
//    var textHeight:CGFloat = self.height(withConstrainedWidth: textWidth, font: font)
//
//    //Increase width by 10% of minimumTextWrapWidth until minimum width found that makes the text fit within the specified height
//    while textHeight > height {
//
//      textWidth += incrementWidth
//
//      textHeight = self.height(withConstrainedWidth: textWidth, font: font)
//    }
//    return ceil(textWidth)
//  }
//}
