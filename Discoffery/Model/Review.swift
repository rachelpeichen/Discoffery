//
//  Review.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation

struct Review: Codable {

  var id: String = "default"            // Review.documentID

  var parentId: String = "default"      // CoffeeShop.documentID

  var user: String = "uid"          // User.documentID (uid)

  var userName: String = "User"

  var rating: Double = 4

  var comment: String = ""

  var recommendItems: [String] = []

  var postTime: Int64 = 0

  var imgURL: [String] = [] 

  enum CodingKeys: String, CodingKey {

    case id

    case parentId

    case user

    case userName

    case rating

    case comment

    case recommendItems

    case postTime

    case imgURL
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

      "postTime": postTime as Any,

      "imgURL": imgURL as Any
    ]
  }

}
