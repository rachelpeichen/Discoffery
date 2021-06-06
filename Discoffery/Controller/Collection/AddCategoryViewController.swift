//
//  AddCategoryViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import JGProgressHUD

protocol AddCategoryViewControllerDelegate: AnyObject {

  func finishAddCategory(input: String)
}

class AddCategoryViewController: UIViewController {

  // MARK: - Properties
  weak var delegate: AddCategoryViewControllerDelegate?

  @IBOutlet weak var addCategoryBGView: UIView!

  @IBOutlet weak var categoryTextField: UITextField!

  @IBOutlet weak var finishBtn: CustomBtn!

  @IBAction func didEndAddCategory(_ sender: UITextField) {

    if let input = sender.text {

      finishBtn.isEnabled = true

      finishBtn.backgroundColor = .B3

      finishBtn.setTitleColor(.G1, for: .normal)

      delegate?.finishAddCategory(input: input)
    }
  }

  @IBAction func onTapFinishBtn(_ sender: Any) {

    showSuccessHUD(showInfo: "新增分類成功")

    dismiss(animated: true, completion: nil)
  }

  @IBAction func backToPreviousVC(_ sender: Any) {

    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view
    layoutAddCategoryVC()
  }

  private func layoutAddCategoryVC() {

    finishBtn.isEnabled = false

    addCategoryBGView.layoutViewWithShadow()
  }
}
