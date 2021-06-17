//
//  SettingViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/10.
//

import UIKit
import Kingfisher
import YPImagePicker
import FirebaseAuth
import JGProgressHUD

class SettingViewController: UIViewController {

  // MARK: - Properties
  var userViewModel = UserViewModel()

  var addViewModel = AddViewModel()

  var updateUser = User()

  var didChangeName = false

  var didUploadImg = false

  var updateImgURL: String?

  // MARK: - IBOutlets
  @IBOutlet weak var profileImg: UIImageView!

  @IBOutlet weak var userNameLabel: UILabel!

  @IBOutlet weak var userEmailLabel: UILabel!

  @IBOutlet weak var userNameTextField: UITextField!

  @IBOutlet weak var logoutBtn: CustomBtn!

  @IBOutlet weak var uploadImgBtn: UIButton!

  @IBOutlet weak var sendUpdateInfoBtn: CustomBtn!

  // MARK: - IBActions
  @IBAction func finishEditUserName(_ sender: UITextField) {

    if let input = sender.text {

      if !input.isEmpty {

        didChangeName = true

        updateUser.name = input

        userNameLabel.text = input

        sendUpdateInfoBtn.isEnabled = true

        sendUpdateInfoBtn.backgroundColor = .B3
      }
    }
  }

  @IBAction func onTapUploadImgBtn(_ sender: UIButton) {

    setUpImagesPicker()
  }

  @IBAction func onTapSendUpdateInfoBtn(_ sender: Any) {

    updateUser.id = UserManager.shared.user.id

    // MARK: 判斷更新的三種情況（Kinda Redundant）
    if didChangeName == true && didUploadImg == true {

      // 名字＋大頭貼都有改
      guard let uploadImg = profileImg.image else { return }

      let dispatchGroup = DispatchGroup()

      dispatchGroup.enter()

      addViewModel.uploadImageFromUser(with: uploadImg, folderName: "userProfileImg")

      addViewModel.onUploadImage = { result in

        self.updateImgURL = result

        dispatchGroup.leave()
      }

      dispatchGroup.notify(queue: .main) {

        self.updateUser.profileImg = self.updateImgURL ?? "https://firebasestorage.googleapis.com/v0/b/discoffery-30605.appspot.com/o/mockImg%2Fappearance.jpg?alt=media&token=6e486376-3925-4c36-940e-4e799ca84e15"

        self.userViewModel.updateUserNameAndImg(user: self.updateUser)

        self.showSuccessHUD(showInfo: "更新用戶資料成功")
      }
      userNameTextField.text = ""

    } else if didChangeName == true && didUploadImg == false {

      // 只改名字
      userViewModel.updateUserName(user: updateUser)

      showSuccessHUD(showInfo: "更新用戶名稱成功")

      userNameTextField.text = ""

    } else {

      // 只改大頭貼
      guard let uploadImg = profileImg.image else { return }

      let dispatchGroup = DispatchGroup()

      dispatchGroup.enter()

      addViewModel.uploadImageFromUser(with: uploadImg, folderName: "userProfileImg")

      addViewModel.onUploadImage = { result in

        self.updateImgURL = result

        dispatchGroup.leave()
      }

      dispatchGroup.notify(queue: .main) {

        self.updateUser.profileImg = self.updateImgURL ?? "https://firebasestorage.googleapis.com/v0/b/discoffery-30605.appspot.com/o/mockImg%2Fappearance.jpg?alt=media&token=6e486376-3925-4c36-940e-4e799ca84e15"

        self.userViewModel.updateUserImg(user: self.updateUser)

        self.showSuccessHUD(showInfo: "更新用戶大頭貼成功")
      }
    }
  }

  // MARK: - Logout
  @IBAction func onTapLogoutBtn(_ sender: Any) {

    showLogoutSuccessDialog()

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {

      do {

        try Auth.auth().signOut()

      } catch let error {

        print("SignOut Error: ", error.localizedDescription)
      }
    }
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupSettingVC()

    userViewModel.watchUser()

    userViewModel.onWatchUser = { result in

      self.userNameLabel.text = result.name

      self.userEmailLabel.text = result.email

      self.profileImg.loadImage(result.profileImg)
    }
  }

  private func setupSettingVC() {
    
    navigationController?.navigationBar.barTintColor = .G3

    navigationController?.navigationBar.tintColor = .G1

    profileImg.clipsToBounds = true

    profileImg.layer.cornerRadius = 40

    sendUpdateInfoBtn.isEnabled = false
  }

  func setUpImagesPicker() {

    var config = YPImagePickerConfiguration()

    config.library.maxNumberOfItems = 1

    config.startOnScreen = .library

    let picker = YPImagePicker(configuration: config)

    present(picker, animated: true, completion: nil)

    picker.didFinishPicking { [unowned picker] items, cancelled in

      if cancelled {

        picker.dismiss(animated: true, completion: nil)

      } else {

        self.showSuccessHUD(showInfo: "上傳照片成功")

        for item in items {

          switch item {

          case .photo(let photo):

            self.profileImg.image = photo.image

            self.didUploadImg = true

            self.sendUpdateInfoBtn.isEnabled = true

            self.sendUpdateInfoBtn.backgroundColor = .B3

          case .video(let video):

            print("You cannot upload video lmao \(video)")
          }
        }
        picker.dismiss(animated: true, completion: nil)
      }
    }
  }
}
