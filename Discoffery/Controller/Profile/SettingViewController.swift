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

  @IBOutlet weak var logoutBtn: CustomBtn!

  // MARK: Hide
  @IBAction func onTapLogoutBtn(_ sender: Any) {

    showLogoutSuccessDialog()

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {

      do {

        try Auth.auth().signOut()

      } catch let error {

        print("Error: ", error.localizedDescription)
      }
    }
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

    userNameLabel.text = UserDefaults.standard.object(forKey: "uid") as? String
  }
}
