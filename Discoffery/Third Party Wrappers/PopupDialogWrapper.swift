//
//  PopupDialogWrapper.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/2.
//

import UIKit
import PopupDialog

extension UIViewController {

  func showLocationAuthDeniedDialog() {

    let title = "定位權限已關閉"
    let message = "如果您要取得咖啡廳資訊，請至設定 > 隱私權 > 定位服務內開啟定位功能。"
    let image = UIImage(named: "logo")
    let popup = PopupDialog(title: title,
                            message: message,
                            image: image,
                            buttonAlignment: .horizontal,
                            transitionStyle: .fadeIn,
                            preferredWidth: 340,
                            tapGestureDismissal: true,
                            panGestureDismissal: true) {
      print("popup setup completed")
    }

    let buttonOne = DefaultButton(title: "我知道了", height: 60) {
      self.dismiss(animated: true, completion: nil)
    }

    popup.addButtons([buttonOne])

    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color           = .lightGray
    overlayAppearance.blurRadius      = 20
    overlayAppearance.blurEnabled     = true
    overlayAppearance.liveBlurEnabled = false
    overlayAppearance.opacity         = 0.2

    let buttonAppearance = DefaultButton.appearance()
    buttonAppearance.titleFont      = .systemFont(ofSize: 16)
    buttonAppearance.titleColor     = .G1
    buttonAppearance.buttonColor    = .B5

    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.backgroundColor      = .white
    dialogAppearance.titleFont            = .boldSystemFont(ofSize: 20)
    dialogAppearance.titleColor           = .G1
    dialogAppearance.titleTextAlignment   = .center
    dialogAppearance.messageFont          = .systemFont(ofSize: 16)
    dialogAppearance.messageColor         = .G1
    dialogAppearance.messageTextAlignment = .center

    let containerAppearance = PopupDialogContainerView.appearance()
    containerAppearance.backgroundColor = UIColor(red: 0.23, green: 0.23, blue: 0.27, alpha: 1.00)
    containerAppearance.cornerRadius    = 10
    containerAppearance.shadowEnabled   = true
    containerAppearance.shadowColor     = .black
    containerAppearance.shadowOpacity   = 0.5
    containerAppearance.shadowRadius    = 10
    containerAppearance.shadowOffset    = CGSize(width: 0, height: 3)

    self.present(popup, animated: true, completion: nil)
  }

  func showAddShopSuccessDialog() {

    let title = "新增咖啡廳成功"
    let message = "您提供的資訊正在審核中，審核通過後就會更新到Discoffery了喔。"
    let image = UIImage(named: "logo")
    let popup = PopupDialog(title: title,
                            message: message,
                            image: image,
                            buttonAlignment: .horizontal,
                            transitionStyle: .fadeIn,
                            preferredWidth: 340,
                            tapGestureDismissal: true,
                            panGestureDismissal: true) {
      print("popup setup completed")
    }

    let buttonOne = DefaultButton(title: "回到主頁面", height: 60) {
      self.dismiss(animated: true, completion: nil)
    }

    popup.addButtons([buttonOne])

    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color           = .lightGray
    overlayAppearance.blurRadius      = 20
    overlayAppearance.blurEnabled     = true
    overlayAppearance.liveBlurEnabled = false
    overlayAppearance.opacity         = 0.2

    let buttonAppearance = DefaultButton.appearance()
    buttonAppearance.titleFont      = .systemFont(ofSize: 16)
    buttonAppearance.titleColor     = .G1
    buttonAppearance.buttonColor    = .B5

    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.backgroundColor      = .white
    dialogAppearance.titleFont            = .boldSystemFont(ofSize: 20)
    dialogAppearance.titleColor           = .G1
    dialogAppearance.titleTextAlignment   = .center
    dialogAppearance.messageFont          = .systemFont(ofSize: 16)
    dialogAppearance.messageColor         = .G1
    dialogAppearance.messageTextAlignment = .center

    let containerAppearance = PopupDialogContainerView.appearance()
    containerAppearance.backgroundColor = UIColor(red: 0.23, green: 0.23, blue: 0.27, alpha: 1.00)
    containerAppearance.cornerRadius    = 10
    containerAppearance.shadowEnabled   = true
    containerAppearance.shadowColor     = .black
    containerAppearance.shadowOpacity   = 0.5
    containerAppearance.shadowRadius    = 10
    containerAppearance.shadowOffset    = CGSize(width: 0, height: 3)

    self.present(popup, animated: true, completion: nil)
  }

  func showLogoutSuccessDialog() {

    let title = "登出Discoffery成功"
    let message = "謝謝您的使用，歡迎隨時回來Discoffery探索咖啡廳。畫面將會自動跳轉回登入頁面。"
    let image = UIImage(named: "logo")
    let popup = PopupDialog(title: title,
                            message: message,
                            image: image,
                            buttonAlignment: .horizontal,
                            transitionStyle: .fadeIn,
                            preferredWidth: 340,
                            tapGestureDismissal: true,
                            panGestureDismissal: true) {
      print("popup setup completed")
    }

    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color           = .lightGray
    overlayAppearance.blurRadius      = 20
    overlayAppearance.blurEnabled     = true
    overlayAppearance.liveBlurEnabled = false
    overlayAppearance.opacity         = 0.2

    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.backgroundColor      = .white
    dialogAppearance.titleFont            = .boldSystemFont(ofSize: 20)
    dialogAppearance.titleColor           = .G1
    dialogAppearance.titleTextAlignment   = .center
    dialogAppearance.messageFont          = .systemFont(ofSize: 16)
    dialogAppearance.messageColor         = .G1
    dialogAppearance.messageTextAlignment = .center

    let containerAppearance = PopupDialogContainerView.appearance()
    containerAppearance.backgroundColor = UIColor(red: 0.23, green: 0.23, blue: 0.27, alpha: 1.00)
    containerAppearance.cornerRadius    = 10
    containerAppearance.shadowEnabled   = true
    containerAppearance.shadowColor     = .black
    containerAppearance.shadowOpacity   = 0.5
    containerAppearance.shadowRadius    = 10
    containerAppearance.shadowOffset    = CGSize(width: 0, height: 3)

    self.present(popup, animated: true, completion: nil)
  }
}
