//
//  AddShopViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import Eureka

class AddShopViewController: FormViewController {

  override func viewDidLoad() {

    super.viewDidLoad()

    form +++ Section("必填資訊")

      <<< TextRow() { row in
        row.title = "店家名稱"
        row.placeholder = "請輸入名稱"
      }

      <<< TextRow() { row in
        row.title = "店家地址"
        row.placeholder = "請輸入地址"
      }

      <<< AlertRow<String>() {
        $0.title = "亲給个五星好評唄"
        $0.selectorTitle = "請選擇評分"
        $0.options = ["⭐️", "⭐️⭐️", "⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️⭐️"]
        $0.value = "⭐️⭐️⭐️"   // initially selected
      }
      
        <<< TextAreaRow() {
          $0.value = "營業時間"
          $0.textAreaMode = .readOnly
          $0.textAreaHeight = .fixed(cellHeight: 44)
    }

      <<< WeekDayRow(){
          $0.value = [.monday, .wednesday, .friday]
      }
    
    form +++ Section("選填資訊：個人評價")

      <<< TextAreaRow() {
        $0.title = "評價"
        $0.placeholder = "請輸入評價"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 120)
      }

    form +++ Section("選填資訊：環境設施")

      <<< ButtonRow("鄰近捷運站") { (row: ButtonRow) -> Void in
        row.title = row.tag
        row.presentationMode = .segueName(segueName: "HiddenMRTRowsControllerSegue", onDismiss: nil)
      }

      <<< PickerInputRow<String>("限時") {
        $0.title = "時間限制"
        $0.options = []
        $0.options.append("不限時")
        $0.options.append("有限時")
        $0.options.append("視營業情況限時")
        $0.value = $0.options.first
      }

      <<< PickerInputRow<String>("插座") {
        $0.title = "插座"
        $0.options = []
        $0.options.append("無插座")
        $0.options.append("每個座位都有插座")
        $0.options.append("部分座位有插座")
        $0.value = $0.options.first
      }

      <<< ButtonRow("特色服務") { (row: ButtonRow) -> Void in
        row.title = row.tag
        row.presentationMode = .segueName(segueName: "AddFeatureControllerSegue", onDismiss: nil)
      }

    form +++ MultivaluedSection(multivaluedOptions:
                                  [.Insert, .Delete],
                                header: "選填資訊：推薦飲料或餐點",
                                footer: "按 ＋ 新增按 – 刪掉") {
      $0.tag = "textfields"
      $0.addButtonProvider = { section in
        return ButtonRow(){
          $0.title = "新增"
        }.cellUpdate { cell, row in
          cell.textLabel?.textAlignment = .left
        }
      }
      $0.multivaluedRowToInsertAt = { index in
        return NameRow() {
          $0.placeholder = "名稱"
        }
      }
    }
  }
}
