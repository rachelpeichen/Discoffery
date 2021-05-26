//
//  AddViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import Foundation

class AddViewModel {

  var didCheckExistItems: (() -> Void)?

  // MARK: - Functions
  func publishNewShop(shop: inout CoffeeShop) {

    CoffeeShopManager.shared.publishNewShop(shop: &shop) { result in

      switch result {

      case .success:

        print("🥴Publish New Shop To Firebase Success!!")

      case .failure(let error):

        print("publishNewShop.failure\(error)")
      }
    }

  }

  func publishUserReview(shop: CoffeeShop, review: inout Review) {

    ReviewManager.shared.publishUserReview(shop: shop, review: &review) { result in

      switch result {

      case .success:
        
        print("🥴Publish Review To Firebase Success!!")

      case .failure(let error):

        print("publishUserReview.failure: \(error)")
      }
    }

  }

  func publishRecommendItem(shop: CoffeeShop, item: inout RecommendItem) {

    RecommendItemManager.shared.publishUserRecommendItem(shop: shop, item: &item) { result in

      switch result {

      case .success:

        print("🥴Publish Recommend Item To Firebase Success!!")

      case .failure(let error):

        print("publishRecommendItem: \(error)")
      }
    }

  }

  func checkIfRecommendItemExist(shop: CoffeeShop, item: RecommendItem) -> Bool {

    var didExist = false

    RecommendItemManager.shared.checkIfRecommendItemExist(shop: shop, item: item) { result in

      switch result {

      case .success(let existingItems):

        print("火地上已經有重複ㄉ推薦品ㄌ\(existingItems)")

        didExist = true

      case .failure(let error):

        print("火地上還沒有這項推薦品ㄛ \(error)")
      }
    }
    return didExist
  }

  func updateRecommendItemCount(shop: CoffeeShop, item: RecommendItem) {

    RecommendItemManager.shared.updateRecommendItemCount(shop: shop, item: item)
  }

}

