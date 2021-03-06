//
//  ReviewManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class ReviewManager {

  // MARK: - Properties
  static let shared = ReviewManager()

  lazy var database = Firestore.firestore()

  lazy var storage = Storage.storage()

  // MARK: - Functions
  func fetchReviewsForShop(shop: CoffeeShop, completion: @escaping (Result<[Review], Error>) -> Void) {

    let docRef = database.collection("shops").document(shop.id).collection("reviews")

    docRef.getDocuments { querySnapshot, error in

      if let error = error {
        print("Error getting documents: \(error)")

      } else {
        guard let querySnapshot = querySnapshot else { return }

        var reviewsArr: [Review] = []

        for document in querySnapshot.documents {

          do {
            if let review = try document.data(as: Review.self, decoder: Firestore.Decoder()) {
              reviewsArr.append(review)
            }
          } catch {
            completion(.failure(error))
          }
        }
        completion(.success(reviewsArr))
      }
    }
  }

  func publishUserReview(shop: CoffeeShop, review: inout Review, uploadedImgUrlArr: [String], completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("shops").document(shop.id).collection("reviews").document()
    review.id = docRef.documentID
    review.user = UserManager.shared.user.id
    review.userName = UserManager.shared.user.name
    review.parentId = shop.id
    review.postTime = Date().millisecondsSince1970
    review.imgURL = uploadedImgUrlArr

    docRef.setData(review.toDict) { error in

      if let error = error {
        completion(.failure(error))

      } else {
        completion(.success("Success"))
      }
    }
  }
}
