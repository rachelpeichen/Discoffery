//
//  AddCategoryViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import JGProgressHUD
import PopupDialog

class AddCategoryViewController: UIViewController {

  @IBOutlet weak var addCategoryBGView: UIView!

  @IBOutlet weak var categoryTextField: UITextField!

  @IBOutlet weak var finishBtn: CustomBtn!

  @IBAction func onTapFinishBtn(_ sender: Any) {

  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view
  }

  private func layoutAddCategoryVC() {

    finishBtn.isEnabled = false
  }
}
