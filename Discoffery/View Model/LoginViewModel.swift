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

  var onUserIdentified: (() -> Void)?

  var onUserCreated: (() -> Void)?

  var onUserIdentifyError: (() -> Void)?

  func identifyUser(uid: String) {

    UserManager.shared.identifyUser(firebaseUID: uid) { [weak self] result in

      switch result {

      case .success(let user):

        print(user)

        self?.onUserIdentified?()

      case .failure(let error):

        switch error {

        case UserError.notExistError: // Not found in Firestore's "users" collection so create one

          self?.createUser()

        default:

          self?.onUserIdentifyError?()

          print("identiftUser.failure\(error)")
        }
      }
    }
  }

  func createUser() {

    var createdUser = User(id: UserDefaults.standard.string(forKey: "FirebaseUID") ?? "uid",
                           name: UserDefaults.standard.string(forKey: "userName") ?? "User Name Not Provided",
                           profileImg: "https://firebasestorage.googleapis.com/v0/b/discoffery-30605.appspot.com/o/mockImg%2Fappearance.jpg?alt=media&token=6e486376-3925-4c36-940e-4e799ca84e15",
                           email: UserDefaults.standard.string(forKey: "userEmail") ?? "Email Not Provided",
                           createdTime: 0,
                           blockList: [])

    UserManager.shared.createUser(createdUser: &createdUser) { result in

      switch result {

      case .success:

        self.onUserCreated?()

        self.createUserSavedShopsDefaultCategory()

      case .failure(let error):

        self.onUserIdentifyError?()

        print("createUser.failure\(error)")
      }
    }
  }

  func createUserSavedShopsDefaultCategory() {

    var defaultSavedShop = UserSavedShops()

    UserManager.shared.createUserSavedShopsDefaultCategory(user: UserManager.shared.user, savedShop: &defaultSavedShop) { result in

      switch result {

      case .success:

        print("createUserSavedShopsDefaultCategory Success")

      case .failure(let error):

        print("createUserSavedShopsDefaultCategory.failure\(error)")
      }
    }
  }
}
