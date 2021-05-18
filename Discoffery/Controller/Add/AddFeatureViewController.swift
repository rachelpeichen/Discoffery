//
//  AddFeatureViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/19.
//

import Eureka

class AddFeatureViewController: FormViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    let defaultFeatures = ["沒有網美", "寵物友善", "戶外座位", "冷氣很涼", "小鮮肉店員", "咖啡喝了睡不著"]

    form +++ SelectableSection<CustomCheckRow<String>>("有的沒的", selectionType: .multipleSelection) { section in

      section.header = HeaderFooterView(title: "有的沒的")
    }

    for feature in defaultFeatures {
      form.last! <<< CustomCheckRow<String>(feature) { lrow in
        lrow.title = feature
        lrow.selectableValue = feature
        lrow.value = nil
      }
    }
    form +++ MultivaluedSection(multivaluedOptions:
                                  [.Insert, .Delete],
                                header: "自己填特色啦",
                                footer: "按 ＋ 新增按 - 刪掉") {
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
          $0.placeholder = "特色"
        }
      }
    }
  }
  override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {

    if row.section === form[0] {
      print("Mutiple Selection選到:\((row.section as! SelectableSection<CustomCheckRow<String>>).selectedRows().map({$0.baseValue}))")
    }
  }
}
