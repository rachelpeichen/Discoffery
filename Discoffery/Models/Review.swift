//
//  Review.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation

struct Review: Codable {

  // Review.documentID
  var id: String = "default"

  // CoffeeShop.documentID
  var parentId: String = "default"

  // User.documentID
  var user: String = "uid"

  var userName: String = "Pei Pei"
  var userImg: String?
  var comment: String = "該用戶無填寫評論"
  var recommendItems: [String] = []
  var imgURL: [String] = []

  var rating: Double = 4
  var postTime: Int64 = 0

  enum CodingKeys: String, CodingKey {

    case id
    case parentId
    case user
    case userName
    case userImg
    case comment
    case recommendItems
    case imgURL
    case rating
    case postTime
  }

  var toDict: [String: Any] {

    return [
      "id": id as Any,
      "parentId": parentId as Any,
      "user": user as Any,
      "userName": userName as Any,
      "userImg": userImg as Any,
      "comment": comment as Any,
      "recommendItems": recommendItems as Any,
      "imgURL": imgURL as Any,
      "rating": rating as Any,
      "postTime": postTime as Any
    ]
  }
}
