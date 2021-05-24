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

  func publishFeature(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    // Mock data
    let mockSocket = ["無插座", "有插座", "每個座位都有插座"]
    let mockTimeLimit = ["不限時", "有限時", "視營業情況限時"]
    let mockAtmosphere = ["很chill", "文青風格", "店貓很可愛", "安靜悠閒"]
    let mockBool = [true, false]

    // Add a sub-collection named "features" to every documents in "shop" collection
    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("features").document()

    var feature = Feature()

    feature.id = docRef.documentID
    feature.parentId = shop.id

    feature.socket = mockSocket.randomElement()!
    feature.timeLimit = mockTimeLimit.randomElement()!
    feature.atmosphere = mockAtmosphere.randomElement()!
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
