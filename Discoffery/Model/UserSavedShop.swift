//
//  UserSavedShop.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/5.
//

import Foundation

struct UserSavedShops: Codable {

  var id: String = "default"                      // SavedShops.documentID

  var category: String = "所有收藏"

  var savedShopsByCategory: [String] = []  // ([coffeeShops.documentID]

  enum CodingKeys: String, CodingKey {

    case id

    case category

    case savedShopsByCategory
  }

  var toDict: [String: Any] {

    return [

      "id": id as Any,

      "category": category as Any,

      "savedShopsByCategory": savedShopsByCategory as Any
    ]
  }
}
