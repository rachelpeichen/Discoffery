//
//  Feature.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation

struct Feature: Codable {

  // Feature.documentID
  var id: String = "default"

  // CoffeeShop.documentID
  var parentId: String = "default"

  var socket: String = "default"
  var timeLimit: String = "default"
  var special: [String] = []

  var wifi = true
  var petFriendly = true
  var outdoorSeats = true

  enum CodingKeys: String, CodingKey {

    case id
    case parentId
    case socket
    case timeLimit
    case special
    case wifi
    case petFriendly
    case outdoorSeats
  }
  
  var toDict: [String: Any] {

    return [
      "id": id as Any,
      "parentId": parentId as Any,
      "socket": socket as Any,
      "timeLimit": timeLimit as Any,
      "special": special as Any,
      "wifi": wifi as Any,
      "petFriendly": petFriendly as Any,
      "outdoorSeats": outdoorSeats as Any
    ]
  }
}
