//
//  CustomButton.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/2.
//

import UIKit

@IBDesignable
class CustomBtn: UIButton {

  @IBInspectable var cornerRadius: CGFloat = 0.0 {

    didSet {

      layer.cornerRadius = cornerRadius

      layer.masksToBounds = cornerRadius > 0
    }
  }

  @IBInspectable var shadowRadius: CGFloat = 0.0 {

    didSet {

      layer.shadowRadius = shadowRadius
    }
  }

  @IBInspectable var borderWidth: CGFloat = 0.0 {

    didSet {

      layer.borderWidth = borderWidth
    }
  }

  @IBInspectable var borderColor: UIColor = .black {

    didSet {

      layer.borderColor = borderColor.cgColor
    }
  }

  @IBInspectable var titleLeftPadding: CGFloat = 0.0 {

    didSet {

      titleEdgeInsets.left = titleLeftPadding
    }
  }

  @IBInspectable var titleRightPadding: CGFloat = 0.0 {

    didSet {

      titleEdgeInsets.right = titleRightPadding
    }
  }

  @IBInspectable var titleTopPadding: CGFloat = 0.0 {
    didSet {
      titleEdgeInsets.top = titleTopPadding
    }
  }

  @IBInspectable var titleBottomPadding: CGFloat = 0.0 {

    didSet {
      titleEdgeInsets.bottom = titleBottomPadding
    }
  }

  @IBInspectable var imageLeftPadding: CGFloat = 0.0 {

    didSet {

      imageEdgeInsets.left = imageLeftPadding
    }
  }

  @IBInspectable var imageRightPadding: CGFloat = 0.0 {

    didSet {

      imageEdgeInsets.right = imageRightPadding
    }
  }

  @IBInspectable var imageTopPadding: CGFloat = 0.0 {

    didSet {

      imageEdgeInsets.top = imageTopPadding
    }
  }

  @IBInspectable var imageBottomPadding: CGFloat = 0.0 {

    didSet {

      imageEdgeInsets.bottom = imageBottomPadding
    }
  }

  @IBInspectable var enableImageRightAligned: Bool = false

  override func layoutSubviews() {
    super.layoutSubviews()

    if enableImageRightAligned,

       let imageView = imageView {

      imageEdgeInsets.left = self.bounds.width - imageView.bounds.width - imageRightPadding
    }
  }

  // MARK: 先寫死btn shadow有需要再來改成IBInspectable
  override func awakeFromNib() {
    super.awakeFromNib()

    self.layer.masksToBounds = false

    self.layer.shadowColor = UIColor.black.cgColor

    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath

    self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)

    self.layer.shadowOpacity = 0.5

    self.layer.shadowRadius = 3.0
  }
}
