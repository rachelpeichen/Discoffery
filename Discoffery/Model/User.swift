//
//  User.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//
import Foundation

struct User: Codable {

  var id: String = "default"            // User.documentID (uid)

  var name: String = "default"

  var profileImg: String = "default" // Now only mock data

  var email: String = "default"

  var createdTime: Int64 = 0

  var blockList: [String] = []

  enum CodingKeys: String, CodingKey {

    case id

    case name

    case profileImg

    case email

    case createdTime

    case blockList
  }

  var toDict: [String: Any] {

    return [

      "id": id as Any,

      "name": name as Any,

      "profileImg": profileImg as Any,

      "email": email as Any,

      "createdTime": createdTime as Any,

      "blockList": blockList as Any
    ]
  }
}
