//
//  CoffeeShopManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/14.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation
import GeoFire

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
    let docRef = database.collection("shopsTaipei").document()
    
    shop.id = docRef.documentID

    docRef.setData(shop.toDict) { error in

      if let error = error {
        completion(.failure(error))
        
      } else {
        completion(.success("Success"))
      }
    }
  }

  func fetchShopWithinLatitude(latitude: Double, distance: Double, completion: @escaping (Result<[CoffeeShop], Error>) -> Void) {

    // Find all shops within input meter of user's current location

    // The number of meters per degree of latidue (roughly) 換算 1 degrees 的緯度 ~ 111194 m
    let metersPerLatDegree = (Double.pi / 180) * 6371000

    let lowerLat = latitude - (distance / metersPerLatDegree) // 緯度下限
    let upperLat = latitude + (distance / metersPerLatDegree) // 緯度上限

    let docRef = Firestore.firestore().collection("shops")

    // 先查緯度: Firebase range filters can be implemented on only one field
    let queryByLat = docRef
      .whereField("latitude", isGreaterThan: lowerLat)
      .whereField("latitude", isLessThan: upperLat)

    queryByLat.getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {

        var shopsFilterd = [CoffeeShop]()

        for document in querySnapshot!.documents {

          do {
            if let shopFilterd = try document.data(as: CoffeeShop.self, decoder: Firestore.Decoder()) {
              shopsFilterd.append(shopFilterd)
            }

          } catch {
            completion(.failure(error))
          }
        }

        completion(.success(shopsFilterd))
      }
    }
  }
}

//func updateShopGeoPoint(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {
//
//  // Update location from original String to GeoPoint -> 現在暫時用不到了因為GeoPoint不能查經度
//  let location = GeoPoint(latitude: shop.latitude, longitude: shop.longitude)
//
//  let updateField: [String: Any] = ["location": location]
//
//  let updatedDocRef = database.collection("shops").document(shop.id)
//
//  updatedDocRef.updateData(updateField) { error in
//
//    if let error = error {
//      completion(.failure(error))
//
//    } else {
//      completion(.success("success"))
//    }
//  }
//}
