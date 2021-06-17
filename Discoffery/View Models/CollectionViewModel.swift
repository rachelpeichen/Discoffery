//
//  CollectionViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/6.
//

import Foundation

class CollectionViewModel {

  // MARK: - Closures For Notifying View Controllers
  var onAddUserSavedShop: (() -> Void)?

  var onAddNewCategory: (() -> Void)?

  var onFetchSavedShopsForSpecificCategory: (() -> Void)?

  var onFetchSavedShopsForDefaultCategory: (() -> Void)?

  var onFetchSavedShopsForAllCategory: (() -> Void)?

  var savedShopsForSpecificCategory: [CoffeeShop] = [] {

    didSet {

      onFetchSavedShopsForSpecificCategory?()
    }
  }

  // MARK: - Properties
  var savedShopsForAllCategory: [UserSavedShops] = [] {

    didSet {

      onFetchSavedShopsForAllCategory?()
    }
  }

  func addUserSavedShopToDefaultCategory(user: User, shop: CoffeeShop, savedShop: inout UserSavedShops) {
    
    UserManager.shared.addToDefaultCollectionCategory(user: user, addedShop: shop, savedShops: &savedShop) { result in
      
      switch result {
      
      case .success:
        self.onAddUserSavedShop?()

      case .failure(let error):
        print("addUserSavedShop.failure: \(error)")
      }
    }
  }

  func fetchSavedShopsInDefaultCategory(user: User) {

    UserManager.shared.fetchUserSavedShopForDefaultCategory(user: user) { result in

      switch result {

      case .success(let savedShops):

        if !savedShops.savedShopsByCategory.isEmpty {

          let savedShopsArr = savedShops.savedShopsByCategory

          self.fetchSavedShop(shopid: savedShopsArr)
        }

      case .failure(let error):
        print("fetchUserSavedShopForDefaultCategory.failure: \(error)")
      }
    }
  }

  func fetchCollectionsForAllCategories(user: User) {

    UserManager.shared.fetchSavedShopsForAllCategory(user: user) { result in

      switch result {

      case .success(let savedShopDocs):
        self.savedShopsForAllCategory = savedShopDocs

      case .failure(let error):
        print("fetchSavedShopsForAllCategory.failure: \(error)")
      }
    }
  }

  func fetchSavedShop(shopid: [String]) {

    CoffeeShopManager.shared.fetchKnownShopByDocId(docId: shopid) { result in

      switch result {

      case .success(let shop):
        self.savedShopsForSpecificCategory = shop

      case .failure(let error):
        print("fetchKnownShopByDocId.failure: \(error)")
      }
    }
  }

  func addNewCategory(category: String, user: User, savedShopDoc: inout UserSavedShops) {

    UserManager.shared.addNewCategory(user: user, category: category, savedShopDoc: &savedShopDoc) { result in

      switch result {

      case .success:

        self.onAddNewCategory?()

        print("🥴addNewCategory To Firebase Success")

      case .failure(let error):

        print("addNewCategory.failure: \(error)")
      }
    }
  }
}
