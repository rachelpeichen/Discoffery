//
//  AddShopViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import Eureka

class AddShopViewController: FormViewController {

  // swiftlint:disable empty_parentheses_with_trailing_closure

  override func viewDidLoad() {

    super.viewDidLoad()

    form +++ Section("必填資訊")

      <<< TextRow() { row in
        row.title = "店家名稱"
        row.placeholder = "Enter text here"
      }

      <<< TextRow() { row in
        row.title = "店家地址"
        row.placeholder = "Enter text here"
      }

      <<< AlertRow<String>() {
        $0.title = "亲亲給个五星好評唄"
        $0.selectorTitle = "請選擇評分"
        $0.options = ["⭐️","⭐️⭐️","⭐️⭐️⭐️","⭐️⭐️⭐️⭐️","⭐️⭐️⭐️⭐️⭐️"]
        $0.value = "⭐️⭐️⭐️"   // initially selected
      }

      +++ Section("選填資訊")

      <<< CheckRow() {
        $0.title = "是否有提供免費WiFi？"
        $0.value = true
      }

      // 這裡還要改
      <<< SwitchRow("網美") { row in // initializer

        row.title = "是否有很多網美?"
      }.onChange { row in
        row.title = (row.value ?? false) ? "幹一堆網美🙄" : "很棒沒有網美👻"
        row.updateCell()
      }.cellSetup { cell, row in
        cell.backgroundColor = .white
      }.cellUpdate { cell, row in
        cell.textLabel?.font = .systemFont(ofSize: 20)
      }

      // 這裡還要改


      <<< MultipleSelectorRow<String>() {
        $0.title = "營業時間"
        $0.options = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
      }
      .onPresent { from, toShow in

        toShow.sectionKeyForValue = { option in

          switch option {

          case "6", "7" : return "週末"

          default: return "平日"
          }
        }
      }

      <<< DateRow() {
        $0.title = "造訪時間"
        $0.value = Date(timeIntervalSinceReferenceDate: 0)
      }

      <<< TextAreaRow() {
        $0.title = "評價"
        $0.placeholder = "請輸入評價"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
      }
  }
}
