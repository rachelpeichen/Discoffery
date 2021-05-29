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

  var shopId: String?

  // MARK: - Functions
  @IBAction func backToMainPage(_ sender: UIBarButtonItem) {

    self.dismiss(animated: true, completion: nil)
  }

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
    //    tableView.backgroundColor = .lightGray



    if tableView == nil {
      tableView = UITableView(frame: view.bounds, style: UITableView.Style.plain)
      tableView?.autoresizingMask = UIView.AutoresizingMask.flexibleWidth.union(.flexibleHeight)
    }

    PickerInlineRow<String>.InlineRow.defaultCellUpdate = { cell, _ in
      cell.textLabel?.font = .systemFont(ofSize: 18)
      cell.backgroundColor = .B3
    }

    TextRow.defaultCellSetup = { cell, row in
      cell.titleLabel?.font = .systemFont(ofSize: 18)
      cell.textLabel?.textColor = .G1
      cell.tintColor = .B3
    }

    TextRow.defaultCellUpdate = { cell, row in
      cell.textField.font = .systemFont(ofSize: 18)
      cell.textField.textColor = .G1
    }

    form +++

      Section("必填資訊")

      <<< TextRow("店名") { row in
        row.title = "店名"
        row.tag = "name"
        row.placeholder = "請輸入名稱"
      }

      <<< TextRow("地址") { row in
        row.title = "地址"
        row.tag = "address"
        row.placeholder = "請輸入地址"
      }

      <<< SegmentedRow<Int>() {
        $0.title = "評分"
        $0.tag = "rating"
        $0.options = [1, 2, 3, 4, 5]

      }.cellSetup({ cell, row in
        cell.titleLabel?.font = .systemFont(ofSize: 18)
        cell.textLabel?.textColor = .G1
        cell.tintColor = .B3
      })

      <<< ButtonRow("營業時間") { row in
        row.title = "營業時間"
        row.tag = "openTime"
        row.presentationMode = .segueName(segueName: "OpenHoursVCSegue", onDismiss: { presentVC in

          presentVC.dismiss(animated: true)
        })
      }.cellSetup({ cell, row in
        cell.textLabel?.font = .systemFont(ofSize: 18)
        cell.textLabel?.textColor = .G1
        cell.tintColor = .B3

      }).onCellSelection({ cell, row in
        cell.textLabel?.textColor = .B1
      })
    
    form +++

      Section("選填資訊：評價")

      <<< TextAreaRow("評論") {
        $0.title = "評論"
        $0.tag = "comment"
        $0.placeholder = "請輸入評價內容"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 120)

      }.cellUpdate({ cell, row in
        cell.textView.font = .systemFont(ofSize: 18)
        cell.textView.textColor = .G1
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
        cell.textLabel?.font = .systemFont(ofSize: 18)
        cell.textLabel?.textColor = .G1
      })

      <<< PickerInputRow<String>("插座") {
        $0.title = "插座提供"
        $0.tag = "socket"
        $0.options = []
        $0.options.append("無插座")
        $0.options.append("每個座位都有插座")
        $0.options.append("部分座位有插座")
        $0.value = $0.options.first

      }.cellSetup({ cell, row in
        cell.textLabel?.font = .systemFont(ofSize: 18)
        cell.tintColor = .B1
        cell.textLabel?.textColor = .G1
      })

    form +++

      MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                         header: "選填資訊：推薦飲料或餐點",
                         footer: "") {
        $0.tag = "customItems"

        $0.addButtonProvider = { _ in

          return ButtonRow() {

            $0.title = "新增品項"

          }.cellUpdate { cell, _ in
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = .systemFont(ofSize: 18)

          }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(named: "plus")
            cell.textLabel?.font = .systemFont(ofSize: 18)
            cell.tintColor = .G1
          }
        }

        $0.multivaluedRowToInsertAt = { _ in

          return TextRow() {
            $0.placeholder = "品項名稱"

          } .cellUpdate { cell, row in
            cell.textField.font = .systemFont(ofSize: 18)
            cell.textField.textColor = .G1
          }
        }
      }

    form +++

      MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                         header: "選填資訊：店家特色",
                         footer: "") {
        $0.tag = "customFeatures"

        $0.addButtonProvider = { _ in

          return ButtonRow() {

            $0.title = "新增特色"

          }.cellUpdate { cell, _ in
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = .systemFont(ofSize: 18)

          }.cellSetup { cell, _ in
            cell.imageView?.image = UIImage(named: "plus")
            cell.textLabel?.font = .systemFont(ofSize: 18)
            cell.tintColor = .G1
          }
        }

        $0.multivaluedRowToInsertAt = { _ in

          return TextRow() {
            $0.placeholder = "特色"

          } .cellUpdate { cell, row in
            cell.textField.font = .systemFont(ofSize: 18)
            cell.textField.textColor = .G1
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
        row.disabled = true

      }.cellSetup({ cell, row in
        cell.backgroundColor = .G2
        cell.tintColor = .white

      }).onCellSelection { [weak self] cell, row in



        self?.showAlert()

        // MARK: Get user's input and wrap as my struct type  
        guard let dict = self?.form.values(includeHidden: true) else { return }

        print(dict)

        var newShop = self?.parseInputToShop(inputDic: dict)

        var newShopReview = self?.parseInputToReview(inputDic: dict)

        var newShopFeature = self?.parseInputToFeature(inputDic: dict)

        // MARK: Publish to Firebase
        self?.addViewModel.publishNewShop(shop: &(newShop)!)

        self?.addViewModel.onFetchNewShop = { result  in
          self?.shopId = result
        }

        // MARK: 這裡和Detail Page 送 review一樣 拿到shop.id 才能去Po 現在無法思考 0528
        //self?.addViewModel.publishNewShopReview(shopId: (self?.shopId)!, review: &(newShopReview!))
        //self?.addViewModel.publishNewShopFeature(shopId: (self?.shopId)!, feature: &(newShopFeature!))
        // self?.parseInputToRecommendItem(inputDic: dict)

      }
  }

  // MARK: Functions
  func parseInputToShop(inputDic: [String: Any?]) -> CoffeeShop {

    wrappedNewShop.name = inputDic["name"] as? String ?? "Unknown Name"

    wrappedNewShop.address = inputDic["address"] as? String ?? "Unknown Address"

    wrappedNewShop.socket = inputDic["socket"] as? String ?? "Unknown"

    wrappedNewShop.limitedTime = inputDic["timeLimit"] as? String ?? "Unknown"

    wrappedNewShop.openTime = parsedOpenHours ?? "Unknown"

    return wrappedNewShop
  }

  func parseInputToReview(inputDic: [String: Any?]) -> Review {

    wrappedNewShopReview.comment = inputDic["comment"] as? String ?? "Unknown Name"

    wrappedNewShopReview.rating = inputDic["rating"] as? Double ?? 3

    wrappedNewShopReview.recommendItems = inputDic["customItems"] as? [String] ?? [""]

    return wrappedNewShopReview
  }

  func parseInputToRecommendItem(inputDic: [String: Any?]) {

    for item in inputDic["items"] as! [String] {

      wrappedNewShopRecommendItem.item = item

      addViewModel.publishNewShopRecommendItem(shopId: shopId!, item: &wrappedNewShopRecommendItem)
    }
  }

  func parseInputToFeature(inputDic: [String: Any?]) -> Feature {

    wrappedNewShopFeature.socket = inputDic["socket"] as? String ?? "Unknown"

    wrappedNewShopFeature.timeLimit = inputDic["timeLimit"] as? String ?? "Unknown"

    wrappedNewShopFeature.special = inputDic["customFeatures"] as? [String] ?? [""]

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
