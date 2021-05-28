//
//  AddShopViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import Eureka

// swiftlint:disable function_body_length
// swiftlint:disable force_cast
// swiftlint:disable trailing_closure
// swiftlint:disable unused_closure_parameter
// swiftlint:disable multiline_function_chains

class AddShopViewController: FormViewController {

  // MARK: - Properties
  var addViewModel = AddViewModel()
  
  var wrappedNewShop = CoffeeShop()

  var wrappedNewShopReview = Review()

  var wrappedNewShopRecommendItem = RecommendItem()

  var wrappedNewShopFeature = Feature()

  var parsedOpenHours: String?

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "OpenHoursVCSegue"{

      let destinationVC = segue.destination as! AddOpenHoursViewController

      // Since this class is now a delegate, setup the delegate
      destinationVC.delegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    tableView.backgroundColor = UIColor.init(named: "G3")

    form +++

      Section("必填資訊")

      <<< TextRow("店名") { row in
        row.title = "店名"
        row.tag = "name"
        row.placeholder = "請輸入名稱"

      }.cellSetup({ cell, row in
        cell.titleLabel?.font = .boldSystemFont(ofSize: 18)
        cell.titleLabel?.textColor = UIColor.init(named: "G1")
        cell.tintColor = UIColor.init(named: "B1")

      }).cellUpdate({ cell, row in
        cell.textField.font = .systemFont(ofSize: 18)
        cell.textField.textColor = UIColor.init(named: "G1")
      })

      <<< TextRow("地址") { row in
        row.title = "地址"
        row.tag = "address"
        row.placeholder = "請輸入地址"

      }.cellSetup({ cell, row in
        cell.titleLabel?.font = .boldSystemFont(ofSize: 18)
        cell.titleLabel?.textColor = UIColor.init(named: "G1")
        cell.tintColor = UIColor.init(named: "B1")

      }).cellUpdate({ cell, row in // update 是textfield的
        cell.textField.font = .systemFont(ofSize: 18)
        cell.textField.textColor = UIColor.init(named: "G1")
      })

      <<< SegmentedRow<Int>() {
        $0.title = "評分"
        $0.tag = "rating"
        $0.options = [1, 2, 3, 4, 5]

      }.cellSetup({ cell, row in
        cell.titleLabel?.font = .boldSystemFont(ofSize: 18)
        cell.titleLabel?.textColor = UIColor.init(named: "B1")
      })

      <<< ButtonRow("營業時間") { row in
        row.title = "營業時間"
        row.tag = "openTime"
        row.presentationMode = .segueName(segueName: "OpenHoursVCSegue", onDismiss: { presentVC in

          presentVC.dismiss(animated: true)
        })
      }.cellSetup({ cell, row in

      })
    
    form +++

      Section("選填資訊")

      <<< TextAreaRow("評論") {
        $0.title = "評論"
        $0.tag = "comment"
        $0.placeholder = "請輸入評價內容"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 120)

      }.cellUpdate({ cell, row in
        cell.textView.font = .systemFont(ofSize: 18)
        cell.placeholderLabel?.font = .systemFont(ofSize: 18)
      })

    form +++

      Section("選填資訊：環境特色")

      <<< PickerInputRow<String>("時間限制") {
        $0.title = "時間限制"
        $0.tag = "timeLimit"
        $0.options = []
        $0.options.append("不限時")
        $0.options.append("有限時")
        $0.options.append("視營業情況限時")
        $0.value = $0.options.first

      }.cellSetup({ cell, row in
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        cell.tintColor = UIColor.init(named: "B1")
        cell.textLabel?.textColor = UIColor.init(named: "G1")
      })

      <<< PickerInputRow<String>("插座") {
        $0.title = "插座提供"
        $0.tag = "socket"
        $0.options = []
        $0.options.append("無插座")
        $0.options.append("每個座位都有插座")
        $0.options.append("部分座位有插座")
        $0.value = $0.options.first
      }

