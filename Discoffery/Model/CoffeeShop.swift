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
  var city: String
  var wifi: Double
  var seat: Double
  var quiet: Double
  var tasty: Double
  var cheap: Double
  var music: Double
  var url: String
  var address: String
  var limitedTime: String
  var socket: String
  var standingDesk: String
  var mrt: String
  var openTime: String

  // Call API: String; Decode from Firebase: Double
  var latitude: Double
  var longitude: Double

  // Call API: No these variables! Only decoding from Firebase need these!

  enum CodingKeys: String, CodingKey {

    case id
    case name
    case city
    case wifi
    case seat
    case quiet
    case tasty
    case cheap
    case music
    case url
    case address
    case limitedTime = "limited_time"
    case socket
    case standingDesk = "standing_desk"
    case mrt
    case openTime = "open_time"

    case latitude
    case longitude

  }

  var toDict: [String: Any] {
    return [
    "id": id as Any,
    "name": name as Any,
    "city": city as Any,
    "wifi": wifi as Any,
    "seat": seat as Any,
    "quiet": quiet as Any,
    "tasty": tasty as Any,
    "cheap": cheap as Any,
    "music": music as Any,
    "url": url as Any,
    "address": address as Any,
    "latitude": Double(latitude) as Any,
    "longitude": Double(longitude) as Any,
    "limited_time": limitedTime as Any,
    "socket": socket as Any,
    "standing_desk": standingDesk as Any,
    "mrt": mrt as Any,
    "open_time": openTime as Any
    ]
  }
}
