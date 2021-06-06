//
//  UIView+Extension.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/26.
//

import UIKit

extension UIView {

  func layoutImageViewWithShadow(for imageView: UIImageView, with containerView: UIView) {

    imageView.clipsToBounds = true

    imageView.layer.cornerRadius = 10

    containerView.layer.shadowOpacity = 0.5

    containerView.layer.shadowRadius = 3.0

    containerView.layer.shadowColor = UIColor.black.cgColor

    containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
  }

  func layoutViewWithShadow() {

    clipsToBounds = true

    layer.cornerRadius = 10

    layer.masksToBounds = false

    layer.shadowOffset = CGSize.init(width: 0, height: 3)

    layer.shadowColor = UIColor.black.cgColor

    layer.shadowRadius = 3.0

    layer.shadowOpacity = 0.5
  }
}

//extension UIView {
//
//  func layoutTextField(textField: UITextField) {
//
//    let border = CALayer()
//
//    let autoresizing = textField
//
//    autoresizing.text = textField.text
//
//    autoresizing.sizeToFit()
//
//    let width = CGFloat(1.5)
//
//    border.borderColor = UIColor.init(named: "G1") as! CGColor
//
//    border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  autoresizing.frame.size.width, height: textField.frame.size.height)
//
//    border.borderWidth = width
//
//    textField.borderStyle = .none
//
//    textField.layer.addSublayer(border)
//
//    textField.layer.masksToBounds = true
//  }
//}
