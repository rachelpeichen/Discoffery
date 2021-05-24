//
//  UserReview.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import Foundation

struct UserReview: Codable {

  var id: String            // Review.documentID

  var parentId: String      // CoffeeShop.documentID

  var user: String          // User.documentID

  var userName: String

  var rating: Double

  var comment: String

  var recommendItems: [String]

  var postTime: Int64

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
