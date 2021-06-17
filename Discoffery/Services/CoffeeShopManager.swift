//
//  CoffeeShopManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/14.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseFirestoreSwift

enum FirebaseError: Error {
  case notExistError
}

class CoffeeShopManager {

  // MARK: - Properties
  static let shared = CoffeeShopManager()

  lazy var database = Firestore.firestore()

  // MARK: - New Shop Related Functions
  func publishNewShop(newShop: inout NewCoffeeShop, uploadedImgURL: [String], completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("newShopsDemo").document()
    newShop.id = docRef.documentID
    newShop.reporterId = UserManager.shared.user.id
    newShop.reportTime = Date().millisecondsSince1970
    newShop.imgURL = uploadedImgURL

    docRef.setData(newShop.toDict) { error in

      if let error = error {
        completion(.failure(error))

      } else {
        completion(.success("Success"))
      }
    }
  }

  func fetchNewShops(name: String, completion: @escaping (Result<CoffeeShop, Error>) -> Void) {

    let docRef = database.collection("newShopsDemo")
    docRef.whereField("name", isEqualTo: name).getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {
        guard let querySnapshot = querySnapshot else { return }

        if querySnapshot.documents.isEmpty {
          completion(.failure(FirebaseError.notExistError))

        } else {
          var newShop = CoffeeShop()

          for document in querySnapshot.documents {
            do {
              if let shop = try document.data(as: CoffeeShop.self, decoder: Firestore.Decoder()) {
                newShop = shop
              }
            } catch {
              completion(.failure(error))
            }
          }
          completion(.success(newShop))
        }
      }
    }
  }

  // MARK: - Geo Distance Related Functions
  func fetchShopWithinLatitude(latitude: Double, distance: Double, completion: @escaping (Result<[CoffeeShop], Error>) -> Void) {
    // Find all shops within input meter around user's current location

    // The number of meters per degree of latidue (roughly)
    let metersPerLatDegree = (Double.pi / 180) * 6371000
    let lowerLat = latitude - (distance / metersPerLatDegree)
    let upperLat = latitude + (distance / metersPerLatDegree)

    let docRef = database.collection("shops")
    // Query latitude first because of the limit of Firebase's Geopoint query range
    let queryByLat = docRef
      .whereField("latitude", isGreaterThan: lowerLat)
      .whereField("latitude", isLessThan: upperLat)

    queryByLat.getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {
        guard let querySnapshot = querySnapshot else { return }

        var shopsFilterd: [CoffeeShop] = []

        for document in querySnapshot.documents {
          do {
            if let shop = try document.data(as: CoffeeShop.self, decoder: Firestore.Decoder()) {
              shopsFilterd.append(shop)
            }
          } catch {
            completion(.failure(error))
          }
        }
        completion(.success(shopsFilterd))
      }
    }
  }

  // MARK: - Fetching Existing Shops Related Functions
  func fetchShopSelectedOnMap(name: String, completion: @escaping (Result<CoffeeShop, Error>) -> Void) {

    let docRef = database.collection("shops")

    docRef.whereField("name", isEqualTo: name).getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {
        guard let querySnapshot = querySnapshot else { return }

        if querySnapshot.documents.isEmpty {
          completion(.failure(FirebaseError.notExistError))

        } else {
          var selectedShop = CoffeeShop()

          for document in querySnapshot.documents {
            do {
              if let shop = try document.data(as: CoffeeShop.self, decoder: Firestore.Decoder()) {
                selectedShop = shop
              }
            } catch {
              completion(.failure(error))
            }
          }
          completion(.success(selectedShop))
        }
      }
    }
  }

  func fetchKnownShopByDocId(docId: [String], completion: @escaping (Result<[CoffeeShop], Error>) -> Void) {

    let query = database.collection("shops").whereField("id", in: docId)

    query.getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {
        guard let querySnapshot = querySnapshot else { return }

        var knownShop: [CoffeeShop] = []

        for document in querySnapshot.documents {

          do {
            if let shop = try document.data(as: CoffeeShop.self, decoder: Firestore.Decoder()) {
              knownShop.append(shop)
            }
          } catch {
            completion(.failure(error))
          }
        }
        completion(.success(knownShop))
      }
    }
  }

  func fetchShopByRecommendItem(completion: @escaping (Result<[CoffeeShop], Error>) -> Void) {

    let query = database.collection("shops").whereField("socket", isEqualTo: "maybe")

    query.getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {
        guard let querySnapshot = querySnapshot else { return }

        var fetchShops: [CoffeeShop] = []

        for document in querySnapshot.documents {

          do {
            if let shop = try document.data(as: CoffeeShop.self, decoder: Firestore.Decoder()) {
              fetchShops.append(shop)
            }
          } catch {
            completion(.failure(error))
          }
        }
        completion(.success(fetchShops))
      }
    }
  }
}
