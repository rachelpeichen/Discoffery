//
//  PopupDialogWrapper.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/2.
//

import UIKit
import PopupDialog

extension UIViewController {

  func showAddShopSuccessDialog() {

    let title = "新增咖啡廳成功"
    let message = "您送出的新店家資訊正在審核中，審核通過後就會更新到Discoffery了喔。"
    let image = UIImage(named: "logo")

    let popup = PopupDialog(title: title,
                            message: message,
                            image: image,
                            buttonAlignment: .horizontal,
                            transitionStyle: .fadeIn,
                            preferredWidth: 340,
                            tapGestureDismissal: true,
                            panGestureDismissal: true
                            ) {
      print("Completed")
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
    overlayAppearance.opacity         = 0.3

    let buttonAppearance = DefaultButton.appearance()

    buttonAppearance.titleFont      = .systemFont(ofSize: 16)
    buttonAppearance.titleColor     = .G1
    buttonAppearance.buttonColor    = .B5

    // Layout dialog
    let dialogAppearance = PopupDialogDefaultView.appearance()

    dialogAppearance.backgroundColor      = .white
    dialogAppearance.titleFont            = .boldSystemFont(ofSize: 20)
    dialogAppearance.titleColor           = .G1
    dialogAppearance.titleTextAlignment   = .center
    dialogAppearance.messageFont          = .systemFont(ofSize: 16)
    dialogAppearance.messageColor         = .G1
    dialogAppearance.messageTextAlignment = .center

    let containerAppearance = PopupDialogContainerView.appearance()

    containerAppearance.backgroundColor = UIColor(red: 0.23, green:0.23, blue:0.27, alpha:1.00)
    containerAppearance.cornerRadius    = 10
    containerAppearance.shadowEnabled   = true
    containerAppearance.shadowColor     = .black
    containerAppearance.shadowOpacity   = 0.5
    containerAppearance.shadowRadius    = 10
    containerAppearance.shadowOffset    = CGSize(width: 0, height: 3)

    self.present(popup, animated: true, completion: nil)
  }

  func showAddReviewSuccessDialog(animated: Bool = true, title: String, message: String) {

    // Prepare the popup assets
    let title = title

    let message = message

    let image = UIImage(named: "mock_rect2")

    // Create the dialog
    let popup = PopupDialog(
      title: title,
      message: message,
      image: image,
      transitionStyle: .fadeIn,
      preferredWidth: 580)

    // Create first button
    let buttonOne = CancelButton(title: "回到上一頁") { [weak self] in

      popup.dismiss(animated: true, completion: nil)
    }

    // Create second button
    let buttonTwo = DefaultButton(title: "回到主頁") { [weak self] in

      self?.dismiss(animated: true, completion: nil)
    }

    // Add buttons to dialog
    popup.addButtons([buttonOne, buttonTwo])

    // Layout dialog
    let dialogAppearance = PopupDialogDefaultView.appearance()

    dialogAppearance.backgroundColor      = .white
    dialogAppearance.titleFont            = .boldSystemFont(ofSize: 22)
    dialogAppearance.titleColor           = .G1
    dialogAppearance.titleTextAlignment   = .center
    dialogAppearance.messageFont          = .systemFont(ofSize: 20)
    dialogAppearance.messageColor         = .G1
    dialogAppearance.messageTextAlignment = .center

    let containerAppearance = PopupDialogContainerView.appearance()

    containerAppearance.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
    containerAppearance.cornerRadius    = 20
    containerAppearance.shadowEnabled   = true
    containerAppearance.shadowColor     = .darkGray
    containerAppearance.shadowOpacity   = 0.5
    containerAppearance.shadowRadius    = 20
    containerAppearance.shadowOffset    = CGSize(width: 0, height: 8)


    let overlayAppearance = PopupDialogOverlayView.appearance()

    overlayAppearance.color           = .lightGray
    overlayAppearance.blurRadius      = 20
    overlayAppearance.blurEnabled     = true
    overlayAppearance.liveBlurEnabled = false
    overlayAppearance.opacity         = 0.5

    let buttonAppearance = DefaultButton.appearance()

    // Default button
    buttonAppearance.titleFont      = .systemFont(ofSize: 20)
    buttonAppearance.titleColor     = .G1
    buttonAppearance.buttonColor    = .B5
    buttonAppearance.separatorColor = .B4

    // Present dialog
    self.present(popup, animated: animated, completion: nil)
  }
}
