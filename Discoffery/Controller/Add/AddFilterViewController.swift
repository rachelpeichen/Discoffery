//
//  AddFilterViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import Eureka
import PopupDialog

class AddFilterViewController: FormViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    form +++ Section("篩選條件")

      <<< TextRow("安安") { row in
        row.title = row.tag
        row.placeholder = "嘎哩ㄍㄟㄍㄟ"

      }.cellSetup { cell, row in

        cell.height = { 44 }
      }

      <<< SwitchRow("你要不要吃哈密瓜🍈") {
        $0.title = $0.tag
        $0.cellProvider = CellProvider<SwitchCell>(nibName: "SwitchCell", bundle: Bundle.main)

      }.cellSetup { cell, row in

        cell.height = { 44 }
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
