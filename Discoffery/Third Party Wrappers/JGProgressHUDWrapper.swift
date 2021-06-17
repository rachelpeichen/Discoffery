//
//  JGProgressHUDWrapper.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/5.
//

import UIKit
import JGProgressHUD

extension UIViewController {

  func showSuccessHUD(showInfo: String = "Success") {

    let hud = JGProgressHUD(style: .light)
    hud.textLabel.text = showInfo
    hud.textLabel.textColor = .G1
    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    hud.shadow = JGProgressHUDShadow(color: .darkGray, offset: .zero, radius: 3.0, opacity: 0.5)
    hud.show(in: self.view)
    hud.dismiss(afterDelay: 2.5)
  }

  func showErrorHUD(showInfo: String = "Error") {

    let hud = JGProgressHUD(style: .light)
    hud.textLabel.text = showInfo
    hud.indicatorView = JGProgressHUDErrorIndicatorView()
    hud.shadow = JGProgressHUDShadow(color: .darkGray, offset: .zero, radius: 3.0, opacity: 0.8)
    hud.show(in: self.view)
    hud.dismiss(afterDelay: 2.5)
  }

  func showLoadingHUD(showInfo: String = "Loading") {

    let hud = JGProgressHUD(style: .light)
    hud.textLabel.text = showInfo
    hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
    hud.shadow = JGProgressHUDShadow(color: .darkGray, offset: .zero, radius: 3.0, opacity: 0.8)
    hud.show(in: self.view)
    hud.dismiss(afterDelay: 2.0)
  }
}
