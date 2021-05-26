//
//  RecommendItem.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/26.
//

import Foundation

struct RecommendItem: Codable {

  var id: String = "default"            // RecommendItem.documentID

  var parentId: String = "default"      // CoffeeShop.documentID

  var item: String = "default"

  var count: Double = 1

  enum CodingKeys: String, CodingKey {

    case id

    case parentId

    case item

    case count
  }

  var toDict: [String: Any] {

    return [

      "id": id as Any,

      "parentId": parentId as Any,

      "item": item as Any,

      "count": count as Any

    ]
  }

}