      <<< ButtonRow("特色服務") { (row: ButtonRow) -> Void in
        row.title = "特色服務"
        row.tag = "feature"
        row.presentationMode = .segueName(segueName:
                                            "AddFeatureControllerSegue",
                                          onDismiss: nil)
      }

    form +++

      MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                         header: "選填資訊：輸入推薦飲料或餐點",
                         footer: "左滑可以刪除") {
        $0.tag = "items"

        $0.addButtonProvider = { _ in

          return ButtonRow() {

            $0.title = "新增品項"

          }.cellUpdate { cell, _ in
            cell.textLabel?.textAlignment = .left

          }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(named: "plus")

          }
        }

        $0.multivaluedRowToInsertAt = { _ in

          return TextRow() {
            $0.placeholder = "品項名稱"
          }
        }
      }
    //    form +++
    //
    //      Section() // 貌似只能選一張ＱＱ？
    //
    //      <<< ImageRow() {
    //        $0.title = "上傳相關照片"
    //      }
    form +++

      Section()

      <<< ButtonRow("送出") { (row: ButtonRow) -> Void in
        row.title = "送出"
        row.tag = "send"

      }.cellSetup({ cell, row in
        cell.backgroundColor =  UIColor.init(named: "B3")
        cell.tintColor = UIColor.init(named: "B1")

      }).onCellSelection { [weak self] (cell, row) in
        self?.showAlert()

        // MARK: Get user's input and wrap as my struct type  
        guard let dict = self?.form.values(includeHidden: true) else { return }

        var newShop = self?.parseInputToShop(inputDic: dict)

        // MARK: 要檢查必填的都有了才能送出！
        self?.addViewModel.publishNewShop(shop: &(newShop)!)

        //        let newShopReview = self?.parseInputToReview(inputDic: dict) as Any
        //        let newShopFeature = self?.parseInputToFeature(inputDic: dict) as Any
        //        let newShopRecommendItem = self?.parseInputToRecommendItem(inputDic: dict) as Any
      }
  }

  // MARK: Functions
  func parseInputToShop(inputDic: [String: Any?]) -> CoffeeShop {

    wrappedNewShop.name = inputDic["name"] as! String

    wrappedNewShop.address = inputDic["address"] as! String

    wrappedNewShop.socket = inputDic["socket"] as! String

    wrappedNewShop.limitedTime = inputDic["timeLimit"] as! String

    wrappedNewShop.openTime = parsedOpenHours ?? "Opening Time Unknown"

    return wrappedNewShop
  }

  func parseInputToReview(inputDic: [String: Any?]) -> Review {

    wrappedNewShopReview.comment = inputDic["comment"] as! String

    wrappedNewShopReview.rating = inputDic["rating"] as! Double

    wrappedNewShopReview.recommendItems = inputDic["items"] as! [String]

    return wrappedNewShopReview
  }

  func parseInputToRecommendItem(inputDic: [String: Any?]) -> RecommendItem {

    // MARK: 確認有輸入推薦品才可送 還沒

    for item in inputDic["items"] as! [String] {

      wrappedNewShopRecommendItem.item = item

      print(wrappedNewShopRecommendItem.item)

      // MARK: 這裡送上去 還沒
    }
    return wrappedNewShopRecommendItem
  }

  func parseInputToFeature(inputDic: [String: Any?]) -> Feature {

    // MARK: 確認有輸入特色才可送

    wrappedNewShopFeature.socket = inputDic["socket"] as! String

    wrappedNewShopFeature.timeLimit = inputDic["timeLimit"] as! String

    return wrappedNewShopFeature
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

extension AddShopViewController: AddOpenHoursViewControllerDelegate {

  func finishAddOpenHours(openHours: [String: Any?]) {

    let openHoursDic = openHours.compactMapValues { $0 }

    parsedOpenHours = (openHoursDic.compactMap({ (key, value) -> String in

      return "\(key):\(value)"

    }) as Array).joined(separator: ";")
  }
}
