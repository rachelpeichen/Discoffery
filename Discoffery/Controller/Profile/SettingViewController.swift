//
//  SettingViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/10.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {

  @IBOutlet weak var finishEditBtn: CustomBtn!


  @IBAction func onTapFinishEditBtn(_ sender: Any) {
  }


  @IBAction func onTapLogoutBtn(_ sender: Any) {

    // MARK: Show Alert：現在已經成功登出了但沒有跳通知跟回到login頁面
    logOut()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    navigationController?.navigationBar.barTintColor = .G3
    navigationController?.navigationBar.tintColor = .G1
  }

  func logOut() {

    let firebaseAuth = Auth.auth()

    do {

      try firebaseAuth.signOut()

    } catch let signOutError as NSError {

      print("Sign Out Error: %@", signOutError)
    }
  }
}
