//
//  UIView+Extension.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/26.
//

import UIKit

extension UIView {

  func layoutImageView(for imageView: UIImageView, with containerView: UIView) {

    imageView.clipsToBounds = true

    imageView.layer.cornerRadius = 20

    containerView.layer.shadowOpacity = 0.5

    containerView.layer.shadowRadius = 3.0

    containerView.layer.shadowColor = UIColor.black.cgColor

    containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
  }

  func addShadow() {

    clipsToBounds = true

    layer.cornerRadius = 10

    layer.masksToBounds = false

    layer.shadowOffset = CGSize.init(width: 0, height: 3)

    layer.shadowColor = UIColor.black.cgColor

    layer.shadowRadius = 3.0

    layer.shadowOpacity = 0.5
  }

}

extension UITextView {

  // MARK: 還沒實作

  public var lineCount: Int {

    let numberOfGlyphs = layoutManager.numberOfGlyphs

    var index = 0, numberOfLines = 0

    var lineRange = NSRange(location: NSNotFound, length: 0)

    while index < numberOfGlyphs {

      layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)

      index = NSMaxRange(lineRange)

      numberOfLines += 1
    }

    // Take into account newlines at the bottom.
    if layoutManager.extraLineFragmentUsedRect != CGRect.zero {

      numberOfLines += 1
    }
    return numberOfLines
  }
}
