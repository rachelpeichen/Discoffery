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

  func addNewCategory() {
    
  }
}
