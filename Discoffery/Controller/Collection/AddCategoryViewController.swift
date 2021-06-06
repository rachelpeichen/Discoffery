//
//  AddCategoryViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import JGProgressHUD
import PopupDialog

protocol AddCategoryViewControllerDelegate: AnyObject {

  func finishAddCategory()
}

class AddCategoryViewController: UIViewController {

  // MARK: - Properties
  var addedCategory: String?

  weak var delegate: AddCategoryViewControllerDelegate?

  @IBOutlet weak var addCategoryBGView: UIView!

  @IBOutlet weak var categoryTextField: UITextField!

  @IBOutlet weak var finishBtn: CustomBtn!

  @IBAction func didEndAddCategory(_ sender: UITextField) {

    addedCategory = sender.text

    finishBtn.isEnabled = true

    finishBtn.backgroundColor = .B3

    finishBtn.setTitleColor(.G1, for: .normal)

    delegate?.finishAddCategory()

    showSuccessHUD(showInfo: "新增收藏分類成功")
  }
  @IBAction func onTapFinishBtn(_ sender: Any) {

    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view
  }

  private func layoutAddCategoryVC() {

    finishBtn.isEnabled = false
  }
}
