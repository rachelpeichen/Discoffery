//
//  UserViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/6.
//

import Foundation

class UserViewModel {

  var onWatchUser:((User) -> Void)?

  var onBlockListForReview: (([String]) -> Void)?

  var onBlockList: (([String]) -> Void)?

  var onUpdateBlockList: (() -> Void)?

  var blockList: [String] = [] {

    didSet {

      onBlockList?(blockList)
    }
  }

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

  func updateBlockList(user: User, unBlockName: String){

    UserManager.shared.updateBlockList(user: user, unblockName: unBlockName) { result in

      switch result {

      case .success:

        self.fetchBlockList(user: user)

      case .failure(let error):

        print("updateBlockList.error: \(error)")
      }
    }
  }

  // MARK: 直接監聽 這幾個block就可不用？
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
}
