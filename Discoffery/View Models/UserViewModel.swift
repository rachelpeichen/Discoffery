//
//  UserViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/6.
//

import Foundation

class UserViewModel {
  
  // MARK: - Closures For Notifying View Controllers
  var onWatchUser: ((User) -> Void)?

  var onBlockListForReview: (([String]) -> Void)?

  var onBlockList: (([String]) -> Void)?

  var onUpdateBlockList: (() -> Void)?
  
  // MARK: - Properties
  var blockList: [String] = [] {

    didSet {
      onBlockList?(blockList)
    }
  }

  // MARK: - TODO: Check if this function needed if using another sync method
  func fetchBlockList(user: User) {

    UserManager.shared.fetchBlockList(user: user) { result in

      switch result {

      case .success(let blockList):
        self.blockList = blockList
        self.onBlockList?(blockList)

      case .failure(let error):
        print("fetchBlockList.failure\(error)")
      }
    }
  }

  func fetchBlockListForReviews(user: User) {

    UserManager.shared.fetchBlockList(user: user) { result in

      switch result {

      case .success(let blockListForReview):
        self.onBlockListForReview?(blockListForReview)

      case .failure(let error):
        print("fetchBlockList.failure\(error)")
      }
    }
  }

  func updateBlockList(user: User, unBlockName: String) {

    UserManager.shared.updateBlockList(user: user, unblockName: unBlockName) { result in

      switch result {

      case .success:
        self.fetchBlockList(user: user)

      case .failure(let error):
        print("updateBlockList.error: \(error)")
      }
    }
  }

  func blockUser(user: User, blockName: String) {

    UserManager.shared.blockUser(user: user, blockName: blockName) { result in

      switch result {

      case .success:
        self.fetchBlockList(user: user)

      case .failure(let error):
        print("blockUse.error: \(error)")
      }
    }
  }

  // MARK: Update Profile Related Functions
  func watchUser() {

    UserManager.shared.watchUser { result in

      switch result {

      case .success(let user):
        self.onWatchUser?(user)

      case .failure(let error):
        print("watchUser.error: \(error)")
      }
    }
  }

  func updateUserName(user: User) {

    UserManager.shared.updateUserName(user: user) { result in
      switch result {

      case .success:
        print("updateUserName.success")

      case .failure(let error):
        print("updateUserName.error: \(error)")
      }
    }
  }

  func updateUserImg(user: User) {

    UserManager.shared.updateUserImg(user: user) { result in
      switch result {

      case .success:
        print("updateUserImg.success")

      case .failure(let error):
        print("updateUserImg.error: \(error)")
      }
    }
  }

  func updateUserNameAndImg(user: User) {

    UserManager.shared.updateUserNameAndImg(user: user) { result in
      switch result {

      case .success:
        print("updateUserImgAndImg.success")

      case .failure(let error):
        print("updateUserImgAndImg.error: \(error)")
      }
    }
  }
}
