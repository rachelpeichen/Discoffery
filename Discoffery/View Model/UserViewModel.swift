//
//  UserViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/6.
//

import Foundation

class UserViewModel {

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

        print("🥴updateBlockList Success")

      case .failure(let error):

        print("updateBlockList.error: \(error)")
      }
    }
  }

  func blockUser(user: User, blockName: String){

    UserManager.shared.blockUser(user: user, blockName: blockName) { result in

      switch result {

      case .success:

        self.fetchBlockList(user: user)

        print("🥴blockUser Success")

      case .failure(let error):

        print("blockUse.error: \(error)")
      }
    }
  }
}
