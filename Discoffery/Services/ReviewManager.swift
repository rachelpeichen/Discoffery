//
//  ReviewManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ReviewManager {

  // MARK: - Properties
  static let shared = ReviewManager()

  lazy var database = Firestore.firestore()

  // MARK: - Functions
  func fetchReviewsForShop(shop: CoffeeShop, completion: @escaping (Result<[Review], Error>) -> Void) {

    let docRef = Firestore.firestore().collection("shopsTaichung").document(shop.id).collection("reviews")

    docRef.getDocuments() { querySnapshot, error in

      if let error = error {

        print("Error getting documents: \(error)")

      } else {

        var reviews = [Review]()

        for document in querySnapshot!.documents {

          do {
            if let review = try document.data(as: Review.self, decoder: Firestore.Decoder()) {

              reviews.append(review)
            }

          } catch {

            completion(.failure(error))
          }
        }

        print(reviews.count)
        completion(.success(reviews))
      }
    }

  }

  func publishUserReview(shop: CoffeeShop, review: inout Review, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("shopsTaichung").document(shop.id).collection("reviews").document()

    review.id = docRef.documentID

    review.parentId = shop.id

    review.postTime = Date().millisecondsSince1970

    docRef.setData(review.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Success"))
      }
    }

  }

  func publishNewShopReview(shopId: String, review: inout Review, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("newShopsDemo").document(shopId).collection("reviews").document()

    review.id = docRef.documentID

    review.parentId = shopId

    review.postTime = Date().millisecondsSince1970

    docRef.setData(review.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Success"))
      }
    }

  }

}
