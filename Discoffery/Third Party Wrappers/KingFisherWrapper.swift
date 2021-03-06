//
//  KingFisherWrapper.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/2.
//

import UIKit
import Kingfisher

extension UIImageView {

  func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

    if let urlString = urlString {

      let url = URL(string: urlString)
      self.kf.setImage(with: url, placeholder: placeHolder)
    }
  }
}
