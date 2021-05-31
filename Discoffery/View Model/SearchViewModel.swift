//
//  SearchViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import Foundation

class SearchViewModel {

  // MARK: - Properties
  var getSearchShopsData: (([CoffeeShop]) -> Void)?

  var searchShopsData = [CoffeeShop]() {

    didSet {
      getSearchShopsData?(searchShopsData)
    }
  }

  var distanceBetweenUserAndShop: Double?

  // MARK: - Functions
  func queryShopByRecommendItem(item: String) {

    RecommendItemManager.shared.queryShopByRecommendItem(item: item) { [weak self] result in

      switch result {

      case .success(let shopsFiltered):

        self?.searchShopsData = shopsFiltered

      case .failure(let error):

        print("queryShopByRecommendItem.failure: \(error)")
      }
    }
  }

}

