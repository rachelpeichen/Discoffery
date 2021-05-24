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

    let docRef = Firestore.firestore().collection("shopsTaipeiDemo").document(shop.id).collection("reviews")

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




  func publishMockReviews(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    // Mock data
    let mockUserName = ["Fuku", "Rilakkuma", "Piske", "Usagi", "Gaspard", "Hamlet"]
    let mockRating = [4.6, 4.4, 3.6, 4.5, 3.3, 3.7, 2.3, 2.7, 4.0, 4.8, 3.0, 4.1, 2.1, 2.3]
    let mockComment = ["是會一直想光顧的咖啡店。",
                       "很隱密的一家日式咖啡廳，環境很放鬆、很安靜，手沖咖啡很好喝，但品項很少，也沒有特色甜點，只適合辦公或K書。",
                       "整體氣氛還不錯，客人有些在辦公有些在喝咖啡聊天，不是非常安靜但也不致於被打擾，個人喜歡這樣的環境，讀書或滑個手機，一個人享受午後時光。","值得一訪再訪的店，收藏！",
                       "咖啡好喝！價格很平實，但是食物的品質很高！","衣索比亞西達摩單一品種 $230，酸度適中，尾韻烘焙味較明顯。手沖咖啡選擇多，用餐環境舒適，適合在這讀書或放鬆。"]
    let mockItems = ["燕麥奶那堤", "可麗露", "馥列白", "冷萃咖啡", "檸檬塔", "卡布奇諾"]
    let mockTime = ["2020/10/07", "2020/06/10", "2021/04/29", "2021/01/18", "2020/06/12", "2021/04/13", "2021/02/14"]

    // Add a sub-collection named "reviews" to every documents in "shop" collection
    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("reviews").document()

    var review = Review()

    review.id = docRef.documentID
    review.parentId = shop.id

    review.userName = mockUserName.randomElement()!
    review.rating = mockRating.randomElement()!
    review.comment = mockComment.randomElement()!
    review.recommendItems = [mockItems.randomElement()!, mockItems.randomElement()!]
    review.postTime = mockTime.randomElement()!

    docRef.setData(review.toDict) { error in

      if let error = error {
        completion(.failure(error))

      } else {
        completion(.success("Success"))
      }
    }
  }
}
