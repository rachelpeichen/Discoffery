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

    // Do any additional setup after loading the view.
    form +++ Section("必填資訊")

      <<< TextRow("店名") { row in
        row.title = row.tag
        row.placeholder = "請輸入名稱"
      }

      <<< TextRow("地址") { row in
        row.title = row.tag
        row.placeholder = "請輸入地址"
      }

      <<< AlertRow<String>("評分") {
        $0.title = $0.tag
        $0.selectorTitle = "請選擇評分"
        $0.options = ["★", "★★", "★★★", "★★★★", "★★★★★"]
        $0.value = "★★★"   // initially selected
      }

      <<< ButtonRow("營業時間") { row in
        row.title = row.tag
        row.presentationMode = .segueName(segueName: "OpenHoursNavigationControllerSegue", onDismiss: { presentVC in
          presentVC.dismiss(animated: true)
        })
      }
    
    form +++ Section("選填資訊：個人評論")

      <<< TextAreaRow("評論") {
        $0.title = $0.tag
        $0.placeholder = "請輸入評論"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 120)
      }

    form +++ Section("選填資訊：環境設施")

      // MARK: 這個要再改
//      <<< ButtonRow("鄰近捷運站") { (row: ButtonRow) -> Void in
//        row.title = row.tag
//        row.presentationMode = .segueName(segueName: "HiddenMRTRowsControllerSegue", onDismiss: nil)
//      }

      <<< PickerInputRow<String>("時間限制") {
        $0.title = $0.tag
        $0.options = []
        $0.options.append("不限時")
        $0.options.append("有限時")
        $0.options.append("視營業情況限時")
        $0.value = $0.options.first
      }

      <<< PickerInputRow<String>("插座") {
        $0.title = $0.tag
        $0.options = []
        $0.options.append("無插座")
        $0.options.append("每個座位都有插座")
        $0.options.append("部分座位有插座")
        $0.value = $0.options.first
      }

      <<< ButtonRow("特色服務") { (row: ButtonRow) -> Void in
        row.title = row.tag
        row.presentationMode = .segueName(segueName:
                                            "AddFeatureControllerSegue",
                                          onDismiss: nil)
      }

    form +++ MultivaluedSection(multivaluedOptions:
                                  [.Insert, .Delete],
                                header: "選填資訊：推薦飲料或餐點",
                                footer: "按 ＋ 新增按 – 刪除") {
      $0.tag = "用戶新增"

      $0.addButtonProvider = { _ in

        return ButtonRow("新增") {
          $0.title = $0.tag

        } .cellUpdate { cell, _ in
          cell.textLabel?.textAlignment = .left
        }
      }
      $0.multivaluedRowToInsertAt = { index in

        return NameRow("名稱") {
          $0.placeholder = $0.tag
        }
      }

      form +++ Section()

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
}
