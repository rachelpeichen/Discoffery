//
//  Feature.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation

struct Feature: Codable {

  var id: String = "default"       // Feature.documentID
  var parentId: String = "default"      // CoffeeShop.documentID

  var socket: String = "default"
  var timeLimit: String = "default"
  var atmosphere: String = "default"

  var wifi = true
  var petFriendly = true
  var outdoorSeats = true

  enum CodingKeys: String, CodingKey {
    case id
    case parentId
    case socket
    case timeLimit
    case atmosphere
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
      "atmosphere": atmosphere as Any,

      "wifi": wifi as Any,
      "petFriendly": petFriendly as Any,
      "outdoorSeats": outdoorSeats as Any
    ]
  }
}
