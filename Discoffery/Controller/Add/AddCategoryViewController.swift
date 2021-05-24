//
//  AddCategoryViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import Eureka

class AddCategoryViewController: FormViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view

    form +++ Section("新的收藏分類")

      <<< TextRow("新增分類名稱") { row in

        row.title = row.tag

        row.placeholder = "Enter text here"
      }

    form +++ Section()

      <<< ButtonRow("我寫好ㄌ") { (row: ButtonRow) -> Void in

        row.title = row.tag

      } .onCellSelection { [weak self] cell, row in

        showAlert()
      }

    func showAlert() {

      let alertController = UIAlertController(title: "Discoffery", message: "確定要新增ㄇ", preferredStyle: .alert)

      let defaultAction = UIAlertAction(title: "要Ｒ", style: .destructive, handler: nil)

      let cancelAction = UIAlertAction(title: "先不要好ㄌ", style: .cancel, handler: nil)

      alertController.addAction(defaultAction)

      alertController.addAction(cancelAction)

      present(alertController, animated: true)
    }
  }
}
