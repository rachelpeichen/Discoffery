//
//  Review.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation

// MARK: 這是送mock reviews的 然後postTime格式不對 之後要改掉
struct Review: Codable {

  var id: String = "default"            // Review.documentID
  var parentId: String = "default"      // CoffeeShop.documentID
  var user: String = "default"          // User.documentID

  var userName: String = "default"
  var rating: Double = 4
  var comment: String = "default"
  var recommendItems: [String] = ["default"]
  var postTime: String = "default"

  enum CodingKeys: String, CodingKey {

    case id
    case parentId
    case user
    case userName
    case rating
    case comment
    case recommendItems
    case postTime
  }

  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "parentId": parentId as Any,
      "user": user as Any,
      "userName": userName as Any,
      "rating": rating as Any,
      "comment": comment as Any,
      "recommendItems": recommendItems as Any,
      "postTime": postTime as Any
    ]
  }
}
