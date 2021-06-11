//
//  UserManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/4.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum UserError: Error {

  case notExistError
}

class UserManager {
  
  // MARK: - Properties
  static let shared = UserManager()

  var user = User()

  lazy var database = Firestore.firestore()

  // MARK: - User login and create on Firebase
  func identifyUser(firebaseUID: String, completion: @escaping (Result<User, Error>) -> Void) {

    database.collection("users").document(firebaseUID).getDocument { querySnapshot, error in

      if let error = error {

        completion(.failure(error))

      } else if querySnapshot?.data() == nil {

        completion(.failure(UserError.notExistError))

      } else {

        do {

          if let user = try querySnapshot?.data(as: User.self, decoder: Firestore.Decoder()) {

            completion(.success(user))
          }

        } catch {
          completion(.failure(error))
        }
      }
    }
  }

  func createUser(createdUser: inout User, completion: @escaping (Result<String, Error>) -> Void) {

    let doc = database.collection("users").document(createdUser.id) 

    createdUser.createdTime = Date().millisecondsSince1970

    doc.setData(createdUser.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Create User Success"))
      }
    }
  }

  // MARK: Listen to user change on Firebase
  func watchUser(completion: @escaping (Result<User, Error>) -> Void) {

    let docRef = database.collection("users").document(UserManager.shared.user.id)

    docRef.addSnapshotListener { querySnapshot, error in

      if let error = error {

        completion(.failure(error))

      } else {

        let user = try? querySnapshot?.data(as: User.self)

        if let user = user {

          completion(.success(user))
        }
      }
    }
  }

  // MARK: User's Collection
  func createUserSavedShopsDefaultCategory(user: User, savedShop: inout UserSavedShops, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id).collection("savedShops").document("defaultCategory")

    savedShop.id = docRef.documentID

    savedShop.category = "全部收藏"

    savedShop.createdTime = Date().millisecondsSince1970

    docRef.setData(savedShop.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Create User SavedShopsDefaultCategory Success"))
      }
    }
  }

  func addUserSavedShopToDefaultCategory (user: User, shop: CoffeeShop, savedShop: inout UserSavedShops, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id).collection("savedShops").document("defaultCategory")

    savedShop.id = docRef.documentID

    docRef.updateData([
                        "savedShopsByCategory": FieldValue.arrayUnion([shop.id])
    ]) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Success"))
      }
    }
  }

  func fetchUserSavedShopForDefaultCategory(user: User, completion: @escaping (Result<UserSavedShops, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id).collection("savedShops").document("defaultCategory")

    docRef.getDocument() { document, error in

      let result = Result {

        try document?.data(as: UserSavedShops.self)
      }

      switch result {

      case .success(let savedShops):

        if let savedShops = savedShops {

          completion(.success(savedShops))
        }

      case .failure(let error):

        completion(.failure(error))
      }
    }
  }

  func fetchSavedShopsForAllCategory(user: User, completion: @escaping (Result<[UserSavedShops], Error>) -> Void) {

  let docRef = database.collection("users").document(user.id).collection("savedShops")

    docRef.getDocuments() { querySnapshot, error in

      if let error = error {

        print("Error getting documents: \(error)")

      } else {

        var savedShopsDoc: [UserSavedShops] = []

        for document in querySnapshot!.documents {

          do {
            if let shopDoc = try document.data(as: UserSavedShops.self, decoder: Firestore.Decoder()) {

              savedShopsDoc.append(shopDoc)
            }

          } catch {

            completion(.failure(error))
          }
        }
        completion(.success(savedShopsDoc))
      }
    }
  }

  func addNewCategory(user: User, category: String, savedShopDoc: inout UserSavedShops, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id).collection("savedShops").document(category)

    savedShopDoc.id = docRef.documentID

    savedShopDoc.category = category

    savedShopDoc.createdTime = Date().millisecondsSince1970

    docRef.setData(savedShopDoc.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Create New Category Success"))
      }
    }
  }

  // MARK: - User's block list
  func fetchBlockList(user: User, completion: @escaping (Result<[String], Error>) -> Void) {

    let docRef = database.collection("users").document(user.id)

    docRef.getDocument { querySnapshot, error in

      if let error = error {

        completion(.failure(error))

      } else if querySnapshot?.data() == nil {

        completion(.failure(UserError.notExistError))

      } else {

        var blockList: [String] = []

        do {

          if let user = try querySnapshot?.data(as: User.self, decoder: Firestore.Decoder()) {

            blockList = user.blockList

            completion(.success(blockList))
          }

        } catch {
          completion(.failure(error))
        }

      }
    }
  }

  func updateBlockList(user: User, unblockName: String, completion: @escaping (Result< String, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id)

    docRef.updateData([

      "blockList": FieldValue.arrayRemove([unblockName])

    ]) { error in

      if let error = error {

        print("Error updating document: \(error)")

      } else {

        print("Document successfully updated")
      }
    }
  }

  func blockUser(user: User, blockName: String, completion: @escaping (Result< String, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id)

    docRef.updateData([

      "blockList": FieldValue.arrayUnion([blockName])

    ]) { error in

      if let error = error {

        print("Error blockUser: \(error)")

      } else {

        print("User successfully blocked")
      }
    }
  }
}
