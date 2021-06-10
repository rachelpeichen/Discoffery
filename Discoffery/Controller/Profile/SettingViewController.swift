//
//  SettingViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/10.
//

import UIKit
import FirebaseAuth
import PopupDialog
import JGProgressHUD

class SettingViewController: UIViewController {

  @IBOutlet weak var profileImg: UIImageView!

  @IBOutlet weak var userNameLabel: UILabel!

  @IBOutlet weak var finishEditBtn: CustomBtn!

  // MARK: Hide
  @IBAction func onTapFinishEditBtn(_ sender: Any) {

  }

  @IBAction func onTapLogoutBtn(_ sender: Any) {

    showLogoutSuccessDialog()

    logOut()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupSettingVC()
  }

  func setupSettingVC() {
    navigationController?.navigationBar.barTintColor = .G3

    navigationController?.navigationBar.tintColor = .G1

    profileImg.clipsToBounds = true

    profileImg.layer.cornerRadius = 40

    userNameLabel.text = UserManager.shared.user.name
  }

  func logOut() {

    let firebaseAuth = Auth.auth()

    do {

      try firebaseAuth.signOut()

      print(firebaseAuth.currentUser) // 有成功登出但是無法跳轉畫面回登入畫面

      let storyboard = UIStoryboard.login

      if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

          appDelegate.window?.rootViewController = loginVC
        }  
      }

    } catch let signOutError as NSError {

      showErrorHUD(showInfo: "登出失敗")

      print("Sign Out Error: %@", signOutError)
    }
  }
}
