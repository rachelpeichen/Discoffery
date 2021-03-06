//
//  FeatureManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FeatureManager {

  // MARK: - Properties
  static let shared = FeatureManager()

  lazy var database = Firestore.firestore()

  // MARK: - Functions
  func fetchFeatureForShop(shop: CoffeeShop, completion: @escaping (Result<[Feature], Error>) -> Void) {

    let docRef = database.collection("shops").document(shop.id).collection("features")

    docRef.getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {
        guard let querySnapshot = querySnapshot else { return }

        var featureArr: [Feature] = []

        for document in querySnapshot.documents {

          do {
            if let getFeature = try document.data(as: Feature.self, decoder: Firestore.Decoder()) {
              featureArr.append(getFeature)
            }
          } catch {
            completion(.failure(error))
          }
        }
        completion(.success(featureArr))
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
}
