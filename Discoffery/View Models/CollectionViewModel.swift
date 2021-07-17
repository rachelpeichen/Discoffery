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

  var onFetchAllUserSavedShops: (([String]) -> Void)? // For Detail Page

  var onRemoveShopFromDefaultCategory: (() -> Void)? // For Detail Page

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
    // For Detail Page to check if current viewd shop is saved in user's collection
    UserManager.shared.fetchUserSavedShopForDefaultCategory(user: user) { result in

      switch result {

      case .success(let savedShops):
        self.onFetchAllUserSavedShops?(savedShops.savedShopsByCategory)

      case .failure(let error):
        print("fetchUserSavedShopForDefaultCategory.failure: \(error)")
      }
    }
  }

  func removeSavedShopInDefaultCategory(user: User, shop: CoffeeShop) {

    UserManager.shared.removeSavedShopInDefaultCategory(user: user, shop: shop) { result in

      switch result {

      case .success:
        self.onRemoveShopFromDefaultCategory?()

      case .failure(let error):
        print("removeSavedShopInDefaultCategory.failure: \(error)")
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
        print("addNewCategory To Firebase Success")

      case .failure(let error):
        print("addNewCategory.failure: \(error)")
      }
    }
  }
}
