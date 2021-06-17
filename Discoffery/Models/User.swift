//
//  User.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//
import Foundation

struct User: Codable {

  // User.documentID
  var id: String = "default"

  var name: String = "default"
  var profileImg: String = "default"
  var email: String = "default"
  var blockList: [String] = []

  var createdTime: Int64 = 0

  enum CodingKeys: String, CodingKey {

    case id
    case name
    case profileImg
    case email
    case blockList
    case createdTime
  }

  var toDict: [String: Any] {

    return [
      "id": id as Any,
      "name": name as Any,
      "profileImg": profileImg as Any,
      "email": email as Any,
      "blockList": blockList as Any,
      "createdTime": createdTime as Any
    ]
  }
}
