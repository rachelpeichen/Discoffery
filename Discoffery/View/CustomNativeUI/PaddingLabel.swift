//
//  PaddingLabel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/1.
//

import UIKit

// MARK: No shadow effect is preferable.
@IBDesignable class PaddingLabel: UILabel {

  @IBInspectable var topInset: CGFloat = 5.0

  @IBInspectable var bottomInset: CGFloat = 5.0

  @IBInspectable var leftInset: CGFloat = 7.0

  @IBInspectable var rightInset: CGFloat = 7.0

  @IBInspectable var cornerRadius: CGFloat = 10

  override func drawText(in rect: CGRect) {

    let insets = UIEdgeInsets(
      top: topInset,
      left: leftInset,
      bottom: bottomInset,
      right: rightInset)

    super.drawText(in: rect.inset(by: insets))
  }

  override var intrinsicContentSize: CGSize {

    let size = super.intrinsicContentSize

    return CGSize(
      width: size.width + leftInset + rightInset,
      height: size.height + topInset + bottomInset)
  }

  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines num:Int) -> CGRect {

    let bounds = bounds

    let UIEI = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)

    let boundsInset = bounds.inset(by: UIEI)

    let textRect = super.textRect(forBounds: boundsInset, limitedToNumberOfLines: 0)
    // that line of code MUST be LAST in this function, NOT first
    return textRect
  }

  override func draw(_ rect: CGRect) {

    clipsToBounds = true

    layer.cornerRadius = cornerRadius

    super.draw(rect)
  }
}
