//
//  CoffeeShop.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import Foundation

struct CoffeeShop: Codable {

  var id: String
  var name: String
// 
  var wifi: Double
  var seat: Double
  var quiet: Double
  var tasty: Double
  var cheap: Double
  var music: Double
  var url: String
  var address: String
  var latitude: String
  var longitude: String
//  var limitedTime: LimitedTime
//  //var socket: LimitedTime
//  var standingDesk: LimitedTime
  var mrt: String
  var openTime: String

  enum CodingKeys: String, CodingKey {
    case id = "id"
    case name = "name"
//    case city = "city"
    case wifi = "wifi"
    case seat = "seat"
    case quiet = "quiet"
    case tasty = "tasty"
    case cheap = "cheap"
    case music = "music"
    case url = "url"
    case address = "address"
    case latitude = "latitude"
    case longitude = "longitude"
//    case limitedTime = "limited_time"
//    case socket = "socket"
//    case standingDesk = "standing_desk"
    case mrt = "mrt"
    case openTime = "open_time"
  }

  var toDict: [String: Any] {
    return [
    "id": id as Any,
    "name": name as Any,
//    "city": city as Any,
    "wifi": wifi as Any,
    "seat": seat as Any,
    "quiet": quiet as Any,
    "tasty": tasty as Any,
    "cheap": cheap as Any,
    "music": music as Any,
    "url": url as Any,
    "address": address as Any,
    "latitude": latitude as Any,
    "longitude": longitude as Any,
//    "limited_time": limitedTime as Any,
//    "socket": socket as Any,
//    "standing_desk": standingDesk as Any,
    "mrt": mrt as Any,
    "open_time": openTime as Any
    ]
  }
}
//
//enum City: String, Codable {
//  case taipei
//}

//enum LimitedTime: String, Codable {
//  // swiftlint:disable identifier_name
//  case empty = ""
//  case maybe = "maybe"
//  case no
//  case yes = "yes"
//}
