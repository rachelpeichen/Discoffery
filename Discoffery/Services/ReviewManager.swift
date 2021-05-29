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

  func publishUserReview(shop: CoffeeShop, review: inout Review, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("reviews").document()

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

  func publishMockReviews(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    // MARK: Mock Reviews
    let mockUserName = ["Fuku","Rilakkuma","Piske","Usagi","Gaspard","Hamlet"]

    let mockRating = [3.6, 4.4, 3.6, 4.5, 3.3, 3.7, 2.3, 2.7, 4.0, 4.8, 3.0, 4.1, 2.1, 2.3, 5.0, 4.9, 4.8]

    let mockComment = ["是會一直想光顧的咖啡店。",
                       "很隱密的一家咖啡廳，環境很放鬆、很安靜，手沖咖啡很好喝，但品項很少，也沒有特色甜點，只適合辦公或K書。",
                       "整體氣氛還不錯，客人有些在辦公有些在喝咖啡聊天，不是非常安靜但也不致於被打擾，個人喜歡這樣的環境，讀書或滑個手機，一個人享受午後時光。","值得一訪再訪的店，收藏！",
                       "咖啡非常有水準，精緻細膩，香氣讓人無法忘懷。",
                       "甜點都很好吃、空間舒適、拿鐵咖啡豆偏酸很好喝～","拿鐵的咖啡跟牛奶之間的搭配非常協調，是台北難得的好拿鐵，讓人有記憶點","拿鐵溫度不會太高很適口，拉花簡單漂亮，奶和濃縮比例不錯。","手沖香氣夠，口感濃度適中順口。","店內環境放鬆舒適，靜謐的空間同時享受好喝的咖啡和甜點，咖啡滿好喝的，現做手沖，甜點也滿特別。","隱藏在巷弄間的質感小店，一人下午閒來無事可以來這裡窩一窩，喝杯咖啡，吃個甜點，愜意極了～","甜點/咖啡/服務都很棒！環境清新，適合文青聊天閱讀！","店內咖啡豆多數以淺焙為主，加上少數的中焙豆，味道以純淨帶點酸味為主，是市面少數以淺焙豆為主的手沖咖啡店。"]

    let mockItems0 = ["冷萃咖啡", "檸檬塔", "卡布奇諾", "單品手沖咖啡"]

    let mockItems1 = ["燕麥奶拿鐵", "可麗露", "馥列白", "海鹽焦糖拿鐵"]

    let date1 = Date.parse("2020-05-25")

    let date2 = Date.parse("2021-05-25")

    // Add a sub-collection named "reviews" to every documents in "shop" collection
    let docRef = database.collection("shopsTaipeiDemo").document(shop.id).collection("reviews").document()

    var review = Review()

    review.id = docRef.documentID
    
    review.parentId = shop.id

    review.userName = mockUserName.randomElement()!

    review.rating = mockRating.randomElement()!

    review.comment = mockComment.randomElement()!

    review.recommendItems = [mockItems0.randomElement()!, mockItems1.randomElement()!]

    review.postTime = Date.randomBetween(start: date1, end: date2).millisecondsSince1970

    docRef.setData(review.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Success"))
      }
    }

  }

}
