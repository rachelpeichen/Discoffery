//
//  AddOpenHoursViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/19.
//

import Eureka
import PopupDialog

protocol AddOpenHoursViewControllerDelegate: AnyObject {

  func finishAddOpenHours(openHours: [String: Any?])
}

class AddOpenHoursViewController: FormViewController {

  // MARK: - Properties
  weak var delegate: AddOpenHoursViewControllerDelegate?

  var openHours: [String: Any?]?

  let weekDays = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]

  override func viewDidLoad() {
    super.viewDidLoad()

    openHours = form.values(includeHidden: true)

    // Do any additional setup after loading the view.

    TimeInlineRow.defaultCellSetup = { cell, row in
      cell.textLabel?.font = .systemFont(ofSize: 16)
      cell.textLabel?.textColor = .G1
    }

    form +++
      Section("請選擇營業日 / 不選表示公休")

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
        $0.tag = day + "_open"
        $0.title = "Open"
        $0.value = Date()
      }

      <<< TimeInlineRow() {
        $0.tag = day + "_close"
        $0.title = "Close"
        $0.value = Date()
      }
    }

    form +++ Section("特殊營業時間")

      <<< SwitchRow("不定期公休") {
        $0.title = "不定期公休"
        $0.tag = "noRegularClose"
        $0.value = true
        $0.cellProvider = CellProvider<SwitchCell>(nibName: "SwitchCell", bundle: Bundle.main)
      }

      <<< ButtonRow("我寫好ㄌ") {(row: ButtonRow) -> Void in
        row.title = "我寫好ㄌ"
        row.tag = "finish"

      } .onCellSelection { [weak self] cell, row in

        self?.showStandardDialog(title: "填寫完成☺️", message: "讚讚讚")

        // MARK: Get user's input of opening hours
        self?.openHours = self?.form.values()
        
        self?.delegate?.finishAddOpenHours(openHours: (self?.openHours)!)
      }
  }
}
