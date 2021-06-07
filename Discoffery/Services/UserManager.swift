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

  func identifyUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {

    database.collection("users").document(uid).getDocument { querySnapshot, error in

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

  func createUser(user: inout User, completion: @escaping (Result<String, Error>) -> Void) {

    let doc = database.collection("users").document(user.id)

    user.createdTime = Date().millisecondsSince1970

    doc.setData(user.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Create User Success"))
      }
    }
  }

  func createUserSavedShopsDefaultCategory(user: User, savedShop: inout UserSavedShops, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id).collection("savedShops").document("default")

    savedShop.id = docRef.documentID

    docRef.setData(savedShop.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Create User SavedShopsDefaultCategory Success"))
      }
    }
  }

  func addUserSavedShopToDefaultCategory (user: User, shop: CoffeeShop, savedShop: inout UserSavedShops, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id).collection("savedShops").document("default")

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

    let docRef = database.collection("users").document(user.id).collection("savedShops").document("default")

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

  func addNewCategory(user: User, category: String, savedShopDoc: inout UserSavedShops, completion: @escaping (Result<String, Error>) -> Void) {

    let docRef = database.collection("users").document(user.id).collection("savedShops").document()

    savedShopDoc.id = docRef.documentID

    savedShopDoc.category = category

    docRef.setData(savedShopDoc.toDict) { error in

      if let error = error {

        completion(.failure(error))

      } else {

        completion(.success("Create New Category Success"))
      }
    }
  }
}
