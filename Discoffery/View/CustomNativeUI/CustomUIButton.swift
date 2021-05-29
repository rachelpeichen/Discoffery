//
//  CustomUIButton.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/27.
//

import UIKit

class CustomUIButton: UIButton {

  override func awakeFromNib() {
    super.awakeFromNib()

    self.layer.masksToBounds = false

    self.layer.cornerRadius = self.frame.height / 3.0

    self.layer.shadowColor = UIColor.lightGray.cgColor

    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
     cornerRadius: self.layer.cornerRadius).cgPath

    self.layer.shadowOffset = CGSize(width: 0, height: 3)

    self.layer.shadowOpacity = 0.5

    self.layer.shadowRadius = 3.0
  }

}
