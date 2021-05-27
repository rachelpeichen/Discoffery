//
//  AddViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import Foundation

class AddViewModel {

  // MARK: - Functions
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

  func publishUserReview(shop: CoffeeShop, review: inout Review) {

    ReviewManager.shared.publishUserReview(shop: shop, review: &review) { result in

      switch result {

      case .success:
        
        print("Publish 🥴Review To Firebase Success")

      case .failure(let error):

        print("publishUserReview.failure: \(error)")
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
