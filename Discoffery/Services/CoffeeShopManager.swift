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

    let docRef = Firestore.firestore().collection("shopsTaichung")

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


  func fetchShopSelectedOnMap(name: String, completion: @escaping (Result<CoffeeShop, Error>) -> Void){

    let docRef = Firestore.firestore().collection("shopsTaichung")

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

  func fetchNewShops(name: String, completion: @escaping (Result<CoffeeShop, Error>) -> Void){
    // 把shopsTaipei 這個collection裡面所有的文件抓下來後暫存 再寫入reviews這個sub-collection

    let docRef = Firestore.firestore().collection("newShopsDemo")

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

}

