//
//  ImagePicker.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/3.
//

import UIKit

class ImagePicker: UIViewController {

  var imagePicker = UIImagePickerController()

  func showUploadImageMenu() {

    let controller = UIAlertController(title: "上傳照片", message: "請選擇上傳方式", preferredStyle: .actionSheet)

    let cameraAction = UIAlertAction(title: "使用相機拍照", style: .default) { _ in

      self.openCamera()
    }

    let libraryAction = UIAlertAction(title: "從相簿中選取", style: .default) { _ in

      self.openAlbum()
    }

    let cancleAction = UIAlertAction(title: "取消", style: .cancel)

    controller.addAction(cameraAction)

    controller.addAction(libraryAction)

    controller.addAction(cancleAction)

    present(controller, animated: true)
  }

  private func openCamera() {

    imagePicker.sourceType = .camera

    present(imagePicker, animated: true)
  }

  private func openAlbum() {

    imagePicker.sourceType = .savedPhotosAlbum

    present(imagePicker, animated: true)
  }
}
