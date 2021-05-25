//
//  AddViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import Foundation

class AddViewModel {

  // MARK: - Properties
//  var newShop: CoffeeShop = CoffeeShop(
//    id: "",
//    name: "",
//    city: "",
//    wifi: 0,
//    seat: 0,
//    quiet: 0,
//    tasty: 0,
//    cheap: 0,
//    music: 0,
//    url: "",
//    address: "",
//    limitedTime: "",
//    socket: "",
//    standingDesk: "",
//    mrt: "",
//    openTime: "",
//    latitude: 0,
//    longitude: 0
//  )

  var onPublished: (()->())?

  // MARK: - Functions

  func publishNewShop(shop: inout CoffeeShop) {

    CoffeeShopManager.shared.publishNewShop(shop: &shop) { result in

      switch result {

      case .success:

        self.onPublished?()

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
}
