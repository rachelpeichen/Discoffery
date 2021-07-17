//
//  AddCategoryViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import JGProgressHUD

class AddCategoryViewController: UIViewController {

  // MARK: - Properties
  var collectionViewModel = CollectionViewModel()

  var userSavedShopDoc = UserSavedShops()

  // MARK: - IBOutles & IBActions
  @IBOutlet weak var addCategoryBGView: UIView!

  @IBOutlet weak var categoryTextField: UITextField!

  @IBOutlet weak var finishBtn: CustomBtn!

  @IBAction func didEndAddCategory(_ sender: UITextField) {

    if let category = sender.text {

      userSavedShopDoc.category = category

      finishBtn.isEnabled = true
      finishBtn.backgroundColor = .B3
      finishBtn.setTitleColor(.G1, for: .normal)
    }
  }

  @IBAction func onTapFinishBtn(_ sender: Any) {

    collectionViewModel.addNewCategory(category: userSavedShopDoc.category,
                                       user: UserManager.shared.user,
                                       savedShopDoc: &userSavedShopDoc)

      self.showSuccessHUD(showInfo: "新增分類成功")

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {

      self.dismiss(animated: true, completion: nil)

      NotificationCenter.default.post(name: .didAddNewCategory, object: nil)
    }
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

extension Notification.Name {
  static let didAddNewCategory = Notification.Name("didAddNewCategory")
}
