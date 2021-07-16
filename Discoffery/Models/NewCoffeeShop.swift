//
//  NewCoffeeShop.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/11.
//

import Foundation

struct NewCoffeeShop: Codable {

  var id: String = "default" // doc.id
  var reporterId: String = "default" // User.id

  var reportTime: Int64 = 0
  var newShopName: String = "default"
  var address: String = "default"
  var rating: Double = 0
  var openHours: String = "default"
  var limitedTime: String = "default"
  var socket: String = "default"
  var recommendItems: [String] = []
  var comment: String = "default"
  var notes: String = "default"
  var imgURL: [String] = []

  enum CodingKeys: String, CodingKey {

    case id
    case reporterId
    case reportTime
    case newShopName
    case address
    case rating
    case openHours
    case limitedTime
    case socket
    case recommendItems
    case comment
    case notes
    case imgURL
  }

  var toDict: [String: Any] {

    return [
      "id": id as Any,
      "reporterId": reporterId as Any,
      "reportTime": reportTime as Any,
      "newShopName": newShopName as Any,
      "address": address as Any,
      "rating": rating as Any,
      "openHours": openHours as Any,
      "limitedTime": limitedTime as Any,
      "socket": socket as Any,
      "recommendItems": recommendItems as Any,
      "comment": comment as Any,
      "notes": notes as Any,
      "imgs": imgURL as Any
    ]
  }
}
