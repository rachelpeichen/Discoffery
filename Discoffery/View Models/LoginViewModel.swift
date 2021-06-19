//
//  LoginViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/5.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class LoginViewModel {

  // MARK: - Closures For Notifying LoginVC
  var onUserIdentified: (() -> Void)?

  var onUserCreated: (() -> Void)?

  var onUserIdentifyError: (() -> Void)?

  // MARK: - User Initial Setting Related Functions
  func identifyUser(uid: String) {

    UserManager.shared.identifyUser(firebaseUID: uid) { [weak self] result in

      switch result {

      case .success:
        self?.onUserIdentified?()

      case .failure(let error):

        switch error {

        case UserError.notExistError: // Not found in Firestore's "users" collection so need to create a document
          self?.createUser()

        default:
          self?.onUserIdentifyError?()
          print("identiftUser.error:\(error)")
        }
      }
    }
  }

  func createUser() {

    var createdUser = User(id: UserDefaults.standard.string(forKey: "FirebaseUID") ?? "uid",
                           name: UserDefaults.standard.string(forKey: "userName") ?? "User Name Not Provided",
                           profileImg: "https://firebasestorage.googleapis.com/v0/b/discoffery-30605.appspot.com/o/mockImg%2Fappearance.jpg?alt=media&token=6e486376-3925-4c36-940e-4e799ca84e15",
                           email: UserDefaults.standard.string(forKey: "userEmail") ?? "Email Not Provided",
                           blockList: [],
                           createdTime: 0)

    UserManager.shared.createUser(createdUser: &createdUser) { result in

      switch result {

      case .success:

        self.onUserCreated?()
        self.createDefaultCategory()

      case .failure(let error):

        self.onUserIdentifyError?()
        print("createUser.error:\(error)")
      }
    }
  }

  func createDefaultCategory() {

    var defaultSavedShop = UserSavedShops()

    UserManager.shared.createDefaultCollectionCategory(user: UserManager.shared.user,
                                                       savedShops: &defaultSavedShop) { result in

      switch result {

      case .success:
        print("createDefaultCategory.success")

      case .failure(let error):
        print("createDefaultCategory.error:\(error)")
      }
    }
  }
}
