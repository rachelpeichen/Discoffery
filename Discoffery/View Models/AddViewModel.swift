//
//  AddViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import Foundation
import UIKit

class AddViewModel {

  // MARK: - Closures for DetailVC
  var onUploadImage: ((String) -> Void)?

  func uploadImageFromUser(with image: UIImage, folderName: String) {

    UserManager.shared.uploadImgFromUser(pickerImage: image, folderName: folderName) { result in
      switch result {

      case .success(let imgURL):
        self.onUploadImage?(imgURL)
        print("🔥 Upload imgs To Storage folder: \(folderName) Success")

      case .failure(let error):
        print("uploadImageFromUser.failure: \(error)")
      }
    }
  }

  func publishNewShop(newShop: inout NewCoffeeShop, uploadedImgURL: [String]) {

    CoffeeShopManager.shared.publishNewShop(newShop: &newShop, uploadedImgURL: uploadedImgURL) { result in

      switch result {

      case .success:
        print("Publish New Shop To Firebase Success")

      case .failure(let error):
        print("publishNewShop.failure: \(error)")
      }
    }
  }

  func publishUserReview(shop: CoffeeShop, review: inout Review, uploadedImgURL: [String]) {

    ReviewManager.shared.publishUserReview(shop: shop, review: &review, uploadedImgUrlArr: uploadedImgURL) { result in

      switch result {

      case .success:
        print("Publish Review To Firebase Success")

      case .failure(let error):
        print("publishUserReview.failure: \(error)")
      }
    }
  }

  func publishRecommendItem(shop: CoffeeShop, item: inout RecommendItem) {

    RecommendItemManager.shared.publishUserRecommendItem(shop: shop, item: &item) { result in

      switch result {

      case .success:
        print("Publish Recommend Item To Firebase Success")

      case .failure(let error):
        print("publishRecommendItem.failure: \(error)")
      }
    }
  }

  func checkIfRecommendItemExist(shop: CoffeeShop, item: RecommendItem) {

    RecommendItemManager.shared.checkIfRecommendItemExist(shop: shop, item: item) { [weak self] result in

      switch result {

      case .success(let didExistItem):
        print("This item already exists on Firebase: \(didExistItem), go update item count.")
        self?.updateRecommendItemCount(shop: shop, item: didExistItem)

      case .failure(let error):
        print("Same item not found on Firebase: \(error), go publish item.")
        var publishItem = item
        self?.publishRecommendItem(shop: shop, item: &publishItem)
      }
    }
  }

  func updateRecommendItemCount(shop: CoffeeShop, item: RecommendItem) {

    RecommendItemManager.shared.updateRecommendItemCount(shop: shop, item: item)
  }
}
