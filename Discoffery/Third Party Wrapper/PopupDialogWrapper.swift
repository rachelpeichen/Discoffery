//
//  PopupDialogWrapper.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/2.
//

import UIKit
import PopupDialog

extension UIViewController {

  func showSuccessDialog(animated: Bool = true, title: String, message: String) {

      // Prepare the popup assets
      let title = title

      let message = message

      let image = UIImage(named: "mock_rect2")

      // Create the dialog
      let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)

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

      // Present dialog
      self.present(popup, animated: animated, completion: nil)
  }
}
