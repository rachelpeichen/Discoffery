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

    let hud = JGProgressHUD(style: .dark  )

    hud.textLabel.text = showInfo

    hud.indicatorView = JGProgressHUDSuccessIndicatorView()

    hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.5)
    
    hud.show(in: self.view)

    hud.dismiss(afterDelay: 2)
  }

  func showErrorHUD(showInfo: String = "Error") {

    let hud = JGProgressHUD(style: .light)

    hud.textLabel.text = showInfo

    hud.indicatorView = JGProgressHUDErrorIndicatorView()

    hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 1)

    hud.show(in: self.view)

    hud.dismiss(afterDelay: 2)
  }
}
