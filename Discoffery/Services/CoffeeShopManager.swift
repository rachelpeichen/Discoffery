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

enum OtherError: Error {
  case youKnowNothingError(String)
}

class CoffeeShopManager {

  static let shared = CoffeeShopManager()

  lazy var database = Firestore.firestore()

  // MARK: Add a new collection to Firebase
  func publishShop(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    let document = database.collection("coffeeShopsForDemo").document()

    shop.id = document.documentID

    document.setData(shop.toDict) { error in

      if let error = error {

        completion(.failure(error))
      } else {

        completion(.success("Success"))
      }
    }
  }

  // MARK: Search coffee shops within speicific range by user's current location
  func fetchShopByLocation() {
  }
}
