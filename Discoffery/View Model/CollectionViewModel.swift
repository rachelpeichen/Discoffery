//
//  CollectionViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/6.
//

import Foundation

class CollectionViewModel {

  var onAddUserSavedShop: (() -> Void)?

  var onAddNewCategory: (() -> Void)?

  var onFetchSavedShopsForSpecificCategory: (() -> Void)?

  var onFetchSavedShopsForDefaultCategory: (() -> Void)?

  var onFetchSavedShopsForAllCategory: (() -> Void)?

  var savedShopsForSpecificCategory = [CoffeeShop]() {

    didSet {

      onFetchSavedShopsForSpecificCategory?()
    }
  }

  // 這個應該是用不到ㄌ！多餘
  var savedShopsForDefaultCategory = [CoffeeShop]() {

    didSet {

      onFetchSavedShopsForDefaultCategory?()
    }
  }

  var savedShopsForAllCategory: [UserSavedShops] = [] {

    didSet {

      onFetchSavedShopsForAllCategory?()
    }
  }

  func addUserSavedShopToDefaultCategory(user: User, shop: CoffeeShop, savedShop: inout UserSavedShops) {
    
    UserManager.shared.addUserSavedShopToDefaultCategory(user: user, shop: shop, savedShop: &savedShop) { result in
      
      switch result {
      
      case .success:

        self.onAddUserSavedShop?()
        
        print("🥴addUserSavedShop To Firebase Success")
        
      case .failure(let error):
        
        print("addUserSavedShop.failure: \(error)")
      }
    }
  }

  func fetchUserSavedShopForDefaultCategory(user: User) {

    UserManager.shared.fetchUserSavedShopForDefaultCategory(user: user) { result in

      switch result {

      case .success(let savedShops):

        if !savedShops.savedShopsByCategory.isEmpty {

          let savedShopsArr = savedShops.savedShopsByCategory

          self.fetchKnownShopByDocId(shopid: savedShopsArr)
        }

      case .failure(let error):

        print("fetchUserSavedShopForDefaultCategory.failure: \(error)")
      }
    }
  }

  func fetchSavedShopsForAllCategory(user: User) {

    UserManager.shared.fetchSavedShopsForAllCategory(user: user) { result in

      switch result {

      case .success(let savedShopDocs):

        self.savedShopsForAllCategory = savedShopDocs

      case .failure(let error):

        print("fetchSavedShopsForAllCategory.failure: \(error)")
      }
    }
  }

  func fetchKnownShopByDocId(shopid: [String]) {

    CoffeeShopManager.shared.fetchKnownShopByDocId(docId: shopid) { result in

      switch result {

      case .success(let shop):

        //self.savedShopsForDefaultCategory = shop

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
