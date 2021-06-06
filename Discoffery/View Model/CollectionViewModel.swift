//
//  CollectionViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/6.
//

import Foundation

class CollectionViewModel {

  var onAddUserSavedShop: (() -> Void)?
  
  func addUserSavedShop(user: User, shop: CoffeeShop, savedShop: inout UserSavedShops) {
    
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

  func fetchUserSavedShopForDefaultCategory() {

  }
}
