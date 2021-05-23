//
//  Features.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation

struct Features: Codable {

  var id: String // Features.documentID
  var wifi: String
  var socket: String
  var timeLimit: String
  var suitableForWork: String
  var offerMeal: Bool
  var petFriendly: Bool

  enum CodingKeys: String, CodingKey {
    case id
    case wifi
    case socket
    case timeLimit
    case suitableForWork
    case offerMeal
    case petFriendly
  }

  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "wifi": wifi as Any,
      "socket": socket as Any,
      "timeLimit": timeLimit as Any,
      "suitableForWork": suitableForWork as Any,
      "offerMeal": offerMeal as Any,
      "petFriendly": petFriendly as Any
    ]
  }
}
