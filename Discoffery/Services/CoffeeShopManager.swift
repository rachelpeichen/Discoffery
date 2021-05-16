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

  func publishShop(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

      let document = database.collection("coffeeShops").document()

      shop.id = document.documentID

      document.setData(shop.toDict) { error in

          if let error = error {

              completion(.failure(error))
          } else {

              completion(.success("Success"))
          }
      }
    print("✌🏻Finished publishing to Firebase!✌🏻")
  }

  func deleteShop(){}

  func fetchShops(){}
}
