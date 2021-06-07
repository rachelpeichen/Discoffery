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

enum FirebaseError: Error {

  case notExistError
}

class CoffeeShopManager {

  // MARK: - Properties
  static let shared = CoffeeShopManager()

  lazy var database = Firestore.firestore()

  // MARK: - Functions
  func publishNewShop(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    //  Add a new collection to Firebase
    let docRef = database.collection("newShopsDemo").document()

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

    let docRef = database.collection("shopsTaichung")

    // 先查緯度: Firebase range filters can be implemented on only one field
    let queryByLat = docRef
      .whereField("latitude", isGreaterThan: lowerLat)
      .whereField("latitude", isLessThan: upperLat)

    queryByLat.getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {

        var shopsFilterd: [CoffeeShop] = []

        for document in querySnapshot!.documents {

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


  func fetchShopSelectedOnMap(name: String, completion: @escaping (Result<CoffeeShop, Error>) -> Void) {

    let docRef = database.collection("shopsTaichung")

    docRef.whereField("name", isEqualTo: name).getDocuments() { querySnapshot, error in

      if let error = error {

        print("Error getting documents: \(error)")

      } else {

        if querySnapshot!.documents.isEmpty {

          completion(.failure(FirebaseError.notExistError))

        } else {

          var selectedShop = CoffeeShop()

          for document in querySnapshot!.documents {

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

  func fetchNewShops(name: String, completion: @escaping (Result<CoffeeShop, Error>) -> Void) {
  
    let docRef = database.collection("newShopsDemo")

    docRef.whereField("name", isEqualTo: name).getDocuments() { querySnapshot, error in

      if let error = error {

        print("Error getting documents: \(error)")

      } else {

        if querySnapshot!.documents.isEmpty {

          completion(.failure(FirebaseError.notExistError))

        } else {

          var newShop = CoffeeShop()

          for document in querySnapshot!.documents {

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

  func fetchKnownShopByDocId(docId: [String], completion: @escaping (Result<[CoffeeShop], Error>) -> Void) {

    let docRef = database.collection("shopsTaichung")

    let query = docRef.whereField("id", in: docId)

    query.getDocuments { querySnapshot, error in

      if let error = error {

        print("Error getting documents: \(error)")

      } else {

        var knownShop: [CoffeeShop] = []

        for document in querySnapshot!.documents {

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

    let docRef = database.collection("shopsTaichung")

    let query = docRef.whereField("socket", isEqualTo: "maybe")

    query.getDocuments { querySnapshot, error in

      if let error = error {

        print("Error getting documents: \(error)")

      } else {

        var fetchShops: [CoffeeShop] = []

        for document in querySnapshot!.documents {

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
