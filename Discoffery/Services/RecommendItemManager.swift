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
    
    let docRef = database.collection("shops").document(shop.id).collection("recommendItems")
    
    docRef.getDocuments { querySnapshot, error in
      
      if let error = error {
        print("Error getting documents: \(error)")
        
      } else {
        guard let querySnapshot = querySnapshot else { return }

        var itemsArr: [RecommendItem] = []
        
        for document in querySnapshot.documents {
          
          do {
            if let item = try document.data(as: RecommendItem.self, decoder: Firestore.Decoder()) {
              itemsArr.append(item)
            }
          } catch {
            completion(.failure(error))
          }
        }
        completion(.success(itemsArr))
      }
    }
  }
  
  func publishUserRecommendItem(shop: CoffeeShop, item: inout RecommendItem, completion: @escaping (Result<String, Error>) -> Void) {
    
    let docRef = database.collection("shops").document(shop.id).collection("recommendItems").document()
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
    
    let docRef = database.collection("shops").document(shop.id).collection("recommendItems")
    let queryByItem = docRef.whereField("item", isEqualTo: item.item)
    
    queryByItem.getDocuments { querySnapshot, error in
      
      if let error = error {
        
        print("Error getting documents: \(error)")
        
        completion(.failure(error))
        
      } else {
        guard let querySnapshot = querySnapshot else { return }

        if querySnapshot.documents.isEmpty {
          
          completion(.failure(RecommendItemError.notExistError))
          
        } else {
          var didExistItem = RecommendItem()
          
          for document in querySnapshot.documents {
            
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
    
    let docRef = database.collection("shops").document(shop.id).collection("recommendItems").document(item.id)
    
    docRef.updateData([
      "count": FieldValue.increment(Int64(1))
    ]) { error in
      
      if let error = error {
        print("updateRecommendItemCount.error:\(error)")
        
      } else {
        print("updateRecommendItemCount.success")
      }
    }
  }
}
