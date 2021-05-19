//
//  AddOpenHoursViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/19.
//

import Eureka

class AddOpenHoursViewController: FormViewController {

  let weekDays = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    form +++ Section("請選擇營業日 / 不選表示公休")

    for day in weekDays {
      form +++ SwitchRow(day) {
        $0.title = $0.tag
        $0.cellProvider = CellProvider<SwitchCell>(nibName: "SwitchCell", bundle: Bundle.main)
      }

      form +++ Section() {
        $0.hidden = .function([day], { form -> Bool in

          let row: RowOf<Bool>! = form.rowBy(tag: day)
          
          return row.value ?? false == false
        })
      }

      <<< TimeInlineRow() {
        $0.tag = day + "open"
        $0.title = "Open"
        $0.value = Date()
      }

      <<< TimeInlineRow() {
        $0.tag = day + "close"
        $0.title = "Close"
        $0.value = Date()
      }
    }

    form +++ Section("神秘ㄉ部分")

      <<< SwitchRow("不定期公休") {
        $0.title = $0.tag
        $0.value = true
        $0.cellProvider = CellProvider<SwitchCell>(nibName: "SwitchCell", bundle: Bundle.main)
        showAlert()
      }

      <<< ButtonRow("我寫好ㄌ") { (row: ButtonRow) -> Void in

        row.title = row.tag

      } .onCellSelection { [weak self] cell, row in

        showAlert()
      }

    func showAlert() {

      let alertController = UIAlertController(title: "Discoffery", message: "確定要新增ㄇ", preferredStyle: .alert)

      let defaultAction = UIAlertAction(title: "讚啦", style: .default, handler: nil)

      let cancelAction = UIAlertAction(title: "先不要好ㄌ", style: .cancel, handler: nil)

      alertController.addAction(defaultAction)

      alertController.addAction(cancelAction)

      present(alertController, animated: true)
    }
  }
}
