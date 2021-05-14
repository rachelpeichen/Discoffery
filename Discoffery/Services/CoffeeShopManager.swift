//
//  CoffeeShopManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/14.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum FirebaseError: Error {
    case documentError
}

enum MasterError: Error {
    case youKnowNothingError(String)
}

class CoffeeShopManager {

  static let shared = CoffeeShopManager()

  lazy var db = Firestore.firestore()

  func fetchShops(){}

  func publishShop(){}

  func deleteShop(){}
}
