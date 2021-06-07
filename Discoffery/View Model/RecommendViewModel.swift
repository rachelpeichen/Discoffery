//
//  RecommendViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/8.
//

import Foundation

class RecommendViewModel {

  var onShopsByRecommendItem: (() -> Void)?

  var shopsByRecommendItem = [CoffeeShop]() {

    didSet {

      onShopsByRecommendItem?()
    }
  }

  func fetchShopByRecommendItem() {

    CoffeeShopManager.shared.fetchShopByRecommendItem() { result in

      switch result {

      case .success(let shops):

        self.shopsByRecommendItem = shops

      case .failure(let error):

        print("fetchKnownShopByDocId.failure: \(error)")
      }
    }
  }
}
