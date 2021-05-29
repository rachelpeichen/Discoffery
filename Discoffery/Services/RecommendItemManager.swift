//
//  RecommendItemManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/26.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum RecommendItemError: Error {

  case notExistError
}

class RecommendItemManager {

  // MARK: - Properties
  static let shared = RecommendItemManager()

  lazy var database = Firestore.firestore()

  // MARK: - Functions
  func fetchRecommendItemForShop(shop: CoffeeShop, completion: @escaping (Result<[RecommendItem], Error>) -> Void) {

    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("recommendItems")

    docRef.getDocuments() { querySnapshot, error in

      if let error = error {

        print("Error getting documents: \(error)")

      } else {

       //var itemsForShopDic: [String: [RecommendItem]] = [:]

        var items: [RecommendItem] = []

        for document in querySnapshot!.documents {

          do {
            if let item = try document.data(as: RecommendItem.self, decoder: Firestore.Decoder()) {

              items.append(item)
            }

            // itemsForShopDic[shop.id] = items

          } catch {

            completion(.failure(error))
          }
        }

        completion(.success(items))
      }
    }

  }

  func publishNewShopRecommendItem(shopId: String, item: inout RecommendItem, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("newShopsDemo").document(shopId).collection("recommendItems").document()

    item.id = docRef.documentID

    item.parentId = shopId

    item.count = 1

    docRef.setData(item.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Success"))
      }
    }

  }

  func publishMockRecommendItem(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    // MARK: Mock RecommendItem
    let mockItems1 = ["冷萃咖啡", "檸檬塔", "卡布奇諾", "單品手沖咖啡", "燕麥奶拿鐵", "可麗露", "馥列白", "海鹽焦糖拿鐵"]

    let mockItems2 = ["完美日曬耶加雪菲", "莊園級拿鐵", "榛果風味拿鐵", "小農鮮奶咖啡", "白蘭地生巧克力蛋糕", "法式布蕾", "抹茶巴斯克乳酪", "提拉米蘇"]

    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("recommendItems").document()

    var recommendItem = RecommendItem()

    recommendItem.id = docRef.documentID

    recommendItem.parentId = shop.id

    recommendItem.count = 1

    recommendItem.item = mockItems2.randomElement()!

    docRef.setData(recommendItem.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Success"))
      }
    }
  }

  func publishUserRecommendItem(shop: CoffeeShop, item: inout RecommendItem, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("recommendItems").document()

    item.id = docRef.documentID

    item.parentId = shop.id

    item.count = 1

    docRef.setData(item.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Success"))
      }
    }

  }

  func checkIfRecommendItemExist(shop: CoffeeShop, item: RecommendItem, completion: @escaping (Result<RecommendItem, Error>) -> Void) {

    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("recommendItems")

    let queryByItem = docRef.whereField("item", isEqualTo: item.item)

    queryByItem.getDocuments() { querySnapshot, error in

      if let error = error {

        print("Error getting documents: \(error)")

        completion(.failure(error))

      } else {

        if querySnapshot!.documents.isEmpty {

          completion(.failure(RecommendItemError.notExistError))

        } else {

          var didExistItem = RecommendItem()

          for document in querySnapshot!.documents {

            do {
              if let item = try document.data(as: RecommendItem.self, decoder: Firestore.Decoder()) {

                didExistItem = item
              }

            } catch {

              completion(.failure(error))
            }
          }

          completion(.success(didExistItem))
        }
      }
    }

  }

  func updateRecommendItemCount(shop: CoffeeShop, item: RecommendItem) {

    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("recommendItems").document(item.id)

    docRef.updateData([

      "count": FieldValue.increment(Int64(1)),

      // "lastUpdated": FieldValue.serverTimestamp()
    ]) { error in

      if let error = error {

        print("Error updating document: \(error)")

      } else {

        print("Document successfully updated")
      }
    }
  }

}
