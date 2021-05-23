//
//  RecommendItems.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation

struct RecommendItems: Codable {

  var id: String // RecommendItems.documentID
  var item1: String
  var item2: String
  var item3: String
  var countForItem1: Int
  var countForItem2: Int
  var countForItem3: Int

  enum CodingKeys: String, CodingKey {
    case id
    case item1
    case item2
    case item3
    case countForItem1
    case countForItem2
    case countForItem3
  }

  var toDict: [String: Any] {
    return [
      "id": id as Any,
      "item1": item1 as Any,
      "item2": item2 as Any,
      "item3": item3 as Any,
      "totalCountsForItem1": countForItem1 as Any,
      "totalCountsForItem2": countForItem2 as Any,
      "totalCountsForItem3": countForItem3 as Any
    ]
  }
}
