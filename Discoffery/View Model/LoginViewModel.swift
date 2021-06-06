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

  func identifyUser() {

    UserManager.shared.identifyUser(uid: UserManager.shared.user.id) { [weak self] result in

      switch result {

      case .success(let user):

        UserManager.shared.user = user

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

    UserManager.shared.createUser(user: &UserManager.shared.user) { result in

      switch result {

      case .success:

        self.onUserCreated?()

        self.createUserSavedShopsDefaultCategory()

        print("Create user on FireStore's users collection Success")

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
