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
    let document = database.collection("coffeeShopsForGeo").document()

    shop.id = document.documentID

    document.setData(shop.toDict) { error in

      if let error = error {

        completion(.failure(error))
      } else {

        completion(.success("Success"))
      }
    }
  }

  func updateShopGeo(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    // Compute the GeoHash for a lat/lng point
    let lat = CLLocationDegrees(shop.latitude)

    let lng = CLLocationDegrees(shop.longitude)

    let location = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)

    let hash = GFUtils.geoHash(forLocation: location)


    let updateDoc: [String: Any] = ["geohash": hash ]

    let updatedDocument = database.collection("coffeeShopsForGeo").document(shop.id)

    updatedDocument.updateData(updateDoc) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("success"))
      }
    }
  }

  func fetchShopByCoordinateRange(completion: @escaping (Result<[CoffeeShop], Error>) -> Void) {
    //  得到用戶的經緯度資料後抓區間去查詢

    let ref = database.collection("queryByLatitude")

    ref
      //      .whereField("latitude", isGreaterThanOrEqualTo: 25.019815750976562)
      //
      //      .whereField("latitude", isLessThanOrEqualTo: 25.028798750976563)

      .whereField("longitude", isGreaterThanOrEqualTo: 121.5245246038531)

      .whereField("longitude", isLessThanOrEqualTo: 121.53443820977101)

      .getDocuments { querySnapshot, error in

        if let error = error {

          completion(.failure(error))

        } else {

          var shopsData = [CoffeeShop]()

          for document in querySnapshot!.documents {

            do {

              if let shopDocument = try document.data(as: CoffeeShop.self, decoder: Firestore.Decoder()) {

                shopsData.append(shopDocument)

                //                // MARK: 測試先複製一份送上去第一個查詢條件
                //                let duplicateDoc = self.database.collection("queryByLatitude").document()
                //
                //                duplicateDoc.setData(shopDocument.toDict)

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
