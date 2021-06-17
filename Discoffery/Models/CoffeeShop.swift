//
//  CoffeeShop.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import Foundation

struct CoffeeShop: Codable {

  var id: String   = "default"
  var name: String = "default"
  var city: String = "default"
  var url: String = "default"
  var address: String = "default"
  var limitedTime: String = "default"
  var socket: String = "default"
  var standingDesk: String = "default"
  var mrt: String = "default"
  var openTime: String = "default"

  var wifi: Double = 0
  var seat: Double = 0
  var quiet: Double = 0
  var tasty: Double = 0
  var cheap: Double = 0
  var music: Double = 0
  var latitude: Double = 0
  var longitude: Double = 0

  enum CodingKeys: String, CodingKey {
    
    case id
    case name
    case city
    case url
    case address
    case limitedTime = "limited_time"
    case socket
    case standingDesk = "standing_desk"
    case mrt
    case openTime = "open_time"
    case wifi
    case seat
    case quiet
    case tasty
    case cheap
    case music
    case latitude
    case longitude
  }

  var toDict: [String: Any] {

    return [
      "id": id as Any,
      "name": name as Any,
      "city": city as Any,
      "url": url as Any,
      "address": address as Any,
      "latitude": Double(latitude) as Any,
      "longitude": Double(longitude) as Any,
      "limited_time": limitedTime as Any,
      "socket": socket as Any,
      "standing_desk": standingDesk as Any,
      "mrt": mrt as Any,
      "open_time": openTime as Any,
      "wifi": wifi as Any,
      "seat": seat as Any,
      "quiet": quiet as Any,
      "tasty": tasty as Any,
      "cheap": cheap as Any,
      "music": music as Any
    ]
  }
}
