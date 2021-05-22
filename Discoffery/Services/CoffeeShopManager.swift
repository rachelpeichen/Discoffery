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
      .order(by: "latitude")

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

  func calDistanceBetweenTwoLocations(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> Double {

    // Use Haversine Formula to calculate the distance in meter between two locations
    // φ is latitude, λ is longitude, R is earth’s radius (mean radius = 6,371km)
    let lat1 = location1.latitude
    let lat2 = location2.latitude

    let lon1 = location1.longitude
    let lon2 = location2.longitude

    let earthRadius = 6371000.0

    let φ1 = lat1 * Double.pi / 180 // φ, λ in radians
    let φ2 = lat2 * Double.pi / 180

    let Δφ = (lat2 - lat1) * Double.pi / 180
    let Δλ = (lon2 - lon1) * Double.pi / 180

    let parA = sin(Δφ/2) * sin(Δφ/2) + cos(φ1) * cos(φ2) * sin(Δλ/2) * sin(Δλ/2)
    let parC = 2 * atan2(sqrt(parA), sqrt(1-parA))

    let distance = earthRadius * parC

    return distance
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
