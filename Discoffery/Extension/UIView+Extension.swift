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

    layer.cornerRadius = frame.height / 1.5

      layer.masksToBounds = false

      layer.shadowOffset = CGSize.init(width: 0, height: 3)

      layer.shadowColor = UIColor.black.cgColor

      layer.shadowRadius = 3.0

      layer.shadowOpacity = 0.25
  }
}
