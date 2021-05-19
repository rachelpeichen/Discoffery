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

  // MARK: - Properties
  static let shared = CoffeeShopManager()

  lazy var database = Firestore.firestore()

  // MARK: - Functions
  func publishShop(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    //  Add a new collection to Firebase
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

  func fetchShopCoordinates(completion: @escaping (Result<[CoffeeShop], Error>) -> Void) {

    //  得到用戶的經緯度資料後抓一個區間去查詢
    database.collection("coffeeShopsForDemo").whereField("latitude", isNotEqualTo: "").getDocuments { querySnapshot, error in

      if let error = error {

        completion(.failure(error))

      } else {

        var shopsData = [CoffeeShop]()

        for document in querySnapshot!.documents {

          do {

            if let shopDocument = try document.data(as: CoffeeShop.self, decoder: Firestore.Decoder()) {

              shopsData.append(shopDocument)
            }
          } catch {

            completion(.failure(error))
          }
        }

        completion(.success(shopsData))
      }
    }
  }

}
