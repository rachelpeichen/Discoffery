//
//  User.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//
import Foundation

struct User: Codable {

  var id: String = "default"// User.documentID
  var appleId: String = "default"
  var blockList: [String] = ["default","default2"]
  var profileImage: String = "default" // Now only mock data
  var savedShops: String = "default" // A sub-collection

  enum CodingKeys: String, CodingKey {
    case id
    case appleId
    case profileImage
    case savedShops
    case blockList
  }

  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "appleId": appleId as Any,
      "image": profileImage as Any,
      "savedShops": savedShops as Any,
      "blockList": blockList as Any
    ]
  }
}

struct SavedShops: Codable {

  var id: String // SavedShops.documentID
  var category: String
  var savedShopsByCategory: [String] //([coffeeShops.documentID]

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
