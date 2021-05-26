//
//  UITextField+Extension.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/26.
//

import UIKit

class CustomTextField: UITextField {

  let paddingForText = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: paddingForText)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: paddingForText)
  }
}

extension UITextView {

  var numberOfLines: Int {

    // Get number of lines
    let numberOfGlyphs = self.layoutManager.numberOfGlyphs

    var index = 0, numberOfLines = 0

    var lineRange = NSRange(location: NSNotFound, length: 0)

    while index < numberOfGlyphs {

      self.layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
      index = NSMaxRange(lineRange)

      numberOfLines += 1
    }
    return numberOfLines
  }
}
