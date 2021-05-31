//
//  LoginViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/29.
//

import UIKit

class LoginViewController: UIViewController {

  @IBAction func skipLogin(_ sender: Any) {

    performSegue(withIdentifier: "navigateToIntroVC", sender: sender)
  }

  @IBAction func onTappedLoginBtn(_ sender: Any) {

  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
}
