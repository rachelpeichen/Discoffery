//
//  FeatureManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FeatureManager {

  // MARK: - Properties
  static let shared = FeatureManager()

  lazy var database = Firestore.firestore()

  // MARK: - Functions
  func fetchFeatureForShop(shop: CoffeeShop, completion: @escaping (Result<[Feature], Error>) -> Void) {

    let docRef = Firestore.firestore().collection("shopsTaipeiDemo").document(shop.id).collection("features")

    docRef.getDocuments() { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {

        var feature:[Feature] = []

        for document in querySnapshot!.documents {

          do {
            if let getFeature = try document.data(as: Feature.self, decoder: Firestore.Decoder()) {

              feature.append(getFeature)
            }

          } catch {
            completion(.failure(error))
          }
        }

        completion(.success(feature))
      }
    }
  }

  func publishNewShopFeature(shopId: String, feature: inout Feature, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("newShopsDemo").document(shopId).collection("features").document()

    feature.id = docRef.documentID

    feature.parentId = shopId

    docRef.setData(feature.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Success"))
      }
    }
  }

  func publishMockFeature(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    // Mock data
    let mockSocket = ["無插座", "有插座", "每個座位都有插座"]

    let mockTimeLimit = ["不限時", "有限時", "視營業情況限時"]

    let mockSpecials0 = ["文青風格","店貓很可愛","環境舒適悠閒","提供外帶","提供外送","冠軍拉花"]

    let mockSpecials1 = ["販售咖啡豆","手沖咖啡教學","店員親切","可集點累積換飲品","北歐風裝潢","老屋咖啡廳"]

    let mockBool = [true, false]

    // Add a sub-collection named "features" to every documents in "shopsTaipeiDemo" collection
    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("features").document()

    var feature = Feature()

    feature.id = docRef.documentID

    feature.parentId = shop.id

    feature.socket = mockSocket.randomElement()!

    feature.timeLimit = mockTimeLimit.randomElement()!

    feature.special = [mockSpecials0.randomElement()!, mockSpecials1.randomElement()!]

    feature.wifi = mockBool.randomElement()!

    feature.petFriendly = mockBool.randomElement()!

    feature.outdoorSeats = mockBool.randomElement()!

    docRef.setData(feature.toDict) { error in

      if let error = error {
        completion(.failure(error))

      } else {
        completion(.success("Success"))
      }
    }
  }

}
