//
//  AddShopViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import PopupDialog
import YPImagePicker
import Cosmos

class AddShopViewController: UIViewController {

  // MARK: - Properties
  var addViewModel = AddViewModel()
  
  var wrappedNewShop = CoffeeShop()

  var wrappedNewShopReview = Review()

  var wrappedNewShopRecommendItem = RecommendItem()

  var wrappedNewShopFeature = Feature()

  var parsedOpenHours: String?


  // MARK: - IBActions
  @IBAction func backToMainPage(_ sender: UIBarButtonItem) {

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Segue to AddOpenHoursVC
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "OpenHoursVCSegue" {

      let destinationVC = segue.destination as! AddOpenHoursViewController

      destinationVC.delegate = self
    }
  }

  // MARK: - YPImagePicker
  func setUpImagesPicker() {

    var config = YPImagePickerConfiguration()

    config.library.maxNumberOfItems = 3

    let picker = YPImagePicker(configuration: config)

    present(picker, animated: true, completion: nil)

    picker.didFinishPicking { [unowned picker] items, cancelled in

      if cancelled {

        picker.dismiss(animated: true, completion: nil)

      } else {

        for item in items {

          switch item {

          case .photo(let photo):

            self.addViewModel.uploadImageFromUserReview(with: photo.image)

          case .video(let video):

            print("You cannot upload video lmao \(video)")
          }
        }
        picker.dismiss(animated: true, completion: nil)

        self.showStandardDialog(title: "新增相片成功☺️", message: "讚讚讚")
      }
    }
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.


    //        // Get user's input and wrap as my struct type
    //        guard let dict = self?.form.values(includeHidden: true) else { return }
    //
    //        self?.showSuccessDialog(title: "新增成功", message: "您送出的新店家資訊正在審核中，審核通過後就會更新到Discoffery了喔。")
    //
    //        var newShop = self?.parseInputToShop(inputDic: dict)
    //
    //        self?.addViewModel.publishNewShop(shop: &(newShop)!)

    // MARK: Parse input to my struct
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

        //        addViewModel.publishNewShopRecommendItem(shopId: shopId!, item: &wrappedNewShopRecommendItem)
      }
    }

    func parseInputToFeature(inputDic: [String: Any?]) -> Feature {

      wrappedNewShopFeature.socket = inputDic["socket"] as? String ?? "Unknown"

      wrappedNewShopFeature.timeLimit = inputDic["timeLimit"] as? String ?? "Unknown"

      wrappedNewShopFeature.special = inputDic["customFeatures"] as? [String] ?? [""]

      return wrappedNewShopFeature
    }
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
