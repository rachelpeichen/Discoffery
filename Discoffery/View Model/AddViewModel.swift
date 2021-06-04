//
//  AddViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import Foundation
import UIKit

class AddViewModel {

  var onFetchNewShop: ((String) -> Void)?

  var onUploadImage: ((String) -> Void)?

  // MARK: - Functions
  func fetchNewShop(name: String) {

    CoffeeShopManager.shared.fetchNewShops(name: name, completion: { result in

      switch result {

      case .success(let newShop):

        self.onFetchNewShop?(newShop.id)
        print("🥴fetchNewShop Success")

      case .failure(let error):
        print("publishNewShop.failure\(error)")
      }
    })
  }


  func publishNewShop(shop: inout CoffeeShop) {

    CoffeeShopManager.shared.publishNewShop(shop: &shop) { result in

      switch result {

      case .success:
        print("Publish 🥴New Shop To Firebase Success")

      case .failure(let error):
        print("publishNewShop.failure\(error)")
      }
    }

  }

  func publishNewShopReview(shopId: String, review: inout Review) {

    ReviewManager.shared.publishNewShopReview(shopId: shopId, review: &review) {result in

      switch result {

      case .success:
        print("Publish 🥴New ShopReview To Firebase Success")

      case .failure(let error):
        print("publishNewShop.failure\(error)")
      }
    }
  }

  func publishNewShopFeature(shopId: String, feature: inout Feature) {

    FeatureManager.shared.publishNewShopFeature(shopId: shopId, feature: &feature) { result in

      switch result {

      case .success:
        print("Publish 🥴New NewShopFeature To Firebase Success")

      case .failure(let error):
        print("publishNewShop.failure\(error)")
      }
    }

  }

  func publishNewShopRecommendItem(shopId: String, item: inout RecommendItem) {

    RecommendItemManager.shared.publishNewShopRecommendItem(shopId: shopId, item: &item) { result in

      switch result {

      case .success:
        print("Publish 🥴NewShopRecommendItem To Firebase Success")

      case .failure(let error):
        print("publishNewShop.failure\(error)")
      }
    }
  }

  func publishUserReview(shop: CoffeeShop, review: inout Review, uploadedImgURL: [String]) {

          ReviewManager.shared.publishUserReview(shop: shop, review: &review, uploadedImgURL: uploadedImgURL) { result in

      switch result {

      case .success:
        //
        print("Publish 🥴Review To Firebase Success")

      case .failure(let error):
        print("publishUserReview.failure: \(error)")
      }
    }
  }

    func uploadImageFromUserReview(with image: UIImage) {

      ReviewManager.shared.uploadImageFromUserReview(pickerImage: image) { result in
        switch result {

        case .success(let imageURL):

          self.onUploadImage?(imageURL)

          print("Upload 🥴 ImageFromUserReview To Firebase Success" + imageURL)

        case .failure(let error):
          print("publishRecommendItem: \(error)")
        }
      }
    }

  func publishRecommendItem(shop: CoffeeShop, item: inout RecommendItem) {

    RecommendItemManager.shared.publishUserRecommendItem(shop: shop, item: &item) { result in

      switch result {

      case .success:
        print("Publish 🥴Recommend Item To Firebase Success")

      case .failure(let error):
        print("publishRecommendItem: \(error)")
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
